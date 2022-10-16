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
      n1Folder: json['n1Folder'] == null
          ? NucleusOneFolder.defaultValue
          : NucleusOneFolder.fromJson(json['n1Folder'] as Map<String, dynamic>),
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
      'n1Folder': instance.n1Folder,
      'fileDisposition': instance.fileDisposition,
    };

_$_NucleusOneFolder _$$_NucleusOneFolderFromJson(Map<String, dynamic> json) =>
    _$_NucleusOneFolder(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      projectId: json['projectId'] as String,
      projectName: json['projectName'] as String,
      projectType: $enumDecode(_$N1ProjectTypeEnumMap, json['projectType']),
      folderIds:
          (json['folderIds'] as List<dynamic>).map((e) => e as String).toList(),
      folderNames: (json['folderNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$_NucleusOneFolderToJson(_$_NucleusOneFolder instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'projectType': _$N1ProjectTypeEnumMap[instance.projectType]!,
      'folderIds': instance.folderIds,
      'folderNames': instance.folderNames,
    };

const _$N1ProjectTypeEnumMap = {
  N1ProjectType.projects: 'projects',
  N1ProjectType.departments: 'departments',
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
