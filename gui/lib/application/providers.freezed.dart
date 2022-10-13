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
mixin _$GetProjectDocumentFoldersArgs {
  String get orgId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GetProjectDocumentFoldersArgsCopyWith<GetProjectDocumentFoldersArgs>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetProjectDocumentFoldersArgsCopyWith<$Res> {
  factory $GetProjectDocumentFoldersArgsCopyWith(
          GetProjectDocumentFoldersArgs value,
          $Res Function(GetProjectDocumentFoldersArgs) then) =
      _$GetProjectDocumentFoldersArgsCopyWithImpl<$Res>;
  $Res call({String orgId, String projectId, String? parentId});
}

/// @nodoc
class _$GetProjectDocumentFoldersArgsCopyWithImpl<$Res>
    implements $GetProjectDocumentFoldersArgsCopyWith<$Res> {
  _$GetProjectDocumentFoldersArgsCopyWithImpl(this._value, this._then);

  final GetProjectDocumentFoldersArgs _value;
  // ignore: unused_field
  final $Res Function(GetProjectDocumentFoldersArgs) _then;

  @override
  $Res call({
    Object? orgId = freezed,
    Object? projectId = freezed,
    Object? parentId = freezed,
  }) {
    return _then(_value.copyWith(
      orgId: orgId == freezed
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: projectId == freezed
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: parentId == freezed
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_GetProjectDocumentFoldersArgsCopyWith<$Res>
    implements $GetProjectDocumentFoldersArgsCopyWith<$Res> {
  factory _$$_GetProjectDocumentFoldersArgsCopyWith(
          _$_GetProjectDocumentFoldersArgs value,
          $Res Function(_$_GetProjectDocumentFoldersArgs) then) =
      __$$_GetProjectDocumentFoldersArgsCopyWithImpl<$Res>;
  @override
  $Res call({String orgId, String projectId, String? parentId});
}

/// @nodoc
class __$$_GetProjectDocumentFoldersArgsCopyWithImpl<$Res>
    extends _$GetProjectDocumentFoldersArgsCopyWithImpl<$Res>
    implements _$$_GetProjectDocumentFoldersArgsCopyWith<$Res> {
  __$$_GetProjectDocumentFoldersArgsCopyWithImpl(
      _$_GetProjectDocumentFoldersArgs _value,
      $Res Function(_$_GetProjectDocumentFoldersArgs) _then)
      : super(_value, (v) => _then(v as _$_GetProjectDocumentFoldersArgs));

  @override
  _$_GetProjectDocumentFoldersArgs get _value =>
      super._value as _$_GetProjectDocumentFoldersArgs;

  @override
  $Res call({
    Object? orgId = freezed,
    Object? projectId = freezed,
    Object? parentId = freezed,
  }) {
    return _then(_$_GetProjectDocumentFoldersArgs(
      orgId: orgId == freezed
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: projectId == freezed
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: parentId == freezed
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_GetProjectDocumentFoldersArgs
    with DiagnosticableTreeMixin
    implements _GetProjectDocumentFoldersArgs {
  const _$_GetProjectDocumentFoldersArgs(
      {required this.orgId, required this.projectId, this.parentId});

  @override
  final String orgId;
  @override
  final String projectId;
  @override
  final String? parentId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GetProjectDocumentFoldersArgs(orgId: $orgId, projectId: $projectId, parentId: $parentId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GetProjectDocumentFoldersArgs'))
      ..add(DiagnosticsProperty('orgId', orgId))
      ..add(DiagnosticsProperty('projectId', projectId))
      ..add(DiagnosticsProperty('parentId', parentId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GetProjectDocumentFoldersArgs &&
            const DeepCollectionEquality().equals(other.orgId, orgId) &&
            const DeepCollectionEquality().equals(other.projectId, projectId) &&
            const DeepCollectionEquality().equals(other.parentId, parentId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(orgId),
      const DeepCollectionEquality().hash(projectId),
      const DeepCollectionEquality().hash(parentId));

  @JsonKey(ignore: true)
  @override
  _$$_GetProjectDocumentFoldersArgsCopyWith<_$_GetProjectDocumentFoldersArgs>
      get copyWith => __$$_GetProjectDocumentFoldersArgsCopyWithImpl<
          _$_GetProjectDocumentFoldersArgs>(this, _$identity);
}

abstract class _GetProjectDocumentFoldersArgs
    implements GetProjectDocumentFoldersArgs {
  const factory _GetProjectDocumentFoldersArgs(
      {required final String orgId,
      required final String projectId,
      final String? parentId}) = _$_GetProjectDocumentFoldersArgs;

  @override
  String get orgId;
  @override
  String get projectId;
  @override
  String? get parentId;
  @override
  @JsonKey(ignore: true)
  _$$_GetProjectDocumentFoldersArgsCopyWith<_$_GetProjectDocumentFoldersArgs>
      get copyWith => throw _privateConstructorUsedError;
}
