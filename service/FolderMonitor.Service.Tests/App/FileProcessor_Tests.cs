using Ademero.NucleusOne.FolderMonitor.Service.App;
using Ademero.NucleusOne.FolderMonitor.Service.Tests.TestCommon;
using Ademero.NucleusOne.FolderMonitor.Service.Util;
using AutoFixture;
using AutoFixture.Xunit2;
using NSubstitute;
using NSubstitute.ExceptionExtensions;
using Shouldly;
using SuperLinq;

namespace Ademero.NucleusOne.FolderMonitor.Service.Tests.App;

public class FileProcessor_Tests : TestBase {
  [Theory]
  [AutoDomainData]
  internal void FileReadyToUpload_LastWriteTimeAtLeast5MinutesAgo_True(
    string filePath,
    [Frozen] IFileProvider fileProvider,
    [Frozen] IDateTimeOffsetProvider dateTimeProvider,
    FileProcessor sut
  ) {
    var now = DateTime.Now;
    dateTimeProvider.Now.Returns(now);
    fileProvider.GetLastWriteTime(filePath).Returns(now.AddMinutes(-5));

    sut.FileReadyToUpload(filePath).ShouldBeTrue();
  }

  [Theory]
  [AutoDomainData]
  internal void FileReadyToUpload_LastWriteTimeLessThan5MinutesAgo_False(
    string filePath,
    [Frozen] IFileProvider fileProvider,
    [Frozen] IDateTimeOffsetProvider dateTimeProvider,
    FileProcessor sut
  ) {
    var now = DateTime.Now;
    dateTimeProvider.Now.Returns(now);
    fileProvider.GetLastWriteTime(filePath).Returns(now.AddMinutes(-3));

    sut.FileReadyToUpload(filePath).ShouldBeFalse();
  }

  [Theory]
  [AutoDomainData]
  internal void FileReadyToUpload_ThrowsUnauthorizedAccessException_False(
    string filePath,
    [Frozen] IFileProvider fileProvider,
    [Frozen] IDateTimeOffsetProvider dateTimeProvider,
    FileProcessor sut
  ) {
    var now = DateTime.Now;
    dateTimeProvider.Now.Returns(now);
    fileProvider.GetLastWriteTime(filePath).Throws<UnauthorizedAccessException>();

    sut.FileReadyToUpload(filePath).ShouldBeFalse();
  }

  [Theory]
  [AutoDomainData]
  internal void GetFilesToUpload_UploadingDirectoryDoesNotExist_Empty(
    MonitoredFolder monitoredFolder,
    [Frozen] IPathsProvider pathsProvider,
    [Frozen] IDirectoryProvider directoryProvider,
    FileProcessor sut
  ) {
    var uploadingFolderPath = "UploadingFolderPath";
    pathsProvider.GetUploadingFolderPath(monitoredFolder)
      .Returns(uploadingFolderPath);
    directoryProvider.Exists(uploadingFolderPath).Returns(false);
    sut.GetFilesToUpload(monitoredFolder).ShouldBeEmpty();
  }

  [Theory]
  [AutoDomainData]
  internal void GetFilesToUpload_NoFiles_Empty(
    MonitoredFolder monitoredFolder,
    [Frozen] IPathsProvider pathsProvider,
    [Frozen] IDirectoryProvider directoryProvider,
    FileProcessor sut
  ) {
    var uploadingFolderPath = "UploadingFolderPath";
    pathsProvider.GetUploadingFolderPath(monitoredFolder)
      .Returns(uploadingFolderPath);
    directoryProvider.Exists(uploadingFolderPath).Returns(true);
    directoryProvider.EnumerateFiles(uploadingFolderPath)
      .Returns(Enumerable.Empty<string>());
    sut.GetFilesToUpload(monitoredFolder).ShouldBeEmpty();
  }

  [Theory]
  [AutoDomainData]
  internal void GetFilesToUpload_EnumerateFilesThrows_Empty(
    MonitoredFolder monitoredFolder,
    [Frozen] IPathsProvider pathsProvider,
    [Frozen] IDirectoryProvider directoryProvider,
    FileProcessor sut
  ) {
    var uploadingFolderPath = "UploadingFolderPath";
    pathsProvider.GetUploadingFolderPath(monitoredFolder)
      .Returns(uploadingFolderPath);
    directoryProvider.Exists(uploadingFolderPath).Returns(true);
    directoryProvider.EnumerateFiles(uploadingFolderPath).Throws<IOException>();
    sut.GetFilesToUpload(monitoredFolder).ShouldBeEmpty();
  }

