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

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(
    super.state,
    WriteSettingsFunc writeSettingsFunc,
  ) : _writeSettingsFunc = writeSettingsFunc;

  final WriteSettingsFunc _writeSettingsFunc;

  void setApiKey(String apiKey) {
    state = state.copyWith(apiKey: apiKey);
    _writeSettingsFunc(state);
  }

  /// Will add or update depending if the [id] matches an existing item.
  void saveMonitoredFolder(MonitoredFolder monitoredFolder) {
    final mfs = state.monitoredFolders;
    final index = mfs.indexWhere((x) => x.id == monitoredFolder.id);
    if (index == -1) {
      state = state.copyWith(monitoredFolders: [...mfs, monitoredFolder]);
    } else {
      final newMfs = mfs.toList()..[index] = monitoredFolder;
      state = state.copyWith(monitoredFolders: newMfs);
    }
    _writeSettingsFunc(state);
  }
}
