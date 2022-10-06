// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Settings _$$_SettingsFromJson(Map<String, dynamic> json) => _$_Settings(
      apiKey: json['apiKey'] as String,
      monitoredFolders: (json['monitoredFolders'] as List<dynamic>)
          .map((e) => MonitoredFolder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_SettingsToJson(_$_Settings instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'monitoredFolders': instance.monitoredFolders,
    };