  [Theory]
  [AutoDomainData]
  internal void GetFilesToUpload_HasFiles_FilePaths(
    MonitoredFolder monitoredFolder,
    [Frozen] IPathsProvider pathsProvider,
    [Frozen] IDirectoryProvider directoryProvider,
    FileProcessor sut
  ) {
    var uploadingFolderPath = "UploadingFolderPath";
    pathsProvider.GetUploadingFolderPath(monitoredFolder)
      .Returns(uploadingFolderPath);
    directoryProvider.Exists(uploadingFolderPath).Returns(true);
    directoryProvider.EnumerateFiles(uploadingFolderPath)
      .Returns(new[] { "file1", "file2", "file3" });

    sut.GetFilesToUpload(monitoredFolder)
      .ShouldBe(new[] { "file1", "file2", "file3" });
  }

  [Theory]
  [AutoDomainData]
  internal void MoveFilesReadyToUpload_InputFolderDoesNotExist_DoesNotThrow(
    [Frozen] MonitoredFolder monitoredFolder,
    [Frozen] IDirectoryProvider directoryProvider,
    FileProcessor sut
  ) {
    directoryProvider.Exists(monitoredFolder.InputFolder).Returns(false);

    Should.NotThrow(() =>
      sut.MoveFilesReadyToUpload(new[] { monitoredFolder }, monitoredFolder.InputFolder));
    directoryProvider.DidNotReceiveWithAnyArgs().EnumerateFiles(default!);
  }

  [Theory]
  [AutoDomainData(configureMembers: true)]
  internal void MoveFilesReadyToUpload_InputFolderArgNotSame_Throws(
    IFixture fixture,
    IEnumerable<MonitoredFolder> monitoredFolders
  ) {
    var inputFolder = monitoredFolders.First().InputFolder;
    monitoredFolders = UpdateAllMonitoredFolders(
      inputFolder: inputFolder,
      monitoredFolders: monitoredFolders.ToArray());
    fixture.Inject(monitoredFolders);

    var sut = fixture.Create<FileProcessor>();

    Should.Throw<ArgumentException>(() =>
      sut.MoveFilesReadyToUpload(monitoredFolders, "some other folder"));
  }

  [Theory]
  [AutoDomainData(configureMembers: true)]
  internal void MoveFilesReadyToUpload_MonitoredFolderInputFolderNotSame_Throws(
    IFixture fixture,
    IEnumerable<MonitoredFolder> monitoredFolders
  ) {
    var inputFolder = monitoredFolders.First().InputFolder;
    monitoredFolders = UpdateAllMonitoredFolders(
      inputFolder: inputFolder,
      monitoredFolders: monitoredFolders.ToArray());
    // set 2nd MonitoredFolder's InputFolder to something different
    monitoredFolders = monitoredFolders.Select((mf, i) => {
      if (i == 1) {
        return mf with { InputFolder = "some other folder" };
      }
      return mf;
    });
    fixture.Inject(monitoredFolders);

    var sut = fixture.Create<FileProcessor>();

    Should.Throw<ArgumentException>(() =>
      sut.MoveFilesReadyToUpload(monitoredFolders, inputFolder));
  }

