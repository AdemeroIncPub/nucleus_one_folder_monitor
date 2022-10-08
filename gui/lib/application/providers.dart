import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path_;
import 'package:path_provider_windows/path_provider_windows.dart'
    as path_provider_windows;
import 'package:quiver/strings.dart' as quiver;

import '../util/constants.dart';
import 'monitored_folder.dart';
import 'settings.dart';

typedef WriteSettingsFunc = Future<File> Function(Settings);

// todo(apn): need cross platform path solution, possibly issue
// https://github.com/flutter/flutter/issues/112792
final _settingsPathProvider = FutureProvider((ref) async {
  // https://github.com/timsneath/win32/blob/458ac7c199b4cf55f0c08e8b1c21678520b7b317/lib/src/constants_nodoc.dart#L1711
  // ignore: constant_identifier_names
  const FOLDERID_ProgramData = '{62AB5D82-FDC1-4DC3-A9DD-070D1D495D97}';

  final programData = await path_provider_windows.PathProviderWindows()
      .getPath(FOLDERID_ProgramData);

  // todo(apn): folder will be different if a PR for
  // https://github.com/flutter/flutter/issues/112792 lands
  // ignore: unnecessary_non_null_assertion
  return path_.join(programData!, productId, 'settings.json');
});

final _settingsJsonReaderProvider = FutureProvider((ref) async {
  final path = await ref.watch(_settingsPathProvider.future);
  final filePath = File(path);
  if (filePath.existsSync()) {
    return File(path).readAsString();
  }
  return null;
});

final _settingsJsonWriterProvider = FutureProvider((ref) async {
  final path = await ref.watch(_settingsPathProvider.future);
  final filePath = File(path);
  return (Settings settings) {
    filePath.parent.createSync();
    final json = jsonEncode(settings.toJson());
    return filePath.writeAsString(json, flush: true, mode: FileMode.writeOnly);
  };
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<Settings>>((ref) {
  final jsonAsync = ref.watch(_settingsJsonReaderProvider);
  final writeSettingsAsync = ref.watch(_settingsJsonWriterProvider);

  final settingsAsync = jsonAsync.whenData((json) {
    if (quiver.isNotBlank(json)) {
      final jsonMap = jsonDecode(json!) as Map<String, dynamic>;
      return Settings.fromJson(jsonMap);
    }
    return Settings.defaultValue();
  });

  return SettingsNotifier(settingsAsync, writeSettingsAsync);
});

final monitoredFoldersProvider = Provider<List<MonitoredFolder>>((ref) {
  final monitoredFolders = ref.watch(
    settingsProvider.select((value) => value.asData?.value.monitoredFolders),
  );

  if (monitoredFolders == null) {
    return [];
  } else {
    return monitoredFolders;
  }
});
