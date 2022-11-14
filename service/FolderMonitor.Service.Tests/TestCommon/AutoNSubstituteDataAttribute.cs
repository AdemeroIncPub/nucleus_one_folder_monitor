using AutoFixture;
using AutoFixture.AutoNSubstitute;
using AutoFixture.Xunit2;

namespace Ademero.NucleusOne.FolderMonitor.Service.Tests.TestCommon;

//public class AutoNSubstituteDataAttribute : AutoDataAttribute {
//  public AutoNSubstituteDataAttribute()
//    : base(() => new Fixture().Customize(new AutoNSubstituteCustomization())) {
//  }
//}

public class DomainCompositeCustomization : CompositeCustomization {
  public DomainCompositeCustomization(bool configureMembers = false, bool generateDelegates = false)
    : base(
      new AutoNSubstituteCustomization() {
        ConfigureMembers = configureMembers,
        GenerateDelegates = generateDelegates
      },
      new MonitoredFoldersByApiKeyOptionsCustomization()) { }
}

[AttributeUsage(AttributeTargets.Method)]
public class AutoDomainDataAttribute : AutoDataAttribute {
  public AutoDomainDataAttribute(bool configureMembers = false, bool generateDelegates = false)
    : base(() => new Fixture().Customize(new DomainCompositeCustomization(
      configureMembers: configureMembers,
      generateDelegates: generateDelegates))) { }
}

[AttributeUsage(AttributeTargets.Method)]
public class AutoNSubstituteDataAttribute : AutoDataAttribute {
  public AutoNSubstituteDataAttribute(bool configureMembers = false, bool generateDelegates = false)
      : base(() => new Fixture().Customize(new AutoNSubstituteCustomization() {
        ConfigureMembers = configureMembers,
        GenerateDelegates = generateDelegates
      })) { }
}
