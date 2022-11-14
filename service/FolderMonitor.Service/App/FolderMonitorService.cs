using Microsoft.Extensions.Options;

namespace Ademero.NucleusOne.FolderMonitor.Service.App;

internal interface IFolderMonitorService {
  void ProcessMonitoredFolders(CancellationToken stoppingToken);
}

internal class FolderMonitorService : IFolderMonitorService {
  public FolderMonitorService(
      IFileProcessor fileProcessor,
      IDocumentUploader documentUploader,
      IOptions<ApiKeyOptions> apiKeyOptions,
      IOptions<MonitoredFoldersByApiKeyOptions> monitoredFoldersByApiKeyOptions,
      ILogger<FolderMonitorService> logger) {
    _fileProcessor = fileProcessor;
    _documentUploader = documentUploader;
    _apiKeyOptions = apiKeyOptions.Value;
    _monitoredFoldersByApiKeyOptions = monitoredFoldersByApiKeyOptions.Value;
    _logger = logger;
  }

  private readonly IFileProcessor _fileProcessor;
  private readonly IDocumentUploader _documentUploader;
  private readonly ApiKeyOptions _apiKeyOptions;
  private readonly MonitoredFoldersByApiKeyOptions _monitoredFoldersByApiKeyOptions;
  private readonly ILogger<FolderMonitorService> _logger;

  public void ProcessMonitoredFolders(CancellationToken stoppingToken) {
    IEnumerable<MonitoredFolder> enabledMonitoredFolders = GetEnabledMonitoredFolders(
      _apiKeyOptions, _monitoredFoldersByApiKeyOptions);

    // Check for files that are ready to upload and move them for processing.
    // Group by input folder in case more than one monitor is configured for the
    // same input folder.
    var mfsGroupedByInputFolder = enabledMonitoredFolders
      .GroupBy(mf => Path.GetFullPath(mf.InputFolder), StringComparer.Ordinal);
    foreach (var mfs in mfsGroupedByInputFolder) {
      stoppingToken.ThrowIfCancellationRequested();
      _fileProcessor.MoveFilesReadyToUpload(mfs, mfs.Key);
    }

    // Get files to upload
    var filesToUploadByMonitoredFolder = enabledMonitoredFolders.Select(mf => {
      stoppingToken.ThrowIfCancellationRequested();
      return (monitoredFolder: mf, filePaths: _fileProcessor.GetFilesToUpload(mf));
    }).Where(x => x.filePaths.Any());

    // Upload files
    // TODO(apn): consider handling multiple uploads concurrently.
    foreach (var (mf, filePaths) in filesToUploadByMonitoredFolder) {
      stoppingToken.ThrowIfCancellationRequested();
      foreach (var filePath in filePaths) {
        // TODO(apn): handle upload errors
        if (_documentUploader.UploadDocument(mf, filePath)) {
          _fileProcessor.ProcessFileDisposition(mf, filePath);
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
}
