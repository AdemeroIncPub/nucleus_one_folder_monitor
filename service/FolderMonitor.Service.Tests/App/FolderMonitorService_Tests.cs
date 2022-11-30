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
  [AutoDomainData(configureMembers: true)]
  internal async Task ProcessMonitoredFolders_UploadSucceeds_ProcessesFileDispositionAsync(
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
  internal async Task ProcessMonitoredFolders_UploadFails_DoesNotProcessFileDispositionAsync(
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
  internal void GetEnabledMonitoredFolders_ValidKey_CorrectItems(
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
  internal void GetEnabledMonitoredFolders_BadKey_Empty(
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
