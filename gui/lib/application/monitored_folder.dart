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
    required String name,
    required String description,
    required String inputFolder,
    required NucleusOneFolder n1Folder,
    required FileDisposition fileDisposition,
    required bool enabled,
  }) = _MonitoredFolder;

  factory MonitoredFolder.fromJson(Map<String, dynamic> json) =>
      _$MonitoredFolderFromJson(json);

  // ignore: prefer_constructors_over_static_methods
  static MonitoredFolder defaultId({
    required String name,
    required String description,
    required String inputFolder,
    required NucleusOneFolder n1Folder,
    required FileDisposition fileDisposition,
    required bool enabled,
  }) {
    return MonitoredFolder(
      id: _uuid.v1(),
      name: name,
      description: description,
      inputFolder: inputFolder,
      n1Folder: n1Folder,
      fileDisposition: fileDisposition,
      enabled: enabled,
    );
  }
}

@freezed
class NucleusOneFolder with _$NucleusOneFolder {
  const factory NucleusOneFolder({
    required String organizationId,
    required String organizationName,
    required String projectId,
    required String projectName,
    required NucleusOneProjectType projectType,
    required final List<String> folderIds,
    required final List<String> folderNames,
  }) = _NucleusOneFolder;

  factory NucleusOneFolder.fromJson(Map<String, dynamic> json) =>
      _$NucleusOneFolderFromJson(json);
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
