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
  String get localPath =>
      throw _privateConstructorUsedError; // probably not sufficient, may end up using freezed union
// currently unsure of difference between Projects and Departments
  String get n1FolderId => throw _privateConstructorUsedError;
  FileDisposition? get fileDisposition =>
      throw _privateConstructorUsedError; // union?
  String? get fileDispositionMoveToPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MonitoredFolderCopyWith<MonitoredFolder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonitoredFolderCopyWith<$Res> {
  factory $MonitoredFolderCopyWith(
          MonitoredFolder value, $Res Function(MonitoredFolder) then) =
      _$MonitoredFolderCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String name,
      String description,
      String localPath,
      String n1FolderId,
      FileDisposition? fileDisposition,
      String? fileDispositionMoveToPath});
}

/// @nodoc
class _$MonitoredFolderCopyWithImpl<$Res>
    implements $MonitoredFolderCopyWith<$Res> {
  _$MonitoredFolderCopyWithImpl(this._value, this._then);

  final MonitoredFolder _value;
  // ignore: unused_field
  final $Res Function(MonitoredFolder) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? localPath = freezed,
    Object? n1FolderId = freezed,
    Object? fileDisposition = freezed,
    Object? fileDispositionMoveToPath = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      localPath: localPath == freezed
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
      n1FolderId: n1FolderId == freezed
          ? _value.n1FolderId
          : n1FolderId // ignore: cast_nullable_to_non_nullable
              as String,
      fileDisposition: fileDisposition == freezed
          ? _value.fileDisposition
          : fileDisposition // ignore: cast_nullable_to_non_nullable
              as FileDisposition?,
      fileDispositionMoveToPath: fileDispositionMoveToPath == freezed
          ? _value.fileDispositionMoveToPath
          : fileDispositionMoveToPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_MonitoredFolderCopyWith<$Res>
    implements $MonitoredFolderCopyWith<$Res> {
  factory _$$_MonitoredFolderCopyWith(
          _$_MonitoredFolder value, $Res Function(_$_MonitoredFolder) then) =
      __$$_MonitoredFolderCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String description,
      String localPath,
      String n1FolderId,
      FileDisposition? fileDisposition,
      String? fileDispositionMoveToPath});
}

/// @nodoc
class __$$_MonitoredFolderCopyWithImpl<$Res>
    extends _$MonitoredFolderCopyWithImpl<$Res>
    implements _$$_MonitoredFolderCopyWith<$Res> {
  __$$_MonitoredFolderCopyWithImpl(
      _$_MonitoredFolder _value, $Res Function(_$_MonitoredFolder) _then)
      : super(_value, (v) => _then(v as _$_MonitoredFolder));

  @override
  _$_MonitoredFolder get _value => super._value as _$_MonitoredFolder;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? localPath = freezed,
    Object? n1FolderId = freezed,
    Object? fileDisposition = freezed,
    Object? fileDispositionMoveToPath = freezed,
  }) {
    return _then(_$_MonitoredFolder(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      localPath: localPath == freezed
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
      n1FolderId: n1FolderId == freezed
          ? _value.n1FolderId
          : n1FolderId // ignore: cast_nullable_to_non_nullable
              as String,
      fileDisposition: fileDisposition == freezed
          ? _value.fileDisposition
          : fileDisposition // ignore: cast_nullable_to_non_nullable
              as FileDisposition?,
      fileDispositionMoveToPath: fileDispositionMoveToPath == freezed
          ? _value.fileDispositionMoveToPath
          : fileDispositionMoveToPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MonitoredFolder implements _MonitoredFolder {
  const _$_MonitoredFolder(
      {required this.id,
      this.name = '',
      this.description = '',
      this.localPath = '',
      this.n1FolderId = '',
      this.fileDisposition,
      this.fileDispositionMoveToPath});

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
  final String localPath;
// probably not sufficient, may end up using freezed union
// currently unsure of difference between Projects and Departments
  @override
  @JsonKey()
  final String n1FolderId;
  @override
  final FileDisposition? fileDisposition;
// union?
  @override
  final String? fileDispositionMoveToPath;

  @override
  String toString() {
    return 'MonitoredFolder(id: $id, name: $name, description: $description, localPath: $localPath, n1FolderId: $n1FolderId, fileDisposition: $fileDisposition, fileDispositionMoveToPath: $fileDispositionMoveToPath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MonitoredFolder &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.localPath, localPath) &&
            const DeepCollectionEquality()
                .equals(other.n1FolderId, n1FolderId) &&
            const DeepCollectionEquality()
                .equals(other.fileDisposition, fileDisposition) &&
            const DeepCollectionEquality().equals(
                other.fileDispositionMoveToPath, fileDispositionMoveToPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(localPath),
      const DeepCollectionEquality().hash(n1FolderId),
      const DeepCollectionEquality().hash(fileDisposition),
      const DeepCollectionEquality().hash(fileDispositionMoveToPath));

  @JsonKey(ignore: true)
  @override
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
      final String localPath,
      final String n1FolderId,
      final FileDisposition? fileDisposition,
      final String? fileDispositionMoveToPath}) = _$_MonitoredFolder;

  factory _MonitoredFolder.fromJson(Map<String, dynamic> json) =
      _$_MonitoredFolder.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get localPath;
  @override // probably not sufficient, may end up using freezed union
// currently unsure of difference between Projects and Departments
  String get n1FolderId;
  @override
  FileDisposition? get fileDisposition;
  @override // union?
  String? get fileDispositionMoveToPath;
  @override
  @JsonKey(ignore: true)
  _$$_MonitoredFolderCopyWith<_$_MonitoredFolder> get copyWith =>
      throw _privateConstructorUsedError;
}
