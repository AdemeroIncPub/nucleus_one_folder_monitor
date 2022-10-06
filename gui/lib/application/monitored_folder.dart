import 'package:freezed_annotation/freezed_annotation.dart';

part 'monitored_folder.freezed.dart';
part 'monitored_folder.g.dart';

enum FileDisposition {
  delete,
  move,
}

@freezed
class MonitoredFolder with _$MonitoredFolder {
  const factory MonitoredFolder({
    required String id,
    required String name,
    required String description,
    required String localPath,
    // probably not sufficient, may end up using freezed union
    // currently unsure of difference between Projects and Departments
    required String n1FolderId,
    required FileDisposition fileDisposition, // union?
    String? fileDispositionMoveToPath, // union?
  }) = _MonitoredFolder;

  factory MonitoredFolder.fromJson(Map<String, dynamic> json) =>
      _$MonitoredFolderFromJson(json);
}
