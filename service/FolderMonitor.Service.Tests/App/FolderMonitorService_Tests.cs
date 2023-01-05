using Ademero.NucleusOne.FolderMonitor.Service.App;
using Ademero.NucleusOne.FolderMonitor.Service.Tests.TestCommon;
using Xunit.Abstractions;
using Shouldly;
using SuperLinq;
using AutoFixture.Xunit2;
using NSubstitute;
using AutoFixture;
using NSubstitute.ExceptionExtensions;

namespace Ademero.NucleusOne.FolderMonitor.Service.Tests.App;

public class FolderMonitorService_Tests : TestBase {
  private readonly ITestOutputHelper _output;

  public FolderMonitorService_Tests(ITestOutputHelper output) {
    _output = output;
  }

  [Theory]
  [AutoDomainData]
  internal void MoveFilesReadyToUpload_GroupsByInputFolder_ThenCalls_FileProcessor(
    [Frozen] IFileProcessor fileProcessor,
    IEnumerable<MonitoredFolder> monitoredFolders,
    FolderMonitorService sut
  ) {
    const string folder01 = @"C:\InputFolder01";
    const string folder02 = @"C:\InputFolder02";
    var monitoredFolders01 = MonitoredFoldersUtil.UpdateAllMonitoredFolders(
      monitoredFolders,
      enabled: true,
      inputFolder: folder01);
    var monitoredFolders02 = MonitoredFoldersUtil.UpdateAllMonitoredFolders(
      monitoredFolders,
      enabled: true,
      inputFolder: folder02);
    monitoredFolders = monitoredFolders01.Interleave(monitoredFolders02);

    sut.MoveFilesReadyToUpload(monitoredFolders, CancellationToken.None);

    fileProcessor.ReceivedWithAnyArgs(2).MoveFilesReadyToUpload(default!, default!);
    fileProcessor.Received(1).MoveFilesReadyToUpload(
      Arg.Is<IEnumerable<MonitoredFolder>>(mfs => mfs.All(mf => mf.InputFolder == folder01)),
      folder01
    );
    fileProcessor.Received(1).MoveFilesReadyToUpload(
      Arg.Is<IEnumerable<MonitoredFolder>>(mfs => mfs.All(mf => mf.InputFolder == folder02)),
      folder02
    );
  }

  [Theory]
  [AutoDomainData]
  internal void MoveFailedUploads_HasNoFailedUploads_DoesNotMoveThem(
    [Frozen] IFileProcessor fileProcessor,
    [Frozen] IFileTracker fileTracker,
    MonitoredFolder monitoredFolder,
    IEnumerable<FileTrackingState> trackingStates,
    FolderMonitorService sut
  ) {
    trackingStates = trackingStates.Select(ts => ts with { UploadAttempts = 0 });
    fileTracker.GetAllStates(monitoredFolder).Returns(trackingStates);

    sut.MoveFailedUploads(new[] { monitoredFolder }, CancellationToken.None);

    fileProcessor.DidNotReceiveWithAnyArgs().MoveFailedUpload(default!, default!);
    fileTracker.DidNotReceiveWithAnyArgs().DeleteTrackingFile(default!, default!);
  }

  [Theory]
  [AutoDomainData]
  internal void MoveFailedUploads_HasTwoFailedUploads_MovesThem(
    [Frozen] IFileProcessor fileProcessor,
    [Frozen] IFileTracker fileTracker,
    MonitoredFolder monitoredFolder,
    IEnumerable<FileTrackingState> trackingStates,
    FolderMonitorService sut
  ) {
    trackingStates = trackingStates.Select((ts, i) => {
      var attempts = (i < 2) ? FolderMonitorService.MaxAttempts : 0;
      return ts with {
        UploadAttempts = attempts
      };
    });
    fileTracker.GetAllStates(monitoredFolder).Returns(trackingStates);
    
    sut.MoveFailedUploads(new[] { monitoredFolder }, CancellationToken.None);

    fileProcessor.ReceivedWithAnyArgs(2).MoveFailedUpload(default!, default!);
    fileProcessor.Received().MoveFailedUpload(monitoredFolder,
      trackingStates.ElementAt(0).UploadingFilePath);
    fileProcessor.Received().MoveFailedUpload(monitoredFolder,
      trackingStates.ElementAt(1).UploadingFilePath);

    fileTracker.ReceivedWithAnyArgs(2).DeleteTrackingFile(default!, default!);
    fileTracker.Received().DeleteTrackingFile(monitoredFolder,
      trackingStates.ElementAt(0).UploadingFilePath);
    fileTracker.Received().DeleteTrackingFile(monitoredFolder,
      trackingStates.ElementAt(1).UploadingFilePath);
  }

