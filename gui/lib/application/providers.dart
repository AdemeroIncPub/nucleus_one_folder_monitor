import 'dart:convert';
import 'dart:io';

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

typedef WriteSettingsFn = void Function(Settings settings);

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

final monitoredFoldersProvider = Provider<List<MonitoredFolder>>((ref) {
  final monitoredFolders = ref.watch(
    settingsProvider.select((value) => value.monitoredFolders),
  );
  return monitoredFolders;
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
    StateProvider.autoDispose<N1ProjectType?>((ref) {
  return null;
});

final n1OrganizationProjectsProvider = FutureProvider.autoDispose
    .family<List<n1.OrganizationProject>, String>((ref, orgId) async {
  final n1Sdk = ref.watch(n1SdkServiceProvider);
  final projectTypeFilter =
      ref.watch(n1OrganizationProjects_ProjectTypeFilterProvider);

  final projects = await n1Sdk.getOrganizationProjects(
      organizationId: orgId, projectAccessType: projectTypeFilter?.accessType);
  return projects..sort((a, b) => a.name.compareTo(b.name));
});

final n1DocumentFoldersProvider = FutureProvider.family<List<n1.DocumentFolder>,
    GetProjectDocumentFoldersArgs>((ref, args) async {
  final n1Sdk = ref.watch(n1SdkServiceProvider);
  final folders = await n1Sdk.getDocumentFolders(
    organizationId: args.orgId,
    projectId: args.projectId,
    parentId: args.parentId,
  );
  return folders..sort((a, b) => a.name.compareTo(b.name));
});

@freezed
class GetProjectDocumentFoldersArgs with _$GetProjectDocumentFoldersArgs {
  const factory GetProjectDocumentFoldersArgs({
    required String orgId,
    required String projectId,
    String? parentId,
  }) = _GetProjectDocumentFoldersArgs;
}
