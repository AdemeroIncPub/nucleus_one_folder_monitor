using Microsoft.Extensions.Options;

namespace Ademero.NucleusOne.FolderMonitor.Service.App;

internal interface IFolderMonitorService {
  void ProcessMonitoredFolders(CancellationToken stoppingToken);
}

internal class FolderMonitorService : IFolderMonitorService {
  public FolderMonitorService(
      IOptions<ApiKeyOptions> apiKeyOptions,
      IOptions<MonitoredFoldersByApiKeyOptions> monitoredFoldersByApiKeyOptions,
      ILogger<FolderMonitorService> logger) {
    _apiKeyOptions = apiKeyOptions.Value;
    _monitoredFoldersByApiKeyOptions = monitoredFoldersByApiKeyOptions.Value;
    _logger = logger;
  }

  private readonly ApiKeyOptions _apiKeyOptions;
  private readonly MonitoredFoldersByApiKeyOptions _monitoredFoldersByApiKeyOptions;
  private readonly ILogger<FolderMonitorService> _logger;

  public void ProcessMonitoredFolders(CancellationToken stoppingToken) {
    // get monitors by active api key
    
    // group by input folder in case more than one monitor is configured for the
    // same input folder

    // check for documents that are ready to upload

    // upload documents
  }
}

internal class FolderMonitorServiceOptions {
}
