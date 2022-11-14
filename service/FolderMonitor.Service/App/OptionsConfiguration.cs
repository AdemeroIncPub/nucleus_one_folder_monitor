using Microsoft.Extensions.Options;

namespace Ademero.NucleusOne.FolderMonitor.Service.App;

internal abstract class OptionsConfiguration {
  internal static IServiceCollection ConfigureOptions(
      HostBuilderContext hostContext, IServiceCollection services) {
    var configRoot = hostContext.Configuration;

    return services
      .Configure<ApiKeyOptions>(configRoot)
      .Configure<MonitoredFoldersByApiKeyOptions>(configRoot)
      .AddSingleton<IValidateOptions<MonitoredFoldersByApiKeyOptions>, ProjectTypeValidation>()
      .AddSingleton<IValidateOptions<MonitoredFoldersByApiKeyOptions>, FileDispositionValidation>();
  }

  internal class ProjectTypeValidation : IValidateOptions<MonitoredFoldersByApiKeyOptions> {
    public ProjectTypeValidation(IConfiguration config) {
      _config = config;
    }

    private readonly IConfiguration _config;

    public ValidateOptionsResult Validate(string? name, MonitoredFoldersByApiKeyOptions options) {
      var mfsByApiKeyConfigSections = _config.GetSection("MonitoredFoldersByApiKey").GetChildren();
      foreach (var mfsConfigSection in mfsByApiKeyConfigSections) {
        var mfsConfigSections = mfsConfigSection.GetChildren();
        foreach (var mfConfigSection in mfsConfigSections) {
          var projectType = mfConfigSection["n1Folder:projectType"];
          bool isProject = projectType?.Equals("project", StringComparison.OrdinalIgnoreCase) ?? false;
          bool isDepartment = projectType?.Equals("department", StringComparison.OrdinalIgnoreCase) ?? false;
          if (!isProject && !isDepartment) {
            return ValidateOptionsResult.Fail(
              """Configuration invalid. "projectType" must be "project" or "department". """);
          }
        }
      }

      return ValidateOptionsResult.Success;
    }
  }

  internal class FileDispositionValidation : IValidateOptions<MonitoredFoldersByApiKeyOptions> {
    public FileDispositionValidation(IConfiguration config) {
      _config = config;
    }

    private readonly IConfiguration _config;

    public ValidateOptionsResult Validate(string? name, MonitoredFoldersByApiKeyOptions options) {
      var mfsByApiKeyConfigSections = _config.GetSection("MonitoredFoldersByApiKey").GetChildren();
      foreach (var mfsConfigSection in mfsByApiKeyConfigSections) {
        var mfsConfigSections = mfsConfigSection.GetChildren();
        foreach (var mfConfigSection in mfsConfigSections) {
          var runtimeType = mfConfigSection["fileDisposition:runtimeType"];
          bool isDelete = runtimeType?.Equals("delete", StringComparison.OrdinalIgnoreCase) ?? false;
          bool isMove = runtimeType?.Equals("move", StringComparison.OrdinalIgnoreCase) ?? false;
          if (!isDelete && !isMove) {
            return ValidateOptionsResult.Fail(
              """Configuration invalid. "fileDisposition.runtimeType" must be either "delete" or "move".""");
          }
          if (isMove) {
            var movePath = mfConfigSection["fileDisposition:folderPath"];
            if (string.IsNullOrWhiteSpace(movePath)) {
              return ValidateOptionsResult.Fail(
                """Configuration invalid. "fileDisposition.folderPath" must be specified when "fileDisposition.runtimeType" is "move".""");
            }
          }
        }
      }

      return ValidateOptionsResult.Success;
    }
  }
}

internal record ApiKeyOptions {
  public string ApiKey { get; init; } = "";
}

internal record MonitoredFoldersByApiKeyOptions {
  public Dictionary<string, MonitoredFolder[]>
    MonitoredFoldersByApiKey { get; init; } = new();
}

internal record MonitoredFolder {
  public string Id { get; init; } = "";
  public string Name { get; init; } = "";
  public string Description { get; init; } = "";
  public string InputFolder { get; init; } = "";
  public NucleusOneFolder N1Folder { get; init; } = new();
  public FileDispositionRaw FileDisposition { get; init; } = new();
  public FileDisposition FileDispositionAsUnion {
    get {
      static FileDisposition.Move getMove(string? folderPath) {
        if (string.IsNullOrWhiteSpace(folderPath)) {
          throw new InvalidOperationException(
            """Configuration invalid. "fileDisposition.folderPath" must be specified when "runtimeType" is "move".""");
        }
        return new FileDisposition.Move(FolderPath: folderPath);
      }

      return FileDisposition.RuntimeType switch {
        FileDispositionType.Delete => new FileDisposition.Delete(),
        FileDispositionType.Move => getMove(FileDisposition.FolderPath),
        _ => throw new NotImplementedException(),
      };
    }
  }
  public bool Enabled { get; init; } = true;
}

internal record NucleusOneFolder {
  public string OrganizationId { get; init; } = "";
  public string OrganizationName { get; init; } = "";
  public string ProjectId { get; init; } = "";
  public string ProjectName { get; init; } = "";
  public NucleusOneProjectType ProjectType { get; init; }
  public string[] FolderIds { get; init; } = Array.Empty<string>();
  public string[] FolderNames { get; init; } = Array.Empty<string>();
}

internal enum NucleusOneProjectType {
  Project,
  Department
}

internal enum FileDispositionType {
  Delete,
  Move
}

internal abstract record FileDisposition {
  private FileDisposition() { }

  internal record Delete() : FileDisposition();
  internal record Move(string FolderPath) : FileDisposition();
}

internal record FileDispositionRaw {
  public FileDispositionType RuntimeType { get; init; }

  /// <summary>
  /// Null if <see cref="RuntimeType" /> is Delete, a folder path if it is Move.
  /// </summary>
  public string? FolderPath { get; init; }
}
