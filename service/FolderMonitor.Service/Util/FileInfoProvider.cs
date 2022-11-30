namespace Ademero.NucleusOne.FolderMonitor.Service.Util;

internal interface IFileInfoProvider {
  IFileInfo Create(string fileName);
}

internal class FileInfoProvider : IFileInfoProvider {
  public IFileInfo Create(string fileName) {
    return new FileInfoWrapper(new FileInfo(fileName));
  }
}

internal interface IFileInfo {
  /// <inheritdoc cref="FileInfo.Length"></inheritdoc>
  long Length { get; }
}

internal class FileInfoWrapper : IFileInfo {
  public FileInfoWrapper(FileInfo fileInfo) {
    _fileInfo = fileInfo;
  }

  private readonly FileInfo _fileInfo;

  public long Length => _fileInfo.Length;
}
