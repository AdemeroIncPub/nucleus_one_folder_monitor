using Ademero.NucleusOne.FolderMonitor.Service.Util;
using System.Text.Json;

namespace Ademero.NucleusOne.FolderMonitor.Service.App;

internal record FileTrackingState {
  public required string MonitoredFolderId { get; init; }
  public required string UploadingFilePath { get; init; }
  public int UploadAttempts { get; init; }
  public bool UploadSuccess { get; init; }
  public DateTimeOffset? FirstUploadAttempt { get; init; }
  public DateTimeOffset? LastUploadAttempt { get; init; }

  public static FileTrackingState Create(
      MonitoredFolder monitoredFolder,
      string uploadingFilePath) =>
    new FileTrackingState {
      MonitoredFolderId = monitoredFolder.Id,
      UploadingFilePath = uploadingFilePath,
    };
}

internal interface IFileTracker {
  string GetTrackingFilePath(MonitoredFolder mf, string uploadingFilePath);
  void CreateTrackingFile(MonitoredFolder monitoredFolder, string uploadingFilePath);
  void TrackUploadAttempt(MonitoredFolder monitoredFolder, string uploadingFilePath);
  void TrackUploadSuccess(MonitoredFolder monitoredFolder, string uploadingFilePath);
  IEnumerable<FileTrackingState> GetAllStates(MonitoredFolder monitoredFolder);
  FileTrackingState GetState(MonitoredFolder monitoredFolder, string uploadingFilePath);
  void DeleteTrackingFile(MonitoredFolder monitoredFolder, string uploadingFilePath);
}

internal class FileTracker : IFileTracker {
  public FileTracker(
      IPathsProvider pathsProvider,
      IFileProvider fileProvider,
      IDirectoryProvider directoryProvider,
      IDateTimeOffsetProvider dateTimeProvider,
      ILogger<FileTracker> logger) {
    _pathsProvider = pathsProvider;
    _fileProvider = fileProvider;
    _directoryProvider = directoryProvider;
    _dateTimeProvider = dateTimeProvider;
    _logger = logger;
  }
  
  private readonly IPathsProvider _pathsProvider;
  private readonly IFileProvider _fileProvider;
  private readonly IDirectoryProvider _directoryProvider;
  private readonly IDateTimeOffsetProvider _dateTimeProvider;
  private readonly ILogger<FileTracker> _logger;

  public string GetTrackingFilePath(MonitoredFolder mf, string uploadingFilePath) {
    var trackingFolderPath = _pathsProvider.GetTrackingFolderPath(mf);
    var fileName = Path.GetFileName(uploadingFilePath);
    return Path.Join(trackingFolderPath, fileName);
  }

  public void CreateTrackingFile(MonitoredFolder monitoredFolder, string uploadingFilePath) {
    var state = FileTrackingState.Create(monitoredFolder, uploadingFilePath);
    WriteState(state, monitoredFolder, uploadingFilePath);
  }

  public void DeleteTrackingFile(MonitoredFolder monitoredFolder, string uploadingFilePath) {
    _fileProvider.Delete(GetTrackingFilePath(monitoredFolder, uploadingFilePath));
  }

  public IEnumerable<FileTrackingState> GetAllStates(MonitoredFolder monitoredFolder) {
    var trackingFolderPath = _pathsProvider.GetTrackingFolderPath(monitoredFolder);
    if (!_directoryProvider.Exists(trackingFolderPath)) {
      yield break;
    }

    var trackingFiles = _directoryProvider.EnumerateFiles(trackingFolderPath);
    foreach (var filePath in trackingFiles) {
      FileTrackingState? state = null;
      try {
        state = ReadState(filePath);
      } catch (Exception ex) {
        _logger.LogInformation(ex, "Failed to read tracking file {filePath}.", filePath);
      }
      if (state != null) {
        yield return state;
      }
    }
  }

  public FileTrackingState GetState(MonitoredFolder monitoredFolder, string uploadingFilePath) {
    var trackingFilePath = GetTrackingFilePath(monitoredFolder, uploadingFilePath);
    if (!_fileProvider.Exists(trackingFilePath)) {
      var state = FileTrackingState.Create(monitoredFolder, uploadingFilePath);
      WriteState(state, monitoredFolder, uploadingFilePath);
      return state;
    }
    return ReadState(trackingFilePath);
  }

  public void TrackUploadAttempt(MonitoredFolder monitoredFolder, string uploadingFilePath) {
    var state = GetState(monitoredFolder, uploadingFilePath);
    var now = _dateTimeProvider.Now;
    if (state.FirstUploadAttempt == null) {
      state = state with { FirstUploadAttempt = now, LastUploadAttempt = now };
    } else {
      state = state with { LastUploadAttempt = now };
    }
    state = state with { UploadAttempts = state.UploadAttempts + 1 };

    WriteState(state, monitoredFolder, uploadingFilePath);
  }

  public void TrackUploadSuccess(MonitoredFolder monitoredFolder, string uploadingFilePath) {
    try {
      var state = GetState(monitoredFolder, uploadingFilePath);
      state = state with { UploadSuccess = true };
      WriteState(state, monitoredFolder, uploadingFilePath);
    } catch (Exception ex) {
      var trackingFilePath = GetTrackingFilePath(monitoredFolder, uploadingFilePath);
      const string msg = "Failed to track upload success. This will result in " +
        "duplicate document uploads. Check Permissions. ";
      _logger.LogCritical(ex, msg + "{trackingFilePath}", trackingFilePath);
      throw new CriticalException(msg + $"{trackingFilePath}", ex);
    }
  }

  private FileTrackingState ReadState(string trackingFilePath) {
    string json = _fileProvider.ReadAllText(trackingFilePath);
    return JsonSerializer.Deserialize<FileTrackingState>(json)!;
  }

  private void WriteState(
      FileTrackingState state,
      MonitoredFolder monitoredFolder,
      string uploadingFilePath) {
    string json = JsonSerializer.Serialize(state);
    _directoryProvider.CreateDirectory(_pathsProvider.GetTrackingFolderPath(monitoredFolder));
    var trackingFilePath = GetTrackingFilePath(monitoredFolder, uploadingFilePath);
    _fileProvider.WriteAllText(trackingFilePath, json);
  }
}
