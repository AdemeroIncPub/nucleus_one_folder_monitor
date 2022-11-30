using Ademero.NucleusOne.FolderMonitor.Service.Util;
using SuperLinq;

namespace Ademero.NucleusOne.FolderMonitor.Service.App;
internal interface IFileProcessor {
  bool FileReadyToUpload(string filePath);
  void MoveFilesReadyToUpload(
    IEnumerable<MonitoredFolder> monitoredFoldersWithSameInputFolder, string inputFolder);
  IEnumerable<string> GetFilesToUpload(MonitoredFolder monitoredFolder);
  void ProcessFileDisposition(MonitoredFolder monitoredFolder, string filePath);
  void MoveFailedUpload(MonitoredFolder monitoredFolder, string filePath);
}

internal class FileProcessor : IFileProcessor {
  public FileProcessor(
      IFileTracker fileTracker,
      IPathsProvider pathsProvider,
      IFileProvider fileProvider,
      IDirectoryProvider directoryProvider,
      IDateTimeOffsetProvider dateTimeProvider,
      ILogger<FileProcessor> logger) {
    _fileTracker = fileTracker;
    _pathsProvider = pathsProvider;
    _dateTimeProvider = dateTimeProvider;
    _directoryProvider = directoryProvider;
    _fileProvider = fileProvider;
    _logger = logger;
  }

  private readonly IFileTracker _fileTracker;
  private readonly IPathsProvider _pathsProvider;
  private readonly IDateTimeOffsetProvider _dateTimeProvider;
  private readonly IDirectoryProvider _directoryProvider;
  private readonly IFileProvider _fileProvider;
  private readonly ILogger<FileProcessor> _logger;

  public bool FileReadyToUpload(string filePath) {
    try {
      // include files where last write at least 5 minutes ago
      var lastWriteTime = _fileProvider.GetLastWriteTime(filePath);
      return lastWriteTime.AddMinutes(5) <= _dateTimeProvider.Now;
    } catch (Exception ex) {
      _logger.LogError(
        ex,
        "Failed to read file's LastWriteTime. Check Permissions. {FilePath}",
        filePath);
      return false;
    }
  }

  public void MoveFilesReadyToUpload(
      IEnumerable<MonitoredFolder> monitoredFoldersWithSameInputFolder,
      string inputFolder) {
    // Check all input folders are the same
    inputFolder = Path.GetFullPath(inputFolder);
    var allInputFoldersEqual = monitoredFoldersWithSameInputFolder
      .All(mf => {
        var mfInputFolder = Path.GetFullPath(mf.InputFolder);
        return mfInputFolder.Equals(inputFolder, StringComparison.Ordinal);
      });
    if (!allInputFoldersEqual) {
      throw new ArgumentException("All input folders must be the same.");
    }

    if (!_directoryProvider.Exists(inputFolder)) {
      _logger.LogInformation(
        "Failed to read input folder or does not exist. Check Permissions. {InputFolder}",
        inputFolder);
      return;
    }

    try {
      _directoryProvider.EnumerateFiles(inputFolder)
        .Where(FileReadyToUpload)
        .ForEach(filePath => MoveFileReadyToUpload(filePath, monitoredFoldersWithSameInputFolder));
    } catch (Exception ex) {
      _logger.LogError(
        ex,
        "Failed to read input folder. Check Permissions. {InputFolder}",
        inputFolder);
    }
  }

  public IEnumerable<string> GetFilesToUpload(MonitoredFolder monitoredFolder) {
    var uploadingPath = _pathsProvider.GetUploadingFolderPath(monitoredFolder);
    if (!_directoryProvider.Exists(uploadingPath)) {
      return Enumerable.Empty<string>();
    }

    try {
      return _directoryProvider.EnumerateFiles(uploadingPath);
    } catch (Exception ex) {
      _logger.LogError(
        ex,
        "Failed to read uploading folder. Check Permissions. {UploadingPath}",
        uploadingPath);
      return Enumerable.Empty<string>();
    }
  }

