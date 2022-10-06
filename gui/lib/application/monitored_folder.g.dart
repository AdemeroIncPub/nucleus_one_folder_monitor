// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'monitored_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MonitoredFolder _$$_MonitoredFolderFromJson(Map<String, dynamic> json) =>
    _$_MonitoredFolder(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      localPath: json['localPath'] as String,
      n1FolderId: json['n1FolderId'] as String,
      fileDisposition:
          $enumDecode(_$FileDispositionEnumMap, json['fileDisposition']),
      fileDispositionMoveToPath: json['fileDispositionMoveToPath'] as String?,
    );

Map<String, dynamic> _$$_MonitoredFolderToJson(_$_MonitoredFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'localPath': instance.localPath,
      'n1FolderId': instance.n1FolderId,
      'fileDisposition': _$FileDispositionEnumMap[instance.fileDisposition]!,
      'fileDispositionMoveToPath': instance.fileDispositionMoveToPath,
    };

const _$FileDispositionEnumMap = {
  FileDisposition.delete: 'delete',
  FileDisposition.move: 'move',
};