  [Theory]
  [AutoDomainData(configureMembers: true)]
  internal async Task ProcessMonitoredFolders_UploadSucceeds_ProcessesFileDisposition(
    IFixture fixture,
    [Frozen] IFileProcessor fileProcessor,
    [Frozen] IFileTracker fileTracker,
    [Frozen] IDocumentUploader documentUploader,
    MonitoredFoldersByApiKeyOptions monitoredFoldersByApiKeyOptions
  ) {
    monitoredFoldersByApiKeyOptions = EnableAllMonitoredFolders(monitoredFoldersByApiKeyOptions);
    fixture.Inject(monitoredFoldersByApiKeyOptions);

    var mfsKvp = monitoredFoldersByApiKeyOptions.MonitoredFoldersByApiKey.First();
    var mfs = mfsKvp.Value;
    var apiKeyOptions = new ApiKeyOptions { ApiKey = mfsKvp.Key };
    fixture.Inject(apiKeyOptions);

    var uploadingFilePaths = new[] { "file1", "file2", "file3" };
    fileProcessor.GetFilesToUpload(default!).ReturnsForAnyArgs(uploadingFilePaths);
    foreach (var filePath in uploadingFilePaths) {
      fileTracker.GetState(Arg.Any<MonitoredFolder>(), filePath)
        .Returns(FileTrackingState.Create(mfsKvp.Value[0], filePath));
    }
    documentUploader.UploadDocumentAsync(default!, default!)
      .ReturnsForAnyArgs(Task.CompletedTask);

    var sut = fixture.Create<FolderMonitorService>();
    await sut.ProcessMonitoredFoldersAsync(CancellationToken.None);

    // 3 files per 3 monitored folders = 9 files
    await documentUploader.ReceivedWithAnyArgs(9).UploadDocumentAsync(default!, default!);
    Assert.All(mfs, mf => mf.ShouldSatisfyAllConditions(
      mf => fileProcessor.Received().ProcessFileDisposition(mf, "file1"),
      mf => fileProcessor.Received().ProcessFileDisposition(mf, "file2"),
      mf => fileProcessor.Received().ProcessFileDisposition(mf, "file3")));
  }

  [Theory]
  [AutoDomainData(configureMembers: true)]
  internal async Task ProcessMonitoredFolders_UploadFails_DoesNotProcessFileDisposition(
  IFixture fixture,
  [Frozen] IFileProcessor fileProcessor,
  [Frozen] IFileTracker fileTracker,
  [Frozen] IDocumentUploader documentUploader,
  MonitoredFoldersByApiKeyOptions monitoredFoldersByApiKeyOptions
) {
    monitoredFoldersByApiKeyOptions = EnableAllMonitoredFolders(monitoredFoldersByApiKeyOptions);
    fixture.Inject(monitoredFoldersByApiKeyOptions);

    var mfsKvp = monitoredFoldersByApiKeyOptions.MonitoredFoldersByApiKey.First();
    var apiKeyOptions = new ApiKeyOptions { ApiKey = mfsKvp.Key };
    fixture.Inject(apiKeyOptions);

    var uploadingFilePaths = new[] { "file1", "file2", "file3" };
    fileProcessor.GetFilesToUpload(default!).ReturnsForAnyArgs(uploadingFilePaths);
    foreach (var filePath in uploadingFilePaths) {
      fileTracker.GetState(Arg.Any<MonitoredFolder>(), filePath)
        .Returns(FileTrackingState.Create(mfsKvp.Value[0], filePath));
    }
    documentUploader.UploadDocumentAsync(default!, default!)
      .ThrowsAsyncForAnyArgs<Exception>();

    var sut = fixture.Create<FolderMonitorService>();
    await sut.ProcessMonitoredFoldersAsync(CancellationToken.None);

    // 3 files per 3 monitored folders = 9 files
    await documentUploader.ReceivedWithAnyArgs(9).UploadDocumentAsync(default!, default!);
    fileProcessor.DidNotReceiveWithAnyArgs().ProcessFileDisposition(default!, default!);
  }

  [Theory]
  [AutoDomainData]
  internal void GetEnabledMonitoredFolders_ValidKey_ReturnsCorrectItems(
    MonitoredFoldersByApiKeyOptions monitoredFoldersByApiKeyOptions
  ) {
    var keys = monitoredFoldersByApiKeyOptions.MonitoredFoldersByApiKey.Keys;
    Assert.All(keys, key => {
      var apiKeyOptions = new ApiKeyOptions { ApiKey = key };
      var result = FolderMonitorService.GetEnabledMonitoredFolders(
        apiKeyOptions, monitoredFoldersByApiKeyOptions);

      var mfs = monitoredFoldersByApiKeyOptions.MonitoredFoldersByApiKey[key];
      mfs.Where(mf => mf.Enabled).ShouldBe(result);
    });
  }

  [Theory]
  [AutoDomainData]
  internal void GetEnabledMonitoredFolders_BadKey_ReturnsEmpty(
    MonitoredFoldersByApiKeyOptions monitoredFoldersByApiKeyOptions
  ) {
    var apiKeyOptions = new ApiKeyOptions { ApiKey = "bad key" };
    var result = FolderMonitorService.GetEnabledMonitoredFolders(
      apiKeyOptions, monitoredFoldersByApiKeyOptions);

    result.ShouldBeEmpty();
  }

  private static MonitoredFoldersByApiKeyOptions EnableAllMonitoredFolders(
      MonitoredFoldersByApiKeyOptions input) {
    return input with {
      MonitoredFoldersByApiKey = input.MonitoredFoldersByApiKey
        .Select(kvp => KeyValuePair.Create(
          kvp.Key,
          kvp.Value.Select(mf => mf with { Enabled = true }).ToArray()))
      .ToDictionary()
    };
  }

  
}
