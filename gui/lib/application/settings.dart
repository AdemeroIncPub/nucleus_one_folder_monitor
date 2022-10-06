import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'monitored_folder.dart';
import 'providers.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    required String apiKey,
    required List<MonitoredFolder> monitoredFolders,
  }) = _Settings;

  factory Settings.fromJson(Map<String, Object?> json) =>
      _$SettingsFromJson(json);

  // ignore: prefer_constructors_over_static_methods
  static Settings defaultValue() =>
      const Settings(apiKey: '', monitoredFolders: []);
}

class SettingsNotifier extends StateNotifier<AsyncValue<Settings>> {
  SettingsNotifier(
    super.state,
    AsyncValue<WriteSettingsFunc> writeSettingsFunc,
  ) : _writeSettingsFunc = writeSettingsFunc;

  final AsyncValue<WriteSettingsFunc> _writeSettingsFunc;

  Future<void> setApiKey(String apiKey) async {
    state = state.whenData((state) {
      return state.copyWith(apiKey: apiKey);
    });
    return _writeSettings();
  }

  Future<void> _writeSettings() async {
    final settings = state.asData?.value;
    if (settings != null) {
      await _writeSettingsFunc.asData?.value(settings);
    }
  }
}
