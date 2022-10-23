// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GetDocumentFoldersArgs {
  String get orgId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GetDocumentFoldersArgsCopyWith<GetDocumentFoldersArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetDocumentFoldersArgsCopyWith<$Res> {
  factory $GetDocumentFoldersArgsCopyWith(GetDocumentFoldersArgs value,
          $Res Function(GetDocumentFoldersArgs) then) =
      _$GetDocumentFoldersArgsCopyWithImpl<$Res, GetDocumentFoldersArgs>;
  @useResult
  $Res call({String orgId, String projectId, String? parentId});
}

/// @nodoc
class _$GetDocumentFoldersArgsCopyWithImpl<$Res,
        $Val extends GetDocumentFoldersArgs>
    implements $GetDocumentFoldersArgsCopyWith<$Res> {
  _$GetDocumentFoldersArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orgId = null,
    Object? projectId = null,
    Object? parentId = freezed,
  }) {
    return _then(_value.copyWith(
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GetDocumentFoldersArgsCopyWith<$Res>
    implements $GetDocumentFoldersArgsCopyWith<$Res> {
  factory _$$_GetDocumentFoldersArgsCopyWith(_$_GetDocumentFoldersArgs value,
          $Res Function(_$_GetDocumentFoldersArgs) then) =
      __$$_GetDocumentFoldersArgsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String orgId, String projectId, String? parentId});
}

/// @nodoc
class __$$_GetDocumentFoldersArgsCopyWithImpl<$Res>
    extends _$GetDocumentFoldersArgsCopyWithImpl<$Res,
        _$_GetDocumentFoldersArgs>
    implements _$$_GetDocumentFoldersArgsCopyWith<$Res> {
  __$$_GetDocumentFoldersArgsCopyWithImpl(_$_GetDocumentFoldersArgs _value,
      $Res Function(_$_GetDocumentFoldersArgs) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orgId = null,
    Object? projectId = null,
    Object? parentId = freezed,
  }) {
    return _then(_$_GetDocumentFoldersArgs(
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_GetDocumentFoldersArgs
    with DiagnosticableTreeMixin
    implements _GetDocumentFoldersArgs {
  const _$_GetDocumentFoldersArgs(
      {required this.orgId, required this.projectId, this.parentId});

  @override
  final String orgId;
  @override
  final String projectId;
  @override
  final String? parentId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GetDocumentFoldersArgs(orgId: $orgId, projectId: $projectId, parentId: $parentId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GetDocumentFoldersArgs'))
      ..add(DiagnosticsProperty('orgId', orgId))
      ..add(DiagnosticsProperty('projectId', projectId))
      ..add(DiagnosticsProperty('parentId', parentId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GetDocumentFoldersArgs &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orgId, projectId, parentId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GetDocumentFoldersArgsCopyWith<_$_GetDocumentFoldersArgs> get copyWith =>
      __$$_GetDocumentFoldersArgsCopyWithImpl<_$_GetDocumentFoldersArgs>(
          this, _$identity);
}

abstract class _GetDocumentFoldersArgs implements GetDocumentFoldersArgs {
  const factory _GetDocumentFoldersArgs(
      {required final String orgId,
      required final String projectId,
      final String? parentId}) = _$_GetDocumentFoldersArgs;

  @override
  String get orgId;
  @override
  String get projectId;
  @override
  String? get parentId;
  @override
  @JsonKey(ignore: true)
  _$$_GetDocumentFoldersArgsCopyWith<_$_GetDocumentFoldersArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetDocumentFolderByIdArgs {
  String get orgId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get folderId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GetDocumentFolderByIdArgsCopyWith<GetDocumentFolderByIdArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetDocumentFolderByIdArgsCopyWith<$Res> {
  factory $GetDocumentFolderByIdArgsCopyWith(GetDocumentFolderByIdArgs value,
          $Res Function(GetDocumentFolderByIdArgs) then) =
      _$GetDocumentFolderByIdArgsCopyWithImpl<$Res, GetDocumentFolderByIdArgs>;
  @useResult
  $Res call({String orgId, String projectId, String folderId});
}

/// @nodoc
class _$GetDocumentFolderByIdArgsCopyWithImpl<$Res,
        $Val extends GetDocumentFolderByIdArgs>
    implements $GetDocumentFolderByIdArgsCopyWith<$Res> {
  _$GetDocumentFolderByIdArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orgId = null,
    Object? projectId = null,
    Object? folderId = null,
  }) {
    return _then(_value.copyWith(
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      folderId: null == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GetDocumentFolderByIdArgsCopyWith<$Res>
    implements $GetDocumentFolderByIdArgsCopyWith<$Res> {
  factory _$$_GetDocumentFolderByIdArgsCopyWith(
          _$_GetDocumentFolderByIdArgs value,
          $Res Function(_$_GetDocumentFolderByIdArgs) then) =
      __$$_GetDocumentFolderByIdArgsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String orgId, String projectId, String folderId});
}

/// @nodoc
class __$$_GetDocumentFolderByIdArgsCopyWithImpl<$Res>
    extends _$GetDocumentFolderByIdArgsCopyWithImpl<$Res,
        _$_GetDocumentFolderByIdArgs>
    implements _$$_GetDocumentFolderByIdArgsCopyWith<$Res> {
  __$$_GetDocumentFolderByIdArgsCopyWithImpl(
      _$_GetDocumentFolderByIdArgs _value,
      $Res Function(_$_GetDocumentFolderByIdArgs) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orgId = null,
    Object? projectId = null,
    Object? folderId = null,
  }) {
    return _then(_$_GetDocumentFolderByIdArgs(
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      folderId: null == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_GetDocumentFolderByIdArgs
    with DiagnosticableTreeMixin
    implements _GetDocumentFolderByIdArgs {
  const _$_GetDocumentFolderByIdArgs(
      {required this.orgId, required this.projectId, required this.folderId});

  @override
  final String orgId;
  @override
  final String projectId;
  @override
  final String folderId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GetDocumentFolderByIdArgs(orgId: $orgId, projectId: $projectId, folderId: $folderId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GetDocumentFolderByIdArgs'))
      ..add(DiagnosticsProperty('orgId', orgId))
      ..add(DiagnosticsProperty('projectId', projectId))
      ..add(DiagnosticsProperty('folderId', folderId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GetDocumentFolderByIdArgs &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orgId, projectId, folderId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GetDocumentFolderByIdArgsCopyWith<_$_GetDocumentFolderByIdArgs>
      get copyWith => __$$_GetDocumentFolderByIdArgsCopyWithImpl<
          _$_GetDocumentFolderByIdArgs>(this, _$identity);
}

abstract class _GetDocumentFolderByIdArgs implements GetDocumentFolderByIdArgs {
  const factory _GetDocumentFolderByIdArgs(
      {required final String orgId,
      required final String projectId,
      required final String folderId}) = _$_GetDocumentFolderByIdArgs;

  @override
  String get orgId;
  @override
  String get projectId;
  @override
  String get folderId;
  @override
  @JsonKey(ignore: true)
  _$$_GetDocumentFolderByIdArgsCopyWith<_$_GetDocumentFolderByIdArgs>
      get copyWith => throw _privateConstructorUsedError;
}
