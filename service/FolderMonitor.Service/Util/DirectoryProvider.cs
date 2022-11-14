using System.Diagnostics.CodeAnalysis;
using System.Runtime.Versioning;

namespace Ademero.NucleusOne.FolderMonitor.Service.Util;

internal interface IDirectoryProvider {
  /// <inheritdoc cref="Directory.Exists"></inheritdoc>
  bool Exists([NotNullWhen(true)] string? path);

  /// <inheritdoc cref="Directory.CreateDirectory"></inheritdoc>
  DirectoryInfo CreateDirectory(string path);

  /// <inheritdoc cref="Directory.CreateDirectory"></inheritdoc>
  [UnsupportedOSPlatform("windows")]
  DirectoryInfo CreateDirectory(string path, UnixFileMode unixCreateMode);

  /// <inheritdoc cref="Directory.EnumerateFiles"></inheritdoc>
  IEnumerable<string> EnumerateFiles(string path);
}

internal class DirectoryProvider : IDirectoryProvider {
  public bool Exists([NotNullWhen(true)] string? path) {
    return Directory.Exists(path);
  }

  public DirectoryInfo CreateDirectory(string path) {
    return Directory.CreateDirectory(path);
  }

  [UnsupportedOSPlatform("windows")]
  public DirectoryInfo CreateDirectory(string path, UnixFileMode unixCreateMode) {
    return Directory.CreateDirectory(path, unixCreateMode);
  }

  public IEnumerable<string> EnumerateFiles(string path) {
    return Directory.EnumerateFiles(path);
  }
}
