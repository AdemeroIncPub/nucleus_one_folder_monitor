using AutoFixture;
using AutoFixture.AutoNSubstitute;

namespace Ademero.NucleusOne.FolderMonitor.Service.Tests.TestCommon;

public class TestBase {
  protected static IFixture GetAutoNSubstituteFixture(
      bool configureMembers = false,
      bool generateDelegates = false) =>
    new Fixture().Customize(new AutoNSubstituteCustomization() {
      ConfigureMembers = configureMembers,
      GenerateDelegates = generateDelegates
    });
}
