import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'monitored_folder.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    required String apiKey,
    required IMap<String, IList<MonitoredFolder>> monitoredFoldersByApiKey,
  }) = _Settings;

  factory Settings.fromJson(Map<String, Object?> json) =>
      _$SettingsFromJson(json);

  // ignore: prefer_constructors_over_static_methods
  static Settings defaultValue() =>
      const Settings(apiKey: '', monitoredFoldersByApiKey: IMapConst({}));
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(
    super.state,
    this._writeSettingsFn,
  );

  final void Function(Settings settings) _writeSettingsFn;

  void setApiKey(String apiKey) {
    final previousState = state;
    state = state.copyWith(apiKey: apiKey);

    if (previousState != state) {
      _writeSettingsFn(state);
    }
  }

  /// Will add or update depending if the [id] matches an existing item.
  void saveMonitoredFolder(MonitoredFolder monitoredFolder) {
    assert(state.apiKey.isNotEmpty);

    final previousState = state;
    final newMfs = state.monitoredFoldersByApiKey.update(
      state.apiKey,
      (x) => x.updateById([monitoredFolder], (x) => x.id),
      ifAbsent: () => [monitoredFolder].lock,
    );
    state = state.copyWith(monitoredFoldersByApiKey: newMfs);

    if (previousState != state) {
      _writeSettingsFn(state);
    }
  }

  void deleteMonitoredFolder({required String monitoredFolderId}) {
    assert(state.apiKey.isNotEmpty);

    final previousState = state;
    final newMfs = state.monitoredFoldersByApiKey.update(
      state.apiKey,
      (mfs) => mfs.removeWhere((x) => x.id == monitoredFolderId),
    );
    state = state.copyWith(monitoredFoldersByApiKey: newMfs);

    if (previousState != state) {
      _writeSettingsFn(state);
    }
  }
}
