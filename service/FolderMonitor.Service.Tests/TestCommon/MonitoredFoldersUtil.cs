using Ademero.NucleusOne.FolderMonitor.Service.App;

namespace Ademero.NucleusOne.FolderMonitor.Service.Tests.TestCommon;

internal static class MonitoredFoldersUtil {
  public static IEnumerable<MonitoredFolder> UpdateAllMonitoredFolders(
      IEnumerable<MonitoredFolder> monitoredFolders,
      bool? enabled = null,
      string? inputFolder = null,
      FileDisposition? fileDisposition = null) {
    return monitoredFolders.Select(mf => UpdateMonitoredFolder(
      mf, enabled, inputFolder, fileDisposition));
  }

  public static MonitoredFolder UpdateMonitoredFolder(
      MonitoredFolder monitoredFolder,
      bool? enabled = null,
      string? inputFolder = null,
      FileDisposition? fileDisposition = null
  ) {
    var updated = monitoredFolder with {
      Enabled = enabled ?? monitoredFolder.Enabled,
      InputFolder = inputFolder ?? monitoredFolder.InputFolder
    };
    if (fileDisposition != null) {
      updated = fileDisposition switch {
        FileDisposition.Delete => monitoredFolder with {
          FileDisposition = new FileDispositionRaw() {
            RuntimeType = FileDispositionType.Delete,
            FolderPath = null
          }
        },
        FileDisposition.Move(var folderPath) => monitoredFolder with {
          FileDisposition = new FileDispositionRaw() {
            RuntimeType = FileDispositionType.Move,
            FolderPath = folderPath
          }
        },
        _ => throw new NotImplementedException(),
      };
    }
    return updated;
  }
}
