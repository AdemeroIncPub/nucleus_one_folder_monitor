using Microsoft.Extensions.Configuration;
using Shouldly;

namespace Ademero.NucleusOne.FolderMonitor.Service.Tests;

public class Program_Tests {
  [Fact]
  internal void CreateHostBuilder_AddsAppDataSettingsFile() {
    var hostBuilder = Program.CreateHostBuilder(Array.Empty<string>());
    hostBuilder.ConfigureAppConfiguration((hostContext, config) => {
      var source = config.Sources
        .OfType<FileConfigurationSource>()
        .FirstOrDefault(source => source.Path == Program.ApplicationSettingsFilepath);
      source.ShouldNotBeNull();
    });
  }
}