  public void ProcessFileDisposition(MonitoredFolder monitoredFolder, string filePath) {
    void move(string folderPath) {
      var fileName = Path.GetFileName(filePath);
      var moveToFilePath = Path.Join(folderPath, fileName);
      var originalMoveToFilePath = moveToFilePath; // for logging if file exists
      moveToFilePath = MakeAlternativeFilePathIfExists(moveToFilePath);
      _ = _directoryProvider.CreateDirectory(folderPath);
      _fileProvider.Move(filePath, moveToFilePath);
      if (moveToFilePath != originalMoveToFilePath) {
        _logger.LogInformation("Uploaded file moved as a copy because destination "
          + "already exists. {FilePath} -> {MoveToFilePath}", filePath, moveToFilePath);
      }
    }

    switch (monitoredFolder.FileDispositionAsUnion) {
      case FileDisposition.Delete:
        _fileProvider.Delete(filePath);
        break;
      case FileDisposition.Move(var folderPath):
        move(folderPath);
        break;
      default:
        throw new NotImplementedException();
    }
  }

  public void MoveFailedUpload(MonitoredFolder monitoredFolder, string filePath) {
    var failedFolderPath = _pathsProvider.GetFailedUploadsFolderPath(monitoredFolder);
    _ = _directoryProvider.CreateDirectory(failedFolderPath);
    var moveToFilePath = Path.Join(failedFolderPath, Path.GetFileName(filePath));
    moveToFilePath = MakeAlternativeFilePathIfExists(moveToFilePath);
    _fileProvider.Move(filePath, moveToFilePath);
  }

  private void MoveFileReadyToUpload(
      string filePath,
      IEnumerable<MonitoredFolder> monitoredFolders) {
    // If any destination already exists then skip and try again next loop
    var uploadingInfo = monitoredFolders
      .Select((mf) => {
        var folderPath = _pathsProvider.GetUploadingFolderPath(mf);
        string filename = Path.GetFileName(filePath);
        return (mf, filePath: Path.Join(folderPath, filename));
      }).ToList();
    if (uploadingInfo.Any(info => _fileProvider.Exists(info.filePath))) {
      return;
    }

    // Move the first one to be sure we can delete the original file, then
    // copy any additional from the first.
    foreach (var (i, (mf, uploadingFilePath)) in uploadingInfo.Index()) {
      try {
        if (i == 0) {
          _fileTracker.CreateTrackingFile(mf, uploadingFilePath);
          var dir = Path.GetDirectoryName(uploadingFilePath);
          _ = _directoryProvider.CreateDirectory(dir!);
          _fileProvider.Move(filePath, uploadingFilePath);
        } else {
          _fileProvider.Copy(uploadingInfo[0].filePath, uploadingFilePath);
        }
      } catch (Exception ex) {
        _logger.LogError(
          ex,
          "Failed to move file for upload. Check Permissions. File: {FilePath} Destination: {UploadingFilePath}",
          filePath,
          uploadingFilePath);
        if (i == 0) {
          return;
        }
        // Not returning if i > 0. Recovery is difficult at this point since
        // the original file was moved and other copy operations may have
        // succeeded. It should be incredibly rare for the file to fail to
        // write to some uploading paths and not others (even having more than
        // one monitor checking the same input folder should be very rare).
      }
    }
  }

  private string MakeAlternativeFilePathIfExists(string filePath) {
    string? dir = null;
    string? ext = null;
    string? baseName = null;
    var i = 0;
    var newFilePath = filePath;
    while (_fileProvider.Exists(newFilePath)) {
      i++;
      string suffix = i == 1
        ? " - Copy"
        : $" - Copy ({i})";
      if (dir == null) {
        dir = Path.GetDirectoryName(filePath);
        ext = Path.GetExtension(filePath);
        baseName = Path.GetFileNameWithoutExtension(filePath);
      }
#pragma warning disable RCS1249 // Unnecessary null-forgiving operator. bug? Path.GetDirectoryName can return null.
      newFilePath = Path.Join(dir!, baseName! + suffix! + ext!);
#pragma warning restore RCS1249 // Unnecessary null-forgiving operator.
    }
    return newFilePath;
  }
}
