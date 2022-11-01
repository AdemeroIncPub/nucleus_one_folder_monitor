using Ademero.NucleusOne.FolderMonitor.Service.App;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using System.Text;

namespace Ademero.NucleusOne.FolderMonitor.Service.Tests.App;

public class ApiKeyOptions_Tests {
  private const string _defaultDeleteSettingsJson = """
{
  "apiKey": "ApiKey1",
  "monitoredFoldersByApiKey":
  {
    "ApiKey1":
    [
      {
        "id": "mfApiKey1Id1",
        "name": "mfApiKey1Id1Name",
        "description": "mfApiKey1Id1Description",
        "inputFolder": "mfApiKey1Id1InputFolder",
        "n1Folder":
        {
          "organizationId": "mfApiKey1Id1N1FolderOrganizationId",
          "organizationName": "mfApiKey1Id1N1FolderOrganizationName",
          "projectId": "mfApiKey1Id1N1FolderProjectId",
          "projectName": "mfApiKey1Id1N1FolderProjectName",
          "projectType": "project",
          "folderIds": [ "folderId1", "folderId2" ],
          "folderNames": [ "folderName1", "folderName2" ]
        },
        "fileDisposition":
        {
          "runtimeType": "delete"
        },
        "enabled": true
      }
    ]
  }
}
""";

  private const string _defaultMoveSettingsJson = """
{
  "apiKey": "ApiKey1",
  "monitoredFoldersByApiKey":
  {
    "ApiKey1":
    [
      {
        "id": "mfApiKey1Id1",
        "name": "mfApiKey1Id1Name",
        "description": "mfApiKey1Id1Description",
        "inputFolder": "mfApiKey1Id1InputFolder",
        "n1Folder":
        {
          "organizationId": "mfApiKey1Id1N1FolderOrganizationId",
          "organizationName": "mfApiKey1Id1N1FolderOrganizationName",
          "projectId": "mfApiKey1Id1N1FolderProjectId",
          "projectName": "mfApiKey1Id1N1FolderProjectName",
          "projectType": "department",
          "folderIds": [ "folderId1", "folderId2" ],
          "folderNames": [ "folderName1", "folderName2" ]
        },
        "fileDisposition":
        {
          "runtimeType": "move",
          "folderPath": "C:\\moveToPath"
        },
        "enabled": true
      }
    ]
  }
}
""";

  private IHost CreateHost(string jsonConfig) {
    return Host.CreateDefaultBuilder()
      .ConfigureAppConfiguration((hostContext, config) => {
        var jsonStream = new MemoryStream(Encoding.UTF8.GetBytes(jsonConfig));
        config.AddJsonStream(jsonStream);
      })
      .ConfigureServices((hostContext, services) => {
        OptionsConfiguration.ConfigureOptions(hostContext, services);
        services.AddSingleton<IValidateOptions<MonitoredFoldersByApiKeyOptions>,
          OptionsConfiguration.ProjectTypeValidation>();
        services.AddSingleton<IValidateOptions<MonitoredFoldersByApiKeyOptions>,
          OptionsConfiguration.FileDispositionValidation>();
      })
      .Build();
  }

  [Fact]
  public void ApiKeyOptions_FromJson_HasApiKey() {
    var host = CreateHost(_defaultDeleteSettingsJson);
    var options = host.Services.GetRequiredService<IOptions<ApiKeyOptions>>().Value;
    
    Assert.Equal("ApiKey1", options.ApiKey);
  }

