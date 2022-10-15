// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'select_nucleus_one_folder_screen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SelectNucleusOneFolderScreenResult {
  n1.UserOrganization get org => throw _privateConstructorUsedError;
  n1.OrganizationProject get project => throw _privateConstructorUsedError;
  List<n1.DocumentFolder> get folders => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SelectNucleusOneFolderScreenResultCopyWith<
          SelectNucleusOneFolderScreenResult>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectNucleusOneFolderScreenResultCopyWith<$Res> {
  factory $SelectNucleusOneFolderScreenResultCopyWith(
          SelectNucleusOneFolderScreenResult value,
          $Res Function(SelectNucleusOneFolderScreenResult) then) =
      _$SelectNucleusOneFolderScreenResultCopyWithImpl<$Res>;
  $Res call(
      {n1.UserOrganization org,
      n1.OrganizationProject project,
      List<n1.DocumentFolder> folders});
}

/// @nodoc
class _$SelectNucleusOneFolderScreenResultCopyWithImpl<$Res>
    implements $SelectNucleusOneFolderScreenResultCopyWith<$Res> {
  _$SelectNucleusOneFolderScreenResultCopyWithImpl(this._value, this._then);

  final SelectNucleusOneFolderScreenResult _value;
  // ignore: unused_field
  final $Res Function(SelectNucleusOneFolderScreenResult) _then;

  @override
  $Res call({
    Object? org = freezed,
    Object? project = freezed,
    Object? folders = freezed,
  }) {
    return _then(_value.copyWith(
      org: org == freezed
          ? _value.org
          : org // ignore: cast_nullable_to_non_nullable
              as n1.UserOrganization,
      project: project == freezed
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as n1.OrganizationProject,
      folders: folders == freezed
          ? _value.folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<n1.DocumentFolder>,
    ));
  }
}

/// @nodoc
abstract class _$$_SelectNucleusOneFolderScreenResultCopyWith<$Res>
    implements $SelectNucleusOneFolderScreenResultCopyWith<$Res> {
  factory _$$_SelectNucleusOneFolderScreenResultCopyWith(
          _$_SelectNucleusOneFolderScreenResult value,
          $Res Function(_$_SelectNucleusOneFolderScreenResult) then) =
      __$$_SelectNucleusOneFolderScreenResultCopyWithImpl<$Res>;
  @override
  $Res call(
      {n1.UserOrganization org,
      n1.OrganizationProject project,
      List<n1.DocumentFolder> folders});
}

/// @nodoc
class __$$_SelectNucleusOneFolderScreenResultCopyWithImpl<$Res>
    extends _$SelectNucleusOneFolderScreenResultCopyWithImpl<$Res>
    implements _$$_SelectNucleusOneFolderScreenResultCopyWith<$Res> {
  __$$_SelectNucleusOneFolderScreenResultCopyWithImpl(
      _$_SelectNucleusOneFolderScreenResult _value,
      $Res Function(_$_SelectNucleusOneFolderScreenResult) _then)
      : super(_value, (v) => _then(v as _$_SelectNucleusOneFolderScreenResult));

  @override
  _$_SelectNucleusOneFolderScreenResult get _value =>
      super._value as _$_SelectNucleusOneFolderScreenResult;

  @override
  $Res call({
    Object? org = freezed,
    Object? project = freezed,
    Object? folders = freezed,
  }) {
    return _then(_$_SelectNucleusOneFolderScreenResult(
      org: org == freezed
          ? _value.org
          : org // ignore: cast_nullable_to_non_nullable
              as n1.UserOrganization,
      project: project == freezed
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as n1.OrganizationProject,
      folders: folders == freezed
          ? _value._folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<n1.DocumentFolder>,
    ));
  }
}

/// @nodoc

class _$_SelectNucleusOneFolderScreenResult
    with DiagnosticableTreeMixin
    implements _SelectNucleusOneFolderScreenResult {
  const _$_SelectNucleusOneFolderScreenResult(
      {required this.org,
      required this.project,
      required final List<n1.DocumentFolder> folders})
      : _folders = folders;

  @override
  final n1.UserOrganization org;
  @override
  final n1.OrganizationProject project;
  final List<n1.DocumentFolder> _folders;
  @override
  List<n1.DocumentFolder> get folders {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_folders);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SelectNucleusOneFolderScreenResult(org: $org, project: $project, folders: $folders)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SelectNucleusOneFolderScreenResult'))
      ..add(DiagnosticsProperty('org', org))
      ..add(DiagnosticsProperty('project', project))
      ..add(DiagnosticsProperty('folders', folders));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SelectNucleusOneFolderScreenResult &&
            const DeepCollectionEquality().equals(other.org, org) &&
            const DeepCollectionEquality().equals(other.project, project) &&
            const DeepCollectionEquality().equals(other._folders, _folders));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(org),
      const DeepCollectionEquality().hash(project),
      const DeepCollectionEquality().hash(_folders));

  @JsonKey(ignore: true)
  @override
  _$$_SelectNucleusOneFolderScreenResultCopyWith<
          _$_SelectNucleusOneFolderScreenResult>
      get copyWith => __$$_SelectNucleusOneFolderScreenResultCopyWithImpl<
          _$_SelectNucleusOneFolderScreenResult>(this, _$identity);
}

abstract class _SelectNucleusOneFolderScreenResult
    implements SelectNucleusOneFolderScreenResult {
  const factory _SelectNucleusOneFolderScreenResult(
          {required final n1.UserOrganization org,
          required final n1.OrganizationProject project,
          required final List<n1.DocumentFolder> folders}) =
      _$_SelectNucleusOneFolderScreenResult;

  @override
  n1.UserOrganization get org;
  @override
  n1.OrganizationProject get project;
  @override
  List<n1.DocumentFolder> get folders;
  @override
  @JsonKey(ignore: true)
  _$$_SelectNucleusOneFolderScreenResultCopyWith<
          _$_SelectNucleusOneFolderScreenResult>
      get copyWith => throw _privateConstructorUsedError;
}