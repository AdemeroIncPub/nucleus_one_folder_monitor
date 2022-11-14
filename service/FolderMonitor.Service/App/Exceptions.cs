namespace Ademero.NucleusOne.FolderMonitor.Service.App;

internal class FolderMonitorException : Exception {
  public FolderMonitorException() { }

  public FolderMonitorException(string message)
      : base(message) { }

  public FolderMonitorException(string message, Exception inner)
      : base(message, inner) { }
}

internal class CriticalException : FolderMonitorException {
  public CriticalException() { }

  public CriticalException(string message)
      : base(message) { }

  public CriticalException(string message, Exception inner)
      : base(message, inner) { }
}
