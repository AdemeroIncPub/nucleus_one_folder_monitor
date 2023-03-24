using System.Diagnostics.CodeAnalysis;
using System.Runtime.Versioning;

namespace Ademero.NucleusOne.FolderMonitor.Service.Util;

internal interface IDirectoryInfo { }

internal class DirectoryInfoWrapper : IDirectoryInfo {
  public DirectoryInfoWrapper(DirectoryInfo directoryInfo) {
    _directoryInfo = directoryInfo;
  }

  private readonly DirectoryInfo _directoryInfo;
}

internal interface IDirectoryProvider {
  /// <inheritdoc cref="Directory.Exists"></inheritdoc>
  bool Exists([NotNullWhen(true)] string? path);

  /// <inheritdoc cref="Directory.CreateDirectory"></inheritdoc>
  IDirectoryInfo CreateDirectory(string path);

  /// <inheritdoc cref="Directory.CreateDirectory"></inheritdoc>
  [UnsupportedOSPlatform("windows")]
  IDirectoryInfo CreateDirectory(string path, UnixFileMode unixCreateMode);

  /// <inheritdoc cref="Directory.EnumerateFiles"></inheritdoc>
  IEnumerable<string> EnumerateFiles(string path);

  /// <inheritdoc cref="Directory.EnumerateFiles"></inheritdoc>
  IEnumerable<string> EnumerateFiles(string path, string searchPattern);
}

internal class DirectoryProvider : IDirectoryProvider {
  public bool Exists([NotNullWhen(true)] string? path) {
    return Directory.Exists(path);
  }

  public IDirectoryInfo CreateDirectory(string path) {
    return new DirectoryInfoWrapper(Directory.CreateDirectory(path));
  }

  [UnsupportedOSPlatform("windows")]
  public IDirectoryInfo CreateDirectory(string path, UnixFileMode unixCreateMode) {
    return new DirectoryInfoWrapper(Directory.CreateDirectory(path, unixCreateMode));
  }

  public IEnumerable<string> EnumerateFiles(string path) {
    // EnumerateFiles may cause StackoverflowException if the path does not
    // exist - not sure where this is documented or maybe a .NET bug.
    if (!Exists(path)) {
      return Enumerable.Empty<string>();
    }
    return Directory.EnumerateFiles(path);
  }

  public IEnumerable<string> EnumerateFiles(string path, string searchPattern) {
    // EnumerateFiles may cause StackoverflowException if the path does not
    // exist - not sure where this is documented or maybe a .NET bug.
    if (!Exists(path)) {
      return Enumerable.Empty<string>();
    }
    return Directory.EnumerateFiles(path, searchPattern);
  }
}
