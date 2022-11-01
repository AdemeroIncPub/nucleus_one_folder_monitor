using Ademero.NucleusOne.FolderMonitor.Service.Util;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Ademero.NucleusOne.FolderMonitor.Service.Tests;

public class Program_Tests {
  [Fact]
  public void CreateHostBuilder_AddsAppDataSettingsFile() {
    var hostBuilder = Program.CreateHostBuilder(Array.Empty<string>());
    hostBuilder.ConfigureAppConfiguration((hostContext, config) => {
      var source = config.Sources
        .OfType<FileConfigurationSource>()
        .FirstOrDefault(source => source.Path == Program.AppSettingsFilepath);
      Assert.NotNull(source);
    });
  }
}
