using Ademero.NucleusOne.FolderMonitor.Service.App;
using AutoFixture;
using AutoFixture.Xunit2;
using Castle.Core.Resource;
using NSubstitute.Extensions;

namespace Ademero.NucleusOne.FolderMonitor.Service.Tests.TestCommon;

/// <summary>
/// Creates valid(ish) MonitoredFoldersByApiKeyOptions
/// </summary>
public class MonitoredFoldersByApiKeyOptionsCustomization : ICustomization {
  public void Customize(IFixture fixture) {
    fixture.Customize<MonitoredFoldersByApiKeyOptions>(transform => transform
      .With(
        input => input.MonitoredFoldersByApiKey,
        (Dictionary<string, MonitoredFolder[]> mfsByApiKey) => {
          var newMfsByApiKey = new Dictionary<string, MonitoredFolder[]>();
          foreach (var kvp in mfsByApiKey) {
            var mfs = kvp.Value.Select(mf => {
              FileDispositionRaw fdr = mf.FileDisposition;
              if (fdr.RuntimeType == FileDispositionType.Delete) {
                fdr = fdr with { FolderPath = null };
              }
              return mf with { FileDisposition = fdr };
            });
            newMfsByApiKey.Add(kvp.Key, mfs.ToArray());
          }
          return newMfsByApiKey;
        }
      )
    );
  }
}

internal class MonitoredFoldersByApiKeyOptionsDataAttribute : AutoDataAttribute {
  public MonitoredFoldersByApiKeyOptionsDataAttribute() : base(
    () => new Fixture().Customize(new MonitoredFoldersByApiKeyOptionsCustomization())) { }
}
