using Ademero.NucleusOne.FolderMonitor.Service.Util;

namespace Ademero.NucleusOne.FolderMonitor.Service.App;

internal interface IPathsProvider {
  string GetProcessingPath(MonitoredFolder monitoredFolder);
  string GetUploadingFolderPath(MonitoredFolder monitoredFolder);
  string GetTrackingFolderPath(MonitoredFolder monitoredFolder);
  public string GetFailedUploadsFolderPath(MonitoredFolder monitoredFolder);
}

internal class PathsProvider : IPathsProvider {
  public PathsProvider(
      IFileProvider fileProvider,
      IDirectoryProvider directoryProvider,
      ILogger<PathsProvider> logger) {
    _fileProvider = fileProvider;
    _directoryProvider = directoryProvider;
    _logger = logger;
  }

  private readonly IFileProvider _fileProvider;
  private readonly IDirectoryProvider _directoryProvider;
  private readonly ILogger<PathsProvider> _logger;

  private static string ProcessingPathBase =>
    Path.Join(Program.ApplicationDataPath, "processing");

  public string GetProcessingPath(MonitoredFolder monitoredFolder) {
    var infoFileName = new InfoFileName(monitoredFolder);
    var processingPath = Path.Join(ProcessingPathBase, infoFileName.SafeId);

    // try to write an info file to make it easier to identify which
    // MonitoredFolder each processing folder is for.
    DeleteInfoFile(infoFileName, onlyIfNameChanged: true);
    WriteInfoFile(infoFileName);

    return processingPath;
  }

  public string GetUploadingFolderPath(MonitoredFolder monitoredFolder) {
    return Path.Join(GetProcessingPath(monitoredFolder), "uploading");
  }

  public string GetTrackingFolderPath(MonitoredFolder monitoredFolder) {
    return Path.Join(GetProcessingPath(monitoredFolder), "tracking");
  }

  public string GetFailedUploadsFolderPath(MonitoredFolder monitoredFolder) {
    return Path.Join(GetProcessingPath(monitoredFolder), "failed");
  }

  private void DeleteInfoFile(InfoFileName infoFileName, bool onlyIfNameChanged) {
    try {
      var infoFilePaths = _directoryProvider.EnumerateFiles(
        ProcessingPathBase, "*" + infoFileName.SafeId + infoFileName.Extension);
      foreach (var fp in infoFilePaths) {
        if (onlyIfNameChanged) {
          bool isSameName = Path.GetFileName(fp).Equals(
            infoFileName.FileName, StringComparison.Ordinal);
          if (!isSameName) {
            _fileProvider.Delete(fp);
          }
        } else {
          _fileProvider.Delete(fp);
        }
      }
    } catch (Exception ex) {
      _logger.LogInformation(ex,
        "Could not clean up processing folder info files. Check Permissions. {InfoPath}",
        GetProcessingPath(infoFileName.MonitoredFolder));
    }
  }

  /// <summary>
  /// Write a file to associate a processing folder with a MonitoredFolder.
  /// This is only for human convenience.
  /// </summary>
  /// <param name="infoFileName"></param>
  private void WriteInfoFile(InfoFileName infoFileName) {
    var infoPath = Path.Join(ProcessingPathBase, infoFileName.FileName);
    var mf = infoFileName.MonitoredFolder;
    try {
      var info = $"""
        Processing Folder: {infoFileName.SafeId}
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
        _ = _directoryProvider.CreateDirectory(ProcessingPathBase);
        _fileProvider.WriteAllText(infoPath, info);
      }
    } catch (Exception ex) {
      _logger.LogInformation(ex,
        "Could not write processing folder info file. Check Permissions. {InfoPath}",
        infoPath);
    }
  }
}

internal record InfoFileName {
  public InfoFileName(MonitoredFolder monitoredFolder) {
    MonitoredFolder = monitoredFolder;
    SafeId = MakeSafePathComponent(monitoredFolder.Id);
    Extension = ".txt";
    var safeName = MakeSafePathComponent(monitoredFolder.Name);
    FileName = safeName + " - " + SafeId + Extension;
  }

  public MonitoredFolder MonitoredFolder { get; }
  public string SafeId { get; }
  public string Extension { get; }
  public string FileName { get; }

  private static string MakeSafePathComponent(string component) {
    return Path
      .GetInvalidFileNameChars()
      .Aggregate(component, (acc, ch) => acc.Replace(ch, '_'))
      .Trim();
  }
}
