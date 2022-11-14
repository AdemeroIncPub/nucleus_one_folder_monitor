using Ademero.NucleusOne.FolderMonitor.Service.Util;
using SuperLinq;

namespace Ademero.NucleusOne.FolderMonitor.Service.App;
internal interface IFileProcessor {
  bool FileReadyToUpload(string filePath);
  void MoveFilesReadyToUpload(
    IEnumerable<MonitoredFolder> monitoredFoldersWithSameInputFolder, string inputFolder);
  IEnumerable<string> GetFilesToUpload(MonitoredFolder monitoredFolder);
  void ProcessFileDisposition(MonitoredFolder monitoredFolder, string filePath);
}

internal class FileProcessor : IFileProcessor {
  public FileProcessor(
      IFileProvider fileProvider,
      IDirectoryProvider directoryProvider,
      IDateTimeProvider dateTimeProvider,
      ILogger<FileProcessor> logger) {
    _dateTimeProvider = dateTimeProvider;
    _directoryProvider = directoryProvider;
    _fileProvider = fileProvider;
    _logger = logger;
  }

  private readonly IDateTimeProvider _dateTimeProvider;
  private readonly IDirectoryProvider _directoryProvider;
  private readonly IFileProvider _fileProvider;
  private readonly ILogger<FileProcessor> _logger;

  private static string ProcessingPathBase =>
    Path.Join(Program.ApplicationDataPath, "processing");

  internal string GetProcessingPath(MonitoredFolder mf) {
    var idPart = Path
      .GetInvalidFileNameChars()
      .Aggregate($"{mf.Id}", (acc, ch) => acc.Replace(ch, '_'))
      .Trim();
    var processingPath = Path.Join(ProcessingPathBase, idPart);

    // try to write an info file to make it easier to identify which
    // MonitoredFolder each processing folder is for.
    var infoPath = Path.Join(ProcessingPathBase, $"{idPart}.txt");
    try {
      var info = $"""
        Processing Folder: {idPart}
        Id: {mf.Id}
        Name: {mf.Name}
        Description: {mf.Description}
        InputFolder: {mf.InputFolder}
        """;

      if (_fileProvider.Exists(infoPath)) {
        var existingInfo = _fileProvider.ReadAllText(infoPath);
        if (existingInfo != info) {
          _fileProvider.WriteAllText(infoPath, info);
        }
      } else {
        _directoryProvider.CreateDirectory(processingPath);
        _fileProvider.WriteAllText(infoPath, info);
      }
    } catch {
      _logger.LogInformation(
        "Could not write processing folder info file. Check Permissions. {infoPath}",
        infoPath);
    }

    return processingPath;
  }

  internal string GetUploadingFolderPath(MonitoredFolder mf) {
    return Path.Join(GetProcessingPath(mf), "uploading");
  }

  public bool FileReadyToUpload(string filePath) {
    try {
      // include files where last write at least 5 minutes ago
      var lastWriteTime = _fileProvider.GetLastWriteTime(filePath);
      return lastWriteTime.AddMinutes(5) <= _dateTimeProvider.Now;
    } catch (Exception ex) {
      _logger.LogError(
        ex,
        "Failed to read file's LastWriteTime. Check Permissions. {filePath}",
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
        "Failed to read input folder or does not exist. Check Permissions. {inputFolder}",
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
        "Failed to read input folder. Check Permissions. {inputFolder}",
        inputFolder);
    }
  }

  public IEnumerable<string> GetFilesToUpload(MonitoredFolder monitoredFolder) {
    var uploadingPath = GetUploadingFolderPath(monitoredFolder);
    if (!_directoryProvider.Exists(uploadingPath)) {
      return Enumerable.Empty<string>();
    }

    try {
      return _directoryProvider.EnumerateFiles(uploadingPath);
    } catch (Exception ex) {
      _logger.LogError(
        ex,
        "Failed to read uploading folder. Check Permissions. {uploadingPath}",
        uploadingPath);
      return Enumerable.Empty<string>();
    }
  }

  public void ProcessFileDisposition(MonitoredFolder monitoredFolder, string filePath) {
    void delete() {
      try {
        _fileProvider.Delete(filePath);
      } catch (Exception ex) {
        const string msg = "File disposition processing failed. Unable to " +
          "delete file. This will result in duplicate document uploads. " +
          "Check permissions. ";
        _logger.LogCritical(ex, msg + "{filePath}", filePath);
        throw new CriticalException(msg + filePath, ex);
      }
    }

    void move(string folderPath) {
      var moveToFilePath = "";
      try {
        var fileName = Path.GetFileName(filePath);
        var maybeMoveToFilePath = Path.Join(folderPath, fileName);
        moveToFilePath = maybeMoveToFilePath; // for logging if error
        moveToFilePath = MakeAlternativeFilePathIfExists(maybeMoveToFilePath);
        _directoryProvider.CreateDirectory(folderPath);
        _fileProvider.Move(filePath, moveToFilePath);
        if (moveToFilePath != maybeMoveToFilePath) {
          _logger.LogInformation("Uploaded file moved as a copy because destination "
            + "already exists. {fileName} -> {moveToFilePath}", fileName, moveToFilePath);
        }
      } catch (Exception ex) {
        const string msg = "File disposition processing failed. Unable to " +
          "move file. This will result in duplicate document uploads. " +
          "Check permissions. ";
        _logger.LogCritical(ex, msg + "File: {filePath} Destination: {moveToFilePath}"
          , filePath, moveToFilePath);
        throw new CriticalException(msg + filePath, ex);
      }
    }

    switch (monitoredFolder.FileDispositionAsUnion) {
      case FileDisposition.Delete:
        delete();
        break;
      case FileDisposition.Move(var folderPath):
        move(folderPath);
        break;
      default:
        throw new NotImplementedException();
    }
  }

  private void MoveFileReadyToUpload(
      string filePath,
      IEnumerable<MonitoredFolder> monitoredFolders) {
    // If any destination already exists then skip and try again next loop
    var uploadingFilePaths = monitoredFolders
      .Select((mf) => {
        var folderPath = GetUploadingFolderPath(mf);
        string filename = Path.GetFileName(filePath);
        return Path.Join(folderPath, filename);
      }).ToList();
    if (uploadingFilePaths.Any(_fileProvider.Exists)) {
      return;
    }

    // Move the first one to be sure we can delete the original file, then
    // copy any additional from the first.
    foreach (var (i, uploadingFilePath) in uploadingFilePaths.Index()) {
      try {
        if (i == 0) {
          var dir = Path.GetDirectoryName(uploadingFilePath);
          _directoryProvider.CreateDirectory(dir!);
          _fileProvider.Move(filePath, uploadingFilePath);
        } else {
          _fileProvider.Copy(uploadingFilePaths[0], uploadingFilePath);
        }
      } catch (Exception ex) {
        _logger.LogError(
          ex,
          "Failed to move file for upload. Check Permissions. File: {filePath} Destination: {uploadingFilePath}",
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
      string suffix;
      if (i == 1) {
        suffix = " - Copy";
      } else {
        suffix = $" - Copy ({i})";
      }

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
