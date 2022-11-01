using Ademero.NucleusOne.FolderMonitor.Service.App;

namespace Ademero.NucleusOne.FolderMonitor.Service;

internal sealed class WindowsService : BackgroundService {
  public WindowsService(
      IFolderMonitorService folderMonitorService,
      ILogger<WindowsService> logger) {
    _folderMonitorService = folderMonitorService;
    _logger = logger;
  }

  private readonly IFolderMonitorService _folderMonitorService;
  private readonly ILogger<WindowsService> _logger;

  protected override async Task ExecuteAsync(CancellationToken stoppingToken) {
    try {
      while (!stoppingToken.IsCancellationRequested) {
        _folderMonitorService.ProcessMonitoredFolders(stoppingToken);

        await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
      }
    } catch (OperationCanceledException) {
      _logger.LogInformation("Cancel requested, service stopping...");
    } catch (Exception ex) {
      _logger.LogError(ex, "{Message}", ex.Message);

      // Terminates this process and returns an exit code to the operating system.
      // This is required to avoid the 'BackgroundServiceExceptionBehavior', which
      // performs one of two scenarios:
      // 1. When set to "Ignore": will do nothing at all, errors cause zombie services.
      // 2. When set to "StopHost": will cleanly stop the host, and log errors.
      //
      // In order for the Windows Service Management system to leverage configured
      // recovery options, we need to terminate the process with a non-zero exit code.
      Environment.Exit(1);
    }
  }
}

