// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Settings _$$_SettingsFromJson(Map<String, dynamic> json) => _$_Settings(
      apiKey: json['apiKey'] as String,
      monitoredFoldersByApiKey: IMap<String, IList<MonitoredFolder>>.fromJson(
          json['monitoredFoldersByApiKey'] as Map<String, dynamic>,
          (value) => value as String,
          (value) => IList<MonitoredFolder>.fromJson(
              value,
              (value) =>
                  MonitoredFolder.fromJson(value as Map<String, dynamic>))),
    );

Map<String, dynamic> _$$_SettingsToJson(_$_Settings instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'monitoredFoldersByApiKey': instance.monitoredFoldersByApiKey.toJson(
        (value) => value,
        (value) => value.toJson(
          (value) => value,
        ),
      ),
    };