  [Theory]
  [AutoDomainData]
  internal void MoveFilesReadyToUpload_ForFilesReadyToUpload_MovesFiles(
    IFixture fixture,
    IEnumerable<MonitoredFolder> monitoredFolders,
    [Frozen] IPathsProvider pathsProvider,
    [Frozen] IDirectoryProvider directoryProvider,
    [Frozen] IFileProvider fileProvider,
    [Frozen] IDateTimeOffsetProvider dateTimeProvider
  ) {
    // this tests multiple monitored folders with same input folder (should
    // probably have a test with just one monitored folder too)
    //
    // set all input folders the same
    var inputFolder = Path.GetFullPath(monitoredFolders.First().InputFolder);
    monitoredFolders = UpdateAllMonitoredFolders(
      inputFolder: inputFolder,
      monitoredFolders: monitoredFolders.ToArray());
    fixture.Inject(monitoredFolders);

    // set up input files, 3 for each monitored folder
    directoryProvider.Exists(inputFolder).Returns(true);
    var inFilePaths = (new[] { "file1", "file2", "file3" })
      .Select(f => Path.Join(inputFolder, f));
    directoryProvider.EnumerateFiles(inputFolder).Returns(inFilePaths);

    // set up processing folders
    pathsProvider.GetUploadingFolderPath(default!)
      .ReturnsForAnyArgs(ci => $@"{ci.ArgAt<MonitoredFolder>(0).Id}\uploading\");
    fileProvider.Exists(default!).ReturnsForAnyArgs(
      ci => !ci.ArgAt<string>(0).Contains(@"\uploading\"));
    directoryProvider.CreateDirectory(default!).ReturnsForAnyArgs(
      ci => new DirectoryInfo(ci.ArgAt<string>(0)));

    // set up file last write time for 2nd to not be ready and others to be ready
    var now = DateTime.Now;
    dateTimeProvider.Now.Returns(now);
    var nowMinus5 = now.AddMinutes(-5);
    // set 2nd to now (not ready to upload)
    fileProvider.GetLastWriteTime(default!)
      .ReturnsForAnyArgs(nowMinus5, now.AddMinutes(-4), nowMinus5);

    // act
    var sut = fixture.Create<FileProcessor>();
    sut.MoveFilesReadyToUpload(monitoredFolders, inputFolder);

    // assert
    Assert.All(inFilePaths, (inFile, i) => {
      var mf0 = monitoredFolders.First();
      var mf1 = monitoredFolders.Skip(1).First();
      var mf2 = monitoredFolders.Skip(2).First();
      var inFilename = Path.GetFileName(inFile);
      var moveDestMf0 = Path.Combine(pathsProvider.GetUploadingFolderPath(mf0), inFilename);
      var copyDestMf1 = Path.Combine(pathsProvider.GetUploadingFolderPath(mf1), inFilename);
      var copyDestMf2 = Path.Combine(pathsProvider.GetUploadingFolderPath(mf2), inFilename);

      if (i != 1) {
        // file1 and file3 should be processed
        inFile.ShouldSatisfyAllConditions(
          inFile => fileProvider.Received(1).Move(inFile, moveDestMf0),
          inFile => fileProvider.Received(1).Copy(moveDestMf0, copyDestMf1),
          inFile => fileProvider.Received(1).Copy(moveDestMf0, copyDestMf2)
        );
      } else {
        // file2 should not be processed
        inFile.ShouldSatisfyAllConditions(
          inFile => fileProvider.DidNotReceive().Move(inFile, moveDestMf0),
          inFile => fileProvider.DidNotReceive().Copy(moveDestMf0, copyDestMf1),
          inFile => fileProvider.DidNotReceive().Copy(moveDestMf0, copyDestMf2)
        );
      }
    });
  }

  [Theory]
  [AutoDomainData]
  internal void MoveFilesReadyToUpload_AFileAlreadyExists_DoesNotMoveFiles(
  IFixture fixture,
    IEnumerable<MonitoredFolder> monitoredFolders,
    [Frozen] IPathsProvider pathsProvider,
    [Frozen] IDirectoryProvider directoryProvider,
    [Frozen] IFileProvider fileProvider,
    [Frozen] IDateTimeOffsetProvider dateTimeProvider
  ) {
    // this tests multiple monitored folders with same input folder (should
    // probably have a test with just one monitored folder too)
    //
    // set all input folders the same
    var inputFolder = Path.GetFullPath(monitoredFolders.First().InputFolder);
    monitoredFolders = UpdateAllMonitoredFolders(
      inputFolder: inputFolder,
      monitoredFolders: monitoredFolders.ToArray());
    fixture.Inject(monitoredFolders);

    // set up input files, 3 for each monitored folder
    directoryProvider.Exists(inputFolder).Returns(true);
    var inFilePaths = (new[] { "file1", "file2", "file3" })
      .Select(f => Path.Join(inputFolder, f));
    directoryProvider.EnumerateFiles(inputFolder).Returns(inFilePaths);

    // set up file last write time to be ready
    var now = DateTime.Now;
    dateTimeProvider.Now.Returns(now);
    var nowMinus5 = now.AddMinutes(-5);
    fileProvider.GetLastWriteTime(default!)
      .ReturnsForAnyArgs(nowMinus5, nowMinus5, nowMinus5);

    // set up processing folders, make 2nd monitored folder file already exist
    pathsProvider.GetUploadingFolderPath(default!)
      .ReturnsForAnyArgs(ci => $@"{ci.ArgAt<MonitoredFolder>(0).Id}\uploading\");
    //.ReturnsForAnyArgs(@"ProcessingPath\uploading\");
    var sut = fixture.Create<FileProcessor>();
    foreach (var inFile in inFilePaths) {
      var inFilename = Path.GetFileName(inFile);

      foreach (var (i, mf) in monitoredFolders.Index()) {
        var destPath = Path.Join(pathsProvider.GetUploadingFolderPath(mf), inFilename);
        // return exists true for 2nd file
        fileProvider.Exists(destPath).Returns(i == 1);
      }
    }

    // act
    sut.MoveFilesReadyToUpload(monitoredFolders, inputFolder);

    // assert
    Assert.All(inFilePaths, (inFile, iFile) => {
      var inFilename = Path.GetFileName(inFile);

      Assert.All(monitoredFolders, (mf, iMf) => {
        var destPath = Path.Join(pathsProvider.GetUploadingFolderPath(mf), inFilename);
        fileProvider.DidNotReceive().Move(inFile, destPath);
        fileProvider.DidNotReceive().Copy(Arg.Any<string>(), destPath);
      });
    });
  }

  [Theory()]
  [AutoDomainData]
  internal void ProcessFileDisposition_IsDelete_Deletes(
    MonitoredFolder monitoredFolder,
    string filePath,
    [Frozen] IFileProvider fileProvider,
    FileProcessor sut
  ) {
    monitoredFolder = UpdateMonitoredFolder(
      monitoredFolder,
      fileDisposition: new FileDisposition.Delete());

    sut.ProcessFileDisposition(monitoredFolder, filePath);
    fileProvider.Received(1).Delete(filePath);
  }

  [Theory()]
  [AutoDomainData]
  internal void ProcessFileDisposition_IsMove_Moves(
    MonitoredFolder monitoredFolder,
    string filePath,
    string moveToFolderPath,
    [Frozen] IDirectoryProvider directoryProvider,
    [Frozen] IFileProvider fileProvider,
    FileProcessor sut
  ) {
    monitoredFolder = UpdateMonitoredFolder(
      monitoredFolder,
      fileDisposition: new FileDisposition.Move(moveToFolderPath));

    sut.ProcessFileDisposition(monitoredFolder, filePath);

    var moveToFilePath = Path.Join(moveToFolderPath, Path.GetFileName(filePath));
    directoryProvider.Received(1).CreateDirectory(moveToFolderPath);
    fileProvider.Received(1).Move(filePath, moveToFilePath);
  }

  [Theory()]
  [AutoDomainData]
  internal void ProcessFileDisposition_IsMove_FileExists_MovesAsCopy(
    MonitoredFolder monitoredFolder,
    string filePath,
    string moveToFolderPath,
    [Frozen] IFileProvider fileProvider,
    FileProcessor sut
  ) {
    monitoredFolder = UpdateMonitoredFolder(
      monitoredFolder,
      fileDisposition: new FileDisposition.Move(moveToFolderPath));

    var baseFileName = Path.GetFileNameWithoutExtension(filePath);
    var moveToFilePath = Path.Join(moveToFolderPath, Path.GetFileName(filePath));
    var moveToFilePath2 = Path.Join(moveToFolderPath,
      baseFileName + " - Copy" + Path.GetExtension(filePath));
    var moveToFilePath3 = Path.Join(moveToFolderPath,
      baseFileName + " - Copy (2)" + Path.GetExtension(filePath));
    fileProvider.Exists(moveToFilePath).Returns(true);
    fileProvider.Exists(moveToFilePath2).Returns(true);
    fileProvider.Exists(moveToFilePath3).Returns(false);

    sut.ProcessFileDisposition(monitoredFolder, filePath);

    fileProvider.ShouldSatisfyAllConditions(
      fp => fp.DidNotReceive().Move(filePath, moveToFilePath),
      fp => fp.DidNotReceive().Move(filePath, moveToFilePath2),
      fp => fp.Received(1).Move(filePath, moveToFilePath3));
  }

  private static IEnumerable<MonitoredFolder> UpdateAllMonitoredFolders(
      string? inputFolder = null,
      FileDisposition? fileDisposition = null,
      params MonitoredFolder[] monitoredFolders) {
    return monitoredFolders.Select(mf => UpdateMonitoredFolder(
      mf, inputFolder, fileDisposition));
  }

  private static MonitoredFolder UpdateMonitoredFolder(
      MonitoredFolder monitoredFolder,
      string? inputFolder = null,
      FileDisposition? fileDisposition = null
  ) {
    var updated = monitoredFolder with {
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
