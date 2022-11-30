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
    var mf = monitoredFolder;
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
        _ = _directoryProvider.CreateDirectory(processingPath);
        _fileProvider.WriteAllText(infoPath, info);
      }
    } catch {
      _logger.LogInformation(
        "Could not write processing folder info file. Check Permissions. {InfoPath}",
        infoPath);
    }

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
}
