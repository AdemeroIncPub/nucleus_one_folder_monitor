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
      inputFolder: json['inputFolder'] as String,
      n1Folder:
          NucleusOneFolder.fromJson(json['n1Folder'] as Map<String, dynamic>),
      fileDisposition: FileDisposition.fromJson(
          json['fileDisposition'] as Map<String, dynamic>),
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$$_MonitoredFolderToJson(_$_MonitoredFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'inputFolder': instance.inputFolder,
      'n1Folder': instance.n1Folder,
      'fileDisposition': instance.fileDisposition,
      'enabled': instance.enabled,
    };

_$_NucleusOneFolder _$$_NucleusOneFolderFromJson(Map<String, dynamic> json) =>
    _$_NucleusOneFolder(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      projectId: json['projectId'] as String,
      projectName: json['projectName'] as String,
      projectType:
          $enumDecode(_$NucleusOneProjectTypeEnumMap, json['projectType']),
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
      'projectType': _$NucleusOneProjectTypeEnumMap[instance.projectType]!,
      'folderIds': instance.folderIds,
      'folderNames': instance.folderNames,
    };

const _$NucleusOneProjectTypeEnumMap = {
  NucleusOneProjectType.project: 'project',
  NucleusOneProjectType.department: 'department',
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
