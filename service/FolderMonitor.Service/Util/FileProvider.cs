using System.Diagnostics.CodeAnalysis;
using System.Text;

namespace Ademero.NucleusOne.FolderMonitor.Service.Util;

internal interface IFileProvider {
  /// <inheritdoc cref="File.Exists"></inheritdoc>
  bool Exists([NotNullWhen(true)] string? path);

  /// <inheritdoc cref="File.GetLastWriteTime"></inheritdoc>
  DateTime GetLastWriteTime(string path);

  /// <inheritdoc cref="File.Copy"></inheritdoc>
  void Copy(string sourceFileName, string destFileName);

  /// <inheritdoc cref="File.Copy"></inheritdoc>
  void Copy(string sourceFileName, string destFileName, bool overwrite);

  /// <inheritdoc cref="File.Move"></inheritdoc>
  void Move(string sourceFileName, string destFileName);

  /// <inheritdoc cref="File.Delete"></inheritdoc>
  void Delete(string path);

  /// <inheritdoc cref="File.OpenRead"></inheritdoc>
  FileStream OpenRead(string path);

  /// <inheritdoc cref="File.ReadAllText"></inheritdoc>
  string ReadAllText(string path);

  /// <inheritdoc cref="File.ReadAllText"></inheritdoc>
  string ReadAllText(string path, Encoding encoding);

  /// <inheritdoc cref="File.WriteAllText"></inheritdoc>
  void WriteAllText(string path, string? contents);

  /// <inheritdoc cref="File.WriteAllText"></inheritdoc>
  void WriteAllText(string path, string? contents, Encoding encoding);
}

internal class FileProvider : IFileProvider {
  public bool Exists([NotNullWhen(true)] string? path) {
    return File.Exists(path);
  }

  public DateTime GetLastWriteTime(string path) {
    return File.GetLastWriteTime(path);
  }

  public void Copy(string sourceFileName, string destFileName) {
    File.Copy(sourceFileName, destFileName);
  }

  public void Copy(string sourceFileName, string destFileName, bool overwrite) {
    File.Copy(sourceFileName, destFileName, overwrite);
  }

  public void Move(string sourceFileName, string destFileName) {
    File.Move(sourceFileName, destFileName);
  }

  public void Delete(string path) {
    File.Delete(path);
  }

  public FileStream OpenRead(string path) {
    return File.OpenRead(path);
  }

  public string ReadAllText(string path) {
    return File.ReadAllText(path);
  }

  public string ReadAllText(string path, Encoding encoding) {
    return File.ReadAllText(path, encoding);
  }

  public void WriteAllText(string path, string? contents) {
    File.WriteAllText(path, contents);
  }

  public void WriteAllText(string path, string? contents, Encoding encoding) {
    File.WriteAllText(path, contents, encoding);
  }
}
