import 'dart:convert';
import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:quiver/strings.dart' as quiver;

import 'enums.dart';
import 'monitored_folder.dart';
import 'nucleus_one_sdk_service.dart';
import 'providers_initialized.dart';
import 'settings.dart';

part 'providers.freezed.dart';

final _settingsJsonReaderProvider = Provider((ref) {
  final path = ref.watch(settingsPathProvider);
  final filePath = File(path);
  if (filePath.existsSync()) {
    return File(path).readAsStringSync();
  }
  return '';
});

final _settingsJsonWriterProvider = Provider((ref) {
  final path = ref.watch(settingsPathProvider);
  final filePath = File(path);
  return (Settings settings) {
    filePath.parent.createSync();
    final json = jsonEncode(settings.toJson());
    return filePath.writeAsStringSync(
      json,
      flush: true,
      mode: FileMode.writeOnly,
    );
  };
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  final json = ref.watch(_settingsJsonReaderProvider);
  final writeSettings = ref.watch(_settingsJsonWriterProvider);

  var settings = Settings.defaultValue();
  if (quiver.isNotBlank(json)) {
    final jsonMap = jsonDecode(json) as Map<String, dynamic>;
    settings = Settings.fromJson(jsonMap);
  }

  return SettingsNotifier(settings, writeSettings);
});

final monitoredFoldersProvider = Provider<IList<MonitoredFolder>>((ref) {
  final monitoredFolders = ref.watch(
    settingsProvider.select((x) => x.monitoredFoldersByApiKey.get(x.apiKey)),
  );
  return monitoredFolders ?? <MonitoredFolder>[].lock;
});

final _nucleusOneAppProvider = Provider((ref) {
  final apiKey = ref.watch(
    settingsProvider.select((settings) => settings.apiKey),
  );
  return n1.NucleusOneApp(options: n1.NucleusOneOptions(apiKey: apiKey));
});

final n1SdkServiceProvider = Provider<NucleusOneSdkService>((ref) {
  final n1App = ref.watch(_nucleusOneAppProvider);
  return NucleusOneSdkService(n1App);
});

final n1UserOrganizationsProvider =
    FutureProvider.autoDispose<List<n1.UserOrganization>>((ref) async {
  final n1Sdk = ref.watch(n1SdkServiceProvider);
  return n1Sdk.getUserOrganizations();
});

// ignore: non_constant_identifier_names
final n1OrganizationProjects_ProjectTypeFilterProvider =
    StateProvider.autoDispose<NucleusOneProjectType?>((ref) {
  return null;
});

final n1OrganizationProjectsProvider = FutureProvider.family
    .autoDispose<List<n1.OrganizationProject>, String>((ref, orgId) async {
  final n1Sdk = ref.watch(n1SdkServiceProvider);
  final projectTypeFilter =
      ref.watch(n1OrganizationProjects_ProjectTypeFilterProvider);

  final projects = await n1Sdk.getOrganizationProjects(
      organizationId: orgId, projectAccessType: projectTypeFilter?.accessType);
  return projects..sort((a, b) => a.name.compareTo(b.name));
});

/// Not [autoDispose]'d because we want to cache folders during
/// [SelectNucleusOneFolderScreen] lifetime. Dispose in screen's [dispose()].
final n1DocumentFoldersCachedProvider =
    FutureProvider.family<List<n1.DocumentFolder>, GetDocumentFoldersArgs>(
        (ref, args) async {
  final n1Sdk = ref.watch(n1SdkServiceProvider);
  final folders = await n1Sdk.getDocumentFolders(
    organizationId: args.orgId,
    projectId: args.projectId,
    parentId: args.parentId,
  );
  return folders..sort((a, b) => a.name.compareTo(b.name));
});

final n1DocumentFolderByIdProvider =
    FutureProvider.family<n1.DocumentFolder?, GetDocumentFolderByIdArgs>(
        (ref, args) {
  final n1Sdk = ref.watch(n1SdkServiceProvider);
  return n1Sdk.getDocumentFolderById(
    organizationId: args.orgId,
    projectId: args.projectId,
    folderId: args.folderId,
  );
});

@freezed
class GetDocumentFoldersArgs with _$GetDocumentFoldersArgs {
  const factory GetDocumentFoldersArgs({
    required String orgId,
    required String projectId,
    String? parentId,
  }) = _GetDocumentFoldersArgs;
}

@freezed
class GetDocumentFolderByIdArgs with _$GetDocumentFolderByIdArgs {
  const factory GetDocumentFolderByIdArgs({
    required String orgId,
    required String projectId,
    required String folderId,
  }) = _GetDocumentFolderByIdArgs;
}
