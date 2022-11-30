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
  public required string ApiKey { get; init; }
}

internal record MonitoredFoldersByApiKeyOptions {
  public required Dictionary<string, MonitoredFolder[]> MonitoredFoldersByApiKey { get; init; }
}

internal record MonitoredFolder {
  public required string Id { get; init; }
  public required string Name { get; init; }
  public required string Description { get; init; }
  public required string InputFolder { get; init; }
  public required NucleusOneFolder N1Folder { get; init; }
  public required FileDispositionRaw FileDisposition { get; init; }
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
  public required bool Enabled { get; init; }
}

internal record NucleusOneFolder {
  public required string OrganizationId { get; init; }
  public required string OrganizationName { get; init; }
  public required string ProjectId { get; init; }
  public required string ProjectName { get; init; }
  public required NucleusOneProjectType ProjectType { get; init; }
  public required string[] FolderIds { get; init; }
  public required string[] FolderNames { get; init; }
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
  public required FileDispositionType RuntimeType { get; init; }

  /// <summary>
  /// Null if <see cref="RuntimeType" /> is Delete, a folder path if it is Move.
  /// </summary>
  public string? FolderPath { get; init; }
}
