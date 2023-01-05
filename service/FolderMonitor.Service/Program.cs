using Ademero.NucleusOne.FolderMonitor.Service.App;
using Ademero.NucleusOne.FolderMonitor.Service.Util;

namespace Ademero.NucleusOne.FolderMonitor.Service;

internal static class Program {
  public static string ApplicationDataPath {
    get {
      var programData = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData);
      return Path.Join(programData, Constants.DataFolder);
    }
  }

  public static string ApplicationSettingsFilepath =>
    Path.Join(ApplicationDataPath, Constants.ConfigFilename);

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
      _ = ConfigureAppConfiguration(hostContext, config);
    })
    .ConfigureServices((hostContext, services) => {
      _ = OptionsConfiguration.ConfigureOptions(hostContext, services);

      _ = services.AddHttpClient();

      _ = services.AddSingleton<IDateTimeOffsetProvider, DateTimeOffsetProvider>()
        .AddSingleton<IDirectoryProvider, DirectoryProvider>()
        .AddSingleton<IFileProvider, FileProvider>()
        .AddSingleton<IFileInfoProvider, FileInfoProvider>()
        .AddSingleton<IPathsProvider, PathsProvider>()
        .AddSingleton<IFileTracker, FileTracker>()
        .AddSingleton<IFileProcessor, FileProcessor>()
        .AddSingleton<IDocumentUploader, DocumentUploader>()
        .AddSingleton<IFolderMonitorService, FolderMonitorService>();

      _ = services.AddHostedService<WindowsService>();
    });
  }

  private static IConfigurationBuilder ConfigureAppConfiguration(
      HostBuilderContext hostContext, IConfigurationBuilder config) {
    //TODO(apn): create local settings.Environment.json override
    return config.AddJsonFile(ApplicationSettingsFilepath, optional: true);
  }
}
