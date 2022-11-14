namespace Ademero.NucleusOne.FolderMonitor.Service.App;

internal interface IDocumentUploader {
  bool UploadDocument(MonitoredFolder monitoredFolder, string filePath);
}

internal class DocumentUploader : IDocumentUploader {
  public bool UploadDocument(MonitoredFolder monitoredFolder, string filePath) {
    return false;
  }
}

