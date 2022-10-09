import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/strings.dart' as quiver;

import 'monitored_folder.dart';
import 'providers_initialized.dart';
import 'settings.dart';

typedef WriteSettingsFunc = void Function(Settings settings);

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
