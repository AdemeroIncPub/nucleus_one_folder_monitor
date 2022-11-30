using Ademero.NucleusOne.FolderMonitor.Service.Util;
using Microsoft.Extensions.Options;

namespace Ademero.NucleusOne.FolderMonitor.Service.App;

internal interface IFolderMonitorService {
  Task ProcessMonitoredFoldersAsync(CancellationToken stoppingToken);
}

internal class FolderMonitorService : IFolderMonitorService {
  public FolderMonitorService(
      IFileProcessor fileProcessor,
      IFileTracker fileTracker,
      IDocumentUploader documentUploader,
      IDateTimeOffsetProvider dateTimeProvider,
      IOptions<ApiKeyOptions> apiKeyOptions,
      IOptions<MonitoredFoldersByApiKeyOptions> monitoredFoldersByApiKeyOptions,
      ILogger<FolderMonitorService> logger) {
    _fileProcessor = fileProcessor;
    _fileTracker = fileTracker;
    _documentUploader = documentUploader;
    _dateTimeProvider = dateTimeProvider;
    _apiKeyOptions = apiKeyOptions.Value;
    _monitoredFoldersByApiKeyOptions = monitoredFoldersByApiKeyOptions.Value;
    _logger = logger;
  }

  private readonly IFileProcessor _fileProcessor;
  private readonly IFileTracker _fileTracker;
  private readonly IDocumentUploader _documentUploader;
  private readonly IDateTimeOffsetProvider _dateTimeProvider;
  private readonly ApiKeyOptions _apiKeyOptions;
  private readonly MonitoredFoldersByApiKeyOptions _monitoredFoldersByApiKeyOptions;
  private readonly ILogger<FolderMonitorService> _logger;

  private const int MaxAttempts = 10;

  public Task ProcessMonitoredFoldersAsync(CancellationToken stoppingToken) {
    IEnumerable<MonitoredFolder> enabledMonitoredFolders = GetEnabledMonitoredFolders(
      _apiKeyOptions, _monitoredFoldersByApiKeyOptions);
    MoveFilesReadyToUpload(enabledMonitoredFolders, stoppingToken);
    MoveFailedUploads(enabledMonitoredFolders, stoppingToken);
    return UploadFilesAsync(enabledMonitoredFolders, stoppingToken);
  }

  internal void MoveFilesReadyToUpload(
      IEnumerable<MonitoredFolder> enabledMonitoredFolders,
      CancellationToken stoppingToken) {
    // Check for files that are ready to upload and move them for processing.
    // Group by input folder in case more than one monitor is configured for the
    // same input folder.
    var mfsGroupedByInputFolder = enabledMonitoredFolders
      .GroupBy(mf => Path.GetFullPath(mf.InputFolder), StringComparer.Ordinal);
    foreach (var mfs in mfsGroupedByInputFolder) {
      stoppingToken.ThrowIfCancellationRequested();
      _fileProcessor.MoveFilesReadyToUpload(mfs, mfs.Key);
    }
  }

  internal void MoveFailedUploads(
      IEnumerable<MonitoredFolder> enabledMonitoredFolders,
      CancellationToken stoppingToken) {
    foreach (var mf in enabledMonitoredFolders) {
      var states = _fileTracker.GetAllStates(mf);
      var failedUploads = states.Where(s => s.UploadAttempts >= MaxAttempts);

      foreach (var state in failedUploads) {
        stoppingToken.ThrowIfCancellationRequested();
        try {
          _fileProcessor.MoveFailedUpload(mf, state.UploadingFilePath);
          _fileTracker.DeleteTrackingFile(mf, state.UploadingFilePath);
        } catch (CriticalException) {
          throw;
        } catch (Exception ex) {
          _logger.LogError(
            ex,
            "Failed to process failed upload {failedUpload}. Check Permissions.",
            state.UploadingFilePath);
        }
      }
    }
  }

  internal async Task UploadFilesAsync(
      IEnumerable<MonitoredFolder> enabledMonitoredFolders,
      CancellationToken stoppingToken) {
    // Get files to upload
    var filesToUploadByMonitoredFolder = enabledMonitoredFolders.Select(mf => {
      stoppingToken.ThrowIfCancellationRequested();
      return (monitoredFolder: mf, filePaths: _fileProcessor.GetFilesToUpload(mf));
    }).Where(x => x.filePaths.Any());

    // Upload files
    // TODO(apn): consider handling multiple uploads concurrently.
    foreach (var (mf, filePaths) in filesToUploadByMonitoredFolder) {
      foreach (var filePath in filePaths) {
        stoppingToken.ThrowIfCancellationRequested();
        try {
          var state = _fileTracker.GetState(mf, filePath);
          if (!ShouldAttemptUpload(state)) {
            continue;
          }

          _fileTracker.TrackUploadAttempt(mf, filePath);
          await _documentUploader.UploadDocumentAsync(mf, filePath);
        } catch (CriticalException) {
          throw;
        } catch (Exception ex) {
          _logger.LogWarning(ex, "Error uploading document {filePath}", filePath);
          continue;
        }

        try {
          _fileTracker.TrackUploadSuccess(mf, filePath);
          _fileProcessor.ProcessFileDisposition(mf, filePath);
          _fileTracker.DeleteTrackingFile(mf, filePath);
        } catch (CriticalException) {
          throw;
        } catch (Exception ex) {
          _logger.LogWarning(ex, "Failed post-processing for uploaded document {filePath}", filePath);
        }
      }
    }
  }

  internal static IEnumerable<MonitoredFolder> GetEnabledMonitoredFolders(
      ApiKeyOptions apiKeyOptions,
      MonitoredFoldersByApiKeyOptions monitoredFoldersByApiKeyOptions) {
    return monitoredFoldersByApiKeyOptions
      .MonitoredFoldersByApiKey
      .GetValueOrDefault(apiKeyOptions.ApiKey, Array.Empty<MonitoredFolder>())
      .Where(mf => mf.Enabled);
  }

  private bool ShouldAttemptUpload(FileTrackingState state) {
    if (state.UploadSuccess) {
      return false;
    }
    if (state.LastUploadAttempt == null) {
      return true;
    }

    // Simple backoff strategy
    var now = _dateTimeProvider.Now;
    var lastUploadAttempt = state.LastUploadAttempt.Value;
    return state.UploadAttempts switch {
      < 3 => now.Subtract(lastUploadAttempt) >= TimeSpan.FromMinutes(1),
      < 6 => now.Subtract(lastUploadAttempt) >= TimeSpan.FromMinutes(5),
      < MaxAttempts => now.Subtract(lastUploadAttempt) >= TimeSpan.FromMinutes(60),
      _ => false
    };
  }
}
