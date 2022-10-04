import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path_;
import 'package:path_provider_windows/path_provider_windows.dart'
    as path_provider_windows;

import '../util/constants.dart';
import 'settings.dart';

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
    final json = jsonEncode(settings.toJson());
    return filePath.writeAsString(json);
  };
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<Settings>>((ref) {
  final settingsPath = ref.watch(_settingsPathProvider);
  final jsonAsync = ref.watch(_settingsJsonReaderProvider);
  final writeSettings = ref.watch(_settingsJsonWriterProvider);

  ref.listenSelf((previous, next) async {
    settingsPath.whenData((settingsPath) async {
      if (next.hasValue && previous != next) {
        Directory(path_.dirname(settingsPath)).createSync();
        await writeSettings.asData?.value(next.value!);
      }
    });
  });

  final settingsAsync = jsonAsync.whenData((json) {
    if (json != null) {
      final jsonMap = jsonDecode(json) as Map<String, dynamic>;
      return Settings.fromJson(jsonMap);
    }
    return const Settings(apiKey: '');
  });

  return SettingsNotifier(settingsAsync);
});
