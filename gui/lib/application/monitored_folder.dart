import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import 'enums.dart';

part 'monitored_folder.freezed.dart';
part 'monitored_folder.g.dart';

const _uuid = Uuid();

@freezed
class MonitoredFolder with _$MonitoredFolder {
  const factory MonitoredFolder({
    required String id,
    @Default('') String name,
    @Default('') String description,
    @Default('') String monitoredFolder,
    @Default(NucleusOneFolder.defaultValue) NucleusOneFolder n1Folder,
    @Default(FileDisposition.delete()) FileDisposition fileDisposition,
  }) = _MonitoredFolder;

  factory MonitoredFolder.fromJson(Map<String, dynamic> json) =>
      _$MonitoredFolderFromJson(json);

  // ignore: prefer_constructors_over_static_methods
  static MonitoredFolder defaultValue() => MonitoredFolder(
        id: _uuid.v1(),
        n1Folder: NucleusOneFolder.defaultValue,
      );
}

@freezed
class NucleusOneFolder with _$NucleusOneFolder {
  const factory NucleusOneFolder({
    required String organizationId,
    required String organizationName,
    required String projectId,
    required String projectName,
    required N1ProjectType projectType,
    required final List<String> folderIds,
    required final List<String> folderNames,
  }) = _NucleusOneFolder;

  factory NucleusOneFolder.fromJson(Map<String, dynamic> json) =>
      _$NucleusOneFolderFromJson(json);

  static const NucleusOneFolder defaultValue = NucleusOneFolder(
    organizationId: '',
    organizationName: '',
    projectId: '',
    projectName: '',
    projectType: N1ProjectType.projects,
    folderIds: [],
    folderNames: [],
  );
}

@freezed
class FileDisposition with _$FileDisposition {
  const factory FileDisposition.delete() = DeleteFileDisposition;
  const factory FileDisposition.move({
    required String folderPath,
  }) = MoveFileDisposition;

  factory FileDisposition.fromJson(Map<String, dynamic> json) =>
      _$FileDispositionFromJson(json);
}
