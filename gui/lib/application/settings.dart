import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    required String apiKey,
  }) = _Settings;

  factory Settings.fromJson(Map<String, Object?> json) =>
      _$SettingsFromJson(json);
}

class SettingsNotifier extends StateNotifier<AsyncValue<Settings>> {
  SettingsNotifier(super.state);

  void setApiKey(String apiKey) {
    state = state.whenData((state) => state.copyWith(apiKey: apiKey));
  }
}
