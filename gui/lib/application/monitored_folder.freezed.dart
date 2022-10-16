// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'monitored_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MonitoredFolder _$MonitoredFolderFromJson(Map<String, dynamic> json) {
  return _MonitoredFolder.fromJson(json);
}

/// @nodoc
mixin _$MonitoredFolder {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get monitoredFolder =>
      throw _privateConstructorUsedError; // probably not sufficient, may end up using freezed union
// currently unsure of difference between Projects and Departments
  String get n1FolderId => throw _privateConstructorUsedError;
  FileDisposition get fileDisposition => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MonitoredFolderCopyWith<MonitoredFolder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonitoredFolderCopyWith<$Res> {
  factory $MonitoredFolderCopyWith(
          MonitoredFolder value, $Res Function(MonitoredFolder) then) =
      _$MonitoredFolderCopyWithImpl<$Res, MonitoredFolder>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String monitoredFolder,
      String n1FolderId,
      FileDisposition fileDisposition});

  $FileDispositionCopyWith<$Res> get fileDisposition;
}

/// @nodoc
class _$MonitoredFolderCopyWithImpl<$Res, $Val extends MonitoredFolder>
    implements $MonitoredFolderCopyWith<$Res> {
  _$MonitoredFolderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? monitoredFolder = null,
    Object? n1FolderId = null,
    Object? fileDisposition = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      monitoredFolder: null == monitoredFolder
          ? _value.monitoredFolder
          : monitoredFolder // ignore: cast_nullable_to_non_nullable
              as String,
      n1FolderId: null == n1FolderId
          ? _value.n1FolderId
          : n1FolderId // ignore: cast_nullable_to_non_nullable
              as String,
      fileDisposition: null == fileDisposition
          ? _value.fileDisposition
          : fileDisposition // ignore: cast_nullable_to_non_nullable
              as FileDisposition,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FileDispositionCopyWith<$Res> get fileDisposition {
    return $FileDispositionCopyWith<$Res>(_value.fileDisposition, (value) {
      return _then(_value.copyWith(fileDisposition: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_MonitoredFolderCopyWith<$Res>
    implements $MonitoredFolderCopyWith<$Res> {
  factory _$$_MonitoredFolderCopyWith(
          _$_MonitoredFolder value, $Res Function(_$_MonitoredFolder) then) =
      __$$_MonitoredFolderCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String monitoredFolder,
      String n1FolderId,
      FileDisposition fileDisposition});

  @override
  $FileDispositionCopyWith<$Res> get fileDisposition;
}

/// @nodoc
class __$$_MonitoredFolderCopyWithImpl<$Res>
    extends _$MonitoredFolderCopyWithImpl<$Res, _$_MonitoredFolder>
    implements _$$_MonitoredFolderCopyWith<$Res> {
  __$$_MonitoredFolderCopyWithImpl(
      _$_MonitoredFolder _value, $Res Function(_$_MonitoredFolder) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? monitoredFolder = null,
    Object? n1FolderId = null,
    Object? fileDisposition = null,
  }) {
    return _then(_$_MonitoredFolder(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      monitoredFolder: null == monitoredFolder
          ? _value.monitoredFolder
          : monitoredFolder // ignore: cast_nullable_to_non_nullable
              as String,
      n1FolderId: null == n1FolderId
          ? _value.n1FolderId
          : n1FolderId // ignore: cast_nullable_to_non_nullable
              as String,
      fileDisposition: null == fileDisposition
          ? _value.fileDisposition
          : fileDisposition // ignore: cast_nullable_to_non_nullable
              as FileDisposition,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MonitoredFolder
    with DiagnosticableTreeMixin
    implements _MonitoredFolder {
  const _$_MonitoredFolder(
      {required this.id,
      this.name = '',
      this.description = '',
      this.monitoredFolder = '',
      this.n1FolderId = '',
      this.fileDisposition = const FileDisposition.delete()});

  factory _$_MonitoredFolder.fromJson(Map<String, dynamic> json) =>
      _$$_MonitoredFolderFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String monitoredFolder;
// probably not sufficient, may end up using freezed union
// currently unsure of difference between Projects and Departments
  @override
  @JsonKey()
  final String n1FolderId;
  @override
  @JsonKey()
  final FileDisposition fileDisposition;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MonitoredFolder(id: $id, name: $name, description: $description, monitoredFolder: $monitoredFolder, n1FolderId: $n1FolderId, fileDisposition: $fileDisposition)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MonitoredFolder'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('monitoredFolder', monitoredFolder))
      ..add(DiagnosticsProperty('n1FolderId', n1FolderId))
      ..add(DiagnosticsProperty('fileDisposition', fileDisposition));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MonitoredFolder &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.monitoredFolder, monitoredFolder) ||
                other.monitoredFolder == monitoredFolder) &&
            (identical(other.n1FolderId, n1FolderId) ||
                other.n1FolderId == n1FolderId) &&
            (identical(other.fileDisposition, fileDisposition) ||
                other.fileDisposition == fileDisposition));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      monitoredFolder, n1FolderId, fileDisposition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MonitoredFolderCopyWith<_$_MonitoredFolder> get copyWith =>
      __$$_MonitoredFolderCopyWithImpl<_$_MonitoredFolder>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MonitoredFolderToJson(
      this,
    );
  }
}

abstract class _MonitoredFolder implements MonitoredFolder {
  const factory _MonitoredFolder(
      {required final String id,
      final String name,
      final String description,
      final String monitoredFolder,
      final String n1FolderId,
      final FileDisposition fileDisposition}) = _$_MonitoredFolder;

  factory _MonitoredFolder.fromJson(Map<String, dynamic> json) =
      _$_MonitoredFolder.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get monitoredFolder;
  @override // probably not sufficient, may end up using freezed union
// currently unsure of difference between Projects and Departments
  String get n1FolderId;
  @override
  FileDisposition get fileDisposition;
  @override
  @JsonKey(ignore: true)
  _$$_MonitoredFolderCopyWith<_$_MonitoredFolder> get copyWith =>
      throw _privateConstructorUsedError;
}

FileDisposition _$FileDispositionFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'delete':
      return DeleteFileDisposition.fromJson(json);
    case 'move':
      return MoveFileDisposition.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'FileDisposition',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$FileDisposition {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() delete,
    required TResult Function(String folderPath) move,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? delete,
    TResult? Function(String folderPath)? move,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? delete,
    TResult Function(String folderPath)? move,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeleteFileDisposition value) delete,
    required TResult Function(MoveFileDisposition value) move,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeleteFileDisposition value)? delete,
    TResult? Function(MoveFileDisposition value)? move,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeleteFileDisposition value)? delete,
    TResult Function(MoveFileDisposition value)? move,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileDispositionCopyWith<$Res> {
  factory $FileDispositionCopyWith(
          FileDisposition value, $Res Function(FileDisposition) then) =
      _$FileDispositionCopyWithImpl<$Res, FileDisposition>;
}

/// @nodoc
class _$FileDispositionCopyWithImpl<$Res, $Val extends FileDisposition>
    implements $FileDispositionCopyWith<$Res> {
  _$FileDispositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DeleteFileDispositionCopyWith<$Res> {
  factory _$$DeleteFileDispositionCopyWith(_$DeleteFileDisposition value,
          $Res Function(_$DeleteFileDisposition) then) =
      __$$DeleteFileDispositionCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeleteFileDispositionCopyWithImpl<$Res>
    extends _$FileDispositionCopyWithImpl<$Res, _$DeleteFileDisposition>
    implements _$$DeleteFileDispositionCopyWith<$Res> {
  __$$DeleteFileDispositionCopyWithImpl(_$DeleteFileDisposition _value,
      $Res Function(_$DeleteFileDisposition) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$DeleteFileDisposition
    with DiagnosticableTreeMixin
    implements DeleteFileDisposition {
  const _$DeleteFileDisposition({final String? $type})
      : $type = $type ?? 'delete';

  factory _$DeleteFileDisposition.fromJson(Map<String, dynamic> json) =>
      _$$DeleteFileDispositionFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FileDisposition.delete()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'FileDisposition.delete'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeleteFileDisposition);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() delete,
    required TResult Function(String folderPath) move,
  }) {
    return delete();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? delete,
    TResult? Function(String folderPath)? move,
  }) {
    return delete?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? delete,
    TResult Function(String folderPath)? move,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeleteFileDisposition value) delete,
    required TResult Function(MoveFileDisposition value) move,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeleteFileDisposition value)? delete,
    TResult? Function(MoveFileDisposition value)? move,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeleteFileDisposition value)? delete,
    TResult Function(MoveFileDisposition value)? move,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DeleteFileDispositionToJson(
      this,
    );
  }
}

