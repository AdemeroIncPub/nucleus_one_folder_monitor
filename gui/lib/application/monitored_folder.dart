import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'monitored_folder.freezed.dart';
part 'monitored_folder.g.dart';

const _uuid = Uuid();

enum FileDisposition {
  delete,
  move,
}

@freezed
class MonitoredFolder with _$MonitoredFolder {
  const factory MonitoredFolder({
    required String id,
    @Default('') String name,
    @Default('') String description,
    @Default('') String localPath,
    // probably not sufficient, may end up using freezed union
    // currently unsure of difference between Projects and Departments
    @Default('') String n1FolderId,
    FileDisposition? fileDisposition, // union?
    String? fileDispositionMoveToPath, // union?
  }) = _MonitoredFolder;

  factory MonitoredFolder.fromJson(Map<String, dynamic> json) =>
      _$MonitoredFolderFromJson(json);

  // ignore: prefer_constructors_over_static_methods
  static MonitoredFolder defaultValue() => MonitoredFolder(id: _uuid.v1());
}