  [Fact]
  public void MonitoredFoldersByApiKeyOptions_DefaultDelete_HasSettings() {
    var host = CreateHost(_defaultDeleteSettingsJson);
    var options = host.Services.GetRequiredService<IOptions<MonitoredFoldersByApiKeyOptions>>().Value;

    var mf1 = options.MonitoredFoldersByApiKey["ApiKey1"][0];
    Assert.Equal("mfApiKey1Id1", mf1.Id);
    Assert.Equal("mfApiKey1Id1" + "Name", mf1.Name);
    Assert.Equal("mfApiKey1Id1" + "Description", mf1.Description);
    Assert.Equal("mfApiKey1Id1" + "InputFolder", mf1.InputFolder);
    Assert.Equal("mfApiKey1Id1" + "N1Folder" + "OrganizationId", mf1.N1Folder.OrganizationId);
    Assert.Equal("mfApiKey1Id1" + "N1Folder" + "OrganizationName", mf1.N1Folder.OrganizationName);
    Assert.Equal("mfApiKey1Id1" + "N1Folder" + "ProjectId", mf1.N1Folder.ProjectId);
    Assert.Equal("mfApiKey1Id1" + "N1Folder" + "ProjectName", mf1.N1Folder.ProjectName);
    Assert.Equal(NucleusOneProjectType.Project, mf1.N1Folder.ProjectType);
    Assert.Equal(new[] { "folderId1", "folderId2" }, mf1.N1Folder.FolderIds);
    Assert.Equal(new[] { "folderName1", "folderName2" }, mf1.N1Folder.FolderNames);
    Assert.Equal(new FileDisposition.Delete(), mf1.FileDispositionAsUnion);
    Assert.True(mf1.Enabled);
  }

  [Fact]
  public void MonitoredFoldersByApiKeyOptions_DefaultMove_HasSettings() {
    var host = CreateHost(_defaultMoveSettingsJson);
    var options = host.Services.GetRequiredService<IOptions<MonitoredFoldersByApiKeyOptions>>().Value;

    var mf1 = options.MonitoredFoldersByApiKey["ApiKey1"][0];
    Assert.Equal("mfApiKey1Id1", mf1.Id);
    Assert.Equal("mfApiKey1Id1" + "Name", mf1.Name);
    Assert.Equal("mfApiKey1Id1" + "Description", mf1.Description);
    Assert.Equal("mfApiKey1Id1" + "InputFolder", mf1.InputFolder);
    Assert.Equal("mfApiKey1Id1" + "N1Folder" + "OrganizationId", mf1.N1Folder.OrganizationId);
    Assert.Equal("mfApiKey1Id1" + "N1Folder" + "OrganizationName", mf1.N1Folder.OrganizationName);
    Assert.Equal("mfApiKey1Id1" + "N1Folder" + "ProjectId", mf1.N1Folder.ProjectId);
    Assert.Equal("mfApiKey1Id1" + "N1Folder" + "ProjectName", mf1.N1Folder.ProjectName);
    Assert.Equal(NucleusOneProjectType.Department, mf1.N1Folder.ProjectType);
    Assert.Equal(new[] { "folderId1", "folderId2" }, mf1.N1Folder.FolderIds);
    Assert.Equal(new[] { "folderName1", "folderName2" }, mf1.N1Folder.FolderNames);
    Assert.Equal(new FileDisposition.Move(FolderPath: @"C:\moveToPath"), mf1.FileDispositionAsUnion);
    Assert.True(mf1.Enabled);
  }

  [Fact]
  public void MonitoredFoldersByApiKeyOptions_BadProjectType_Throws() {
    var json = _defaultDeleteSettingsJson.Replace("""
          "projectType": "project",
""", """
          "projectType": "invalid",
""");
    var host = CreateHost(json);
    Assert.Throws<OptionsValidationException>(() => {
      var options = host.Services
        .GetRequiredService<IOptions<MonitoredFoldersByApiKeyOptions>>().Value;
    });
  }

  [Fact]
  public void MonitoredFoldersByApiKeyOptions_BadFileDispositionType_Throws() {
    var json = _defaultDeleteSettingsJson.Replace("""
          "runtimeType": "delete"
""", """
          "runtimeType": "invalid"
""");
    var host = CreateHost(json);
    Assert.Throws<OptionsValidationException>(() => {
      var options = host.Services
        .GetRequiredService<IOptions<MonitoredFoldersByApiKeyOptions>>().Value;
    });
  }

  [Fact]
  public void MonitoredFoldersByApiKeyOptions_MoveFileDispositionMissingFolderPath_Throws() {
    var json = _defaultMoveSettingsJson.Replace("""
        "fileDisposition":
        {
          "runtimeType": "move",
          "folderPath": "C:\\moveToPath"
        },
""", """
        "fileDisposition":
        {
          "runtimeType": "move"
        },
""");
    var host = CreateHost(json);
    Assert.Throws<OptionsValidationException>(() => {
      var options = host.Services
        .GetRequiredService<IOptions<MonitoredFoldersByApiKeyOptions>>().Value;
    });
  }
}