abstract class DeleteFileDisposition implements FileDisposition {
  const factory DeleteFileDisposition() = _$DeleteFileDisposition;

  factory DeleteFileDisposition.fromJson(Map<String, dynamic> json) =
      _$DeleteFileDisposition.fromJson;
}

/// @nodoc
abstract class _$$MoveFileDispositionCopyWith<$Res> {
  factory _$$MoveFileDispositionCopyWith(_$MoveFileDisposition value,
          $Res Function(_$MoveFileDisposition) then) =
      __$$MoveFileDispositionCopyWithImpl<$Res>;
  @useResult
  $Res call({String folderPath});
}

/// @nodoc
class __$$MoveFileDispositionCopyWithImpl<$Res>
    extends _$FileDispositionCopyWithImpl<$Res, _$MoveFileDisposition>
    implements _$$MoveFileDispositionCopyWith<$Res> {
  __$$MoveFileDispositionCopyWithImpl(
      _$MoveFileDisposition _value, $Res Function(_$MoveFileDisposition) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? folderPath = null,
  }) {
    return _then(_$MoveFileDisposition(
      folderPath: null == folderPath
          ? _value.folderPath
          : folderPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoveFileDisposition
    with DiagnosticableTreeMixin
    implements MoveFileDisposition {
  const _$MoveFileDisposition({required this.folderPath, final String? $type})
      : $type = $type ?? 'move';

  factory _$MoveFileDisposition.fromJson(Map<String, dynamic> json) =>
      _$$MoveFileDispositionFromJson(json);

  @override
  final String folderPath;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FileDisposition.move(folderPath: $folderPath)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FileDisposition.move'))
      ..add(DiagnosticsProperty('folderPath', folderPath));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoveFileDisposition &&
            (identical(other.folderPath, folderPath) ||
                other.folderPath == folderPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, folderPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoveFileDispositionCopyWith<_$MoveFileDisposition> get copyWith =>
      __$$MoveFileDispositionCopyWithImpl<_$MoveFileDisposition>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() delete,
    required TResult Function(String folderPath) move,
  }) {
    return move(folderPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? delete,
    TResult? Function(String folderPath)? move,
  }) {
    return move?.call(folderPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? delete,
    TResult Function(String folderPath)? move,
    required TResult orElse(),
  }) {
    if (move != null) {
      return move(folderPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeleteFileDisposition value) delete,
    required TResult Function(MoveFileDisposition value) move,
  }) {
    return move(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeleteFileDisposition value)? delete,
    TResult? Function(MoveFileDisposition value)? move,
  }) {
    return move?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeleteFileDisposition value)? delete,
    TResult Function(MoveFileDisposition value)? move,
    required TResult orElse(),
  }) {
    if (move != null) {
      return move(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MoveFileDispositionToJson(
      this,
    );
  }
}

abstract class MoveFileDisposition implements FileDisposition {
  const factory MoveFileDisposition({required final String folderPath}) =
      _$MoveFileDisposition;

  factory MoveFileDisposition.fromJson(Map<String, dynamic> json) =
      _$MoveFileDisposition.fromJson;

  String get folderPath;
  @JsonKey(ignore: true)
  _$$MoveFileDispositionCopyWith<_$MoveFileDisposition> get copyWith =>
      throw _privateConstructorUsedError;
}
