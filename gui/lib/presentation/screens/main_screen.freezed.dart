// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'main_screen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SortArgs {
  int? get columnIndex => throw _privateConstructorUsedError;
  bool get ascending => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SortArgsCopyWith<SortArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SortArgsCopyWith<$Res> {
  factory $SortArgsCopyWith(SortArgs value, $Res Function(SortArgs) then) =
      _$SortArgsCopyWithImpl<$Res, SortArgs>;
  @useResult
  $Res call({int? columnIndex, bool ascending});
}

/// @nodoc
class _$SortArgsCopyWithImpl<$Res, $Val extends SortArgs>
    implements $SortArgsCopyWith<$Res> {
  _$SortArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? columnIndex = freezed,
    Object? ascending = null,
  }) {
    return _then(_value.copyWith(
      columnIndex: freezed == columnIndex
          ? _value.columnIndex
          : columnIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SortArgsCopyWith<$Res> implements $SortArgsCopyWith<$Res> {
  factory _$$_SortArgsCopyWith(
          _$_SortArgs value, $Res Function(_$_SortArgs) then) =
      __$$_SortArgsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? columnIndex, bool ascending});
}

/// @nodoc
class __$$_SortArgsCopyWithImpl<$Res>
    extends _$SortArgsCopyWithImpl<$Res, _$_SortArgs>
    implements _$$_SortArgsCopyWith<$Res> {
  __$$_SortArgsCopyWithImpl(
      _$_SortArgs _value, $Res Function(_$_SortArgs) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? columnIndex = freezed,
    Object? ascending = null,
  }) {
    return _then(_$_SortArgs(
      columnIndex: freezed == columnIndex
          ? _value.columnIndex
          : columnIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SortArgs implements _SortArgs {
  _$_SortArgs({this.columnIndex, this.ascending = true});

  @override
  final int? columnIndex;
  @override
  @JsonKey()
  final bool ascending;

  @override
  String toString() {
    return 'SortArgs(columnIndex: $columnIndex, ascending: $ascending)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SortArgs &&
            (identical(other.columnIndex, columnIndex) ||
                other.columnIndex == columnIndex) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @override
  int get hashCode => Object.hash(runtimeType, columnIndex, ascending);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SortArgsCopyWith<_$_SortArgs> get copyWith =>
      __$$_SortArgsCopyWithImpl<_$_SortArgs>(this, _$identity);
}

abstract class _SortArgs implements SortArgs {
  factory _SortArgs({final int? columnIndex, final bool ascending}) =
      _$_SortArgs;

  @override
  int? get columnIndex;
  @override
  bool get ascending;
  @override
  @JsonKey(ignore: true)
  _$$_SortArgsCopyWith<_$_SortArgs> get copyWith =>
      throw _privateConstructorUsedError;
}
