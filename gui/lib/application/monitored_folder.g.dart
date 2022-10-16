// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'monitored_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MonitoredFolder _$$_MonitoredFolderFromJson(Map<String, dynamic> json) =>
    _$_MonitoredFolder(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      monitoredFolder: json['monitoredFolder'] as String? ?? '',
      n1FolderId: json['n1FolderId'] as String? ?? '',
      fileDisposition: json['fileDisposition'] == null
          ? const FileDisposition.delete()
          : FileDisposition.fromJson(
              json['fileDisposition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_MonitoredFolderToJson(_$_MonitoredFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'monitoredFolder': instance.monitoredFolder,
      'n1FolderId': instance.n1FolderId,
      'fileDisposition': instance.fileDisposition,
    };

_$DeleteFileDisposition _$$DeleteFileDispositionFromJson(
        Map<String, dynamic> json) =>
    _$DeleteFileDisposition(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DeleteFileDispositionToJson(
        _$DeleteFileDisposition instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$MoveFileDisposition _$$MoveFileDispositionFromJson(
        Map<String, dynamic> json) =>
    _$MoveFileDisposition(
      folderPath: json['folderPath'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MoveFileDispositionToJson(
        _$MoveFileDisposition instance) =>
    <String, dynamic>{
      'folderPath': instance.folderPath,
      'runtimeType': instance.$type,
    };
