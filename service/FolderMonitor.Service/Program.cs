using Ademero.NucleusOne.FolderMonitor.Service.App;
using Ademero.NucleusOne.FolderMonitor.Service.Util;
using Microsoft.Extensions.Options;

namespace Ademero.NucleusOne.FolderMonitor.Service;

// this should trigger an analysis warning for being the same as namespace, but
// analysis seems to not be fully working. Maybe a .net 7 thing or just not
// configure correctly? Keeping this here as an indicator.
// A couple different types of issues below.
public class Se_rvice { } // underscore

public class System { } // type name same as namespace

public enum Animals { // Missing 0 value
  Dog = 1,
  Cat = 2
}

internal static class Program {
  public static string ApplicationDataPath {
    get {
      var programData = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData);
      return Path.Join(programData, Constants.ConfigFolder);
    }
  }

  public static string AppSettingsFilepath {
    get {
      return Path.Join(ApplicationDataPath, Constants.ConfigFilename);
    }
  }

  public static async Task Main(string[] args) {
    var hostBuilder = CreateHostBuilder(args);
    using var host = hostBuilder.Build();
    await host.RunAsync();
  }

  internal static IHostBuilder CreateHostBuilder(string[] args) {
    return Host.CreateDefaultBuilder(args)
    .UseWindowsService(options => {
      options.ServiceName = "Nucleus One Folder Monitor Service";
    })
    .ConfigureAppConfiguration((hostContext, config) => {
      ConfigureAppConfiguration(hostContext, config);
    })
    .ConfigureServices((hostContext, services) => {
      OptionsConfiguration.ConfigureOptions(hostContext, services);

      services.AddSingleton<IFolderMonitorService, FolderMonitorService>();
      services.AddHostedService<WindowsService>();
    });
  }

  private static IConfigurationBuilder ConfigureAppConfiguration(
      HostBuilderContext hostContext, IConfigurationBuilder config) {
    //TODO(apn): create local settings.Environment.json override
    return config.AddJsonFile(AppSettingsFilepath, optional: true);
  }
}
