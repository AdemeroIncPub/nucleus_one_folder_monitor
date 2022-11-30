using Ademero.NucleusOne.FolderMonitor.Service.Util;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using static System.Net.Mime.MediaTypeNames;

namespace Ademero.NucleusOne.FolderMonitor.Service.App;

internal record UploadInfo(
  string DocumentFolderID,
  // not sure what type this is, N1 returns null so leaving it out for now.
  //FieldIDsAndValues,
  string ObjectName,
  string ObjectName2,
  string OriginalFilename,
  long OriginalFileSize,
  string SignedUrl,
  string SignedUrl2,
  string UniqueId
);

internal interface IDocumentUploader {
  Task UploadDocumentAsync(MonitoredFolder monitoredFolder, string filePath);
}

internal class DocumentUploader : IDocumentUploader {
  public DocumentUploader(
      IFileProvider fileProvider,
      IFileInfoProvider fileInfoProvider,
      IOptions<ApiKeyOptions> apiKeyOptions,
      IHttpClientFactory httpClientFactory) {
    _fileProvider = fileProvider;
    _fileInfoProvider = fileInfoProvider;
    _apiKeyOptions = apiKeyOptions.Value;
    _httpClientFactory = httpClientFactory;
  }

  private readonly IFileProvider _fileProvider;
  private readonly IFileInfoProvider _fileInfoProvider;
  private readonly ApiKeyOptions _apiKeyOptions;
  private readonly IHttpClientFactory _httpClientFactory;

  private const string _defaultBaseUrl = "https://client-api.nucleus.one/";
  private const string _defaultBaseUrlPath = "api/v1/";

  private static string ApiUrl => _defaultBaseUrl + _defaultBaseUrlPath;

  public async Task UploadDocumentAsync(MonitoredFolder monitoredFolder, string filePath) {
    var uploadInfo = await GetUploadInfoAsync(monitoredFolder);
    var signedUrl = Uri.UnescapeDataString(uploadInfo.SignedUrl);
    var location = await StartUploadAsync(signedUrl);
    await UploadFileAsync(location, filePath);
    await FinishUploadAsync(monitoredFolder, uploadInfo, filePath);
  }

  private Task<UploadInfo> GetUploadInfoAsync(MonitoredFolder monitoredFolder) {
    var httpClient = GetNucleusOneHttpClient();
    var orgId = monitoredFolder.N1Folder.OrganizationId;
    var projectId = monitoredFolder.N1Folder.ProjectId;
    var path = $"organizations/{orgId}/projects/{projectId}/documentUploads";
    var uploadInfo = httpClient.GetFromJsonAsync<UploadInfo>(path);
    if (uploadInfo == null) {
      throw new FolderMonitorException("Failed to get upload info from Nucleus One");
    }
    return uploadInfo!;
  }

  /// <summary>
  /// Starts an upload.
  /// </summary>
  /// <param name="signedUrl"></param>
  /// <returns>The URI location to upload file data.</returns>
  private async Task<string> StartUploadAsync(string signedUrl) {
    var httpClient = _httpClientFactory.CreateClient();
    var request = new HttpRequestMessage(HttpMethod.Put, signedUrl);
    request.Headers.Add("x-goog-resumable", "start");
    request.Content = new StringContent(string.Empty);
    request.Content.Headers.ContentType = new MediaTypeHeaderValue(Application.Octet);
    var response = await httpClient.SendAsync(request);
    _ = response.EnsureSuccessStatusCode();
    var location = response.Headers.GetValues("location").First();
    return Uri.UnescapeDataString(location);
  }

  private async Task UploadFileAsync(string uri, string filePath) {
    var httpClient = _httpClientFactory.CreateClient();
    var stream = _fileProvider.OpenRead(filePath);
    using var request = new HttpRequestMessage(HttpMethod.Put, uri);
    using var content = new StreamContent(stream);
    request.Content = content;
    var response = await httpClient.SendAsync(request);
    _ = response.EnsureSuccessStatusCode();
  }

  private async Task FinishUploadAsync(MonitoredFolder monitoredFolder, UploadInfo uploadInfo, string filePath) {
    var fileInfo = _fileInfoProvider.Create(filePath);
    uploadInfo = uploadInfo with {
      DocumentFolderID = monitoredFolder.N1Folder.FolderIds.LastOrDefault(""),
      OriginalFilename = Path.GetFileName(filePath),
      OriginalFileSize = fileInfo.Length,
      SignedUrl = Uri.UnescapeDataString(uploadInfo.SignedUrl)
    };

    var orgId = monitoredFolder.N1Folder.OrganizationId;
    var projectId = monitoredFolder.N1Folder.ProjectId;
    var path = $"organizations/{orgId}/projects/{projectId}/documentUploads";
    var query = $"uniqueId={uploadInfo.UniqueId}&captureOriginal=false";
    var request = new HttpRequestMessage(HttpMethod.Put, $"{path}?{query}") {
      Content = JsonContent.Create(new[] { uploadInfo })
    };

    var httpClient = GetNucleusOneHttpClient();
    var response = await httpClient.SendAsync(request);
    _ = response.EnsureSuccessStatusCode();
  }

  private HttpClient GetNucleusOneHttpClient(bool authenticate = true) {
    var httpClient = _httpClientFactory.CreateClient();
    httpClient.BaseAddress = new Uri(ApiUrl);
    if (authenticate) {
      httpClient.DefaultRequestHeaders.Add("Authorization", $"Bearer {_apiKeyOptions.ApiKey}");
    }
    return httpClient;
  }
}
