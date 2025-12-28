// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Measurement _$MeasurementFromJson(Map<String, dynamic> json) {
  return _Measurement.fromJson(json);
}

/// @nodoc
mixin _$Measurement {
  String get id => throw _privateConstructorUsedError;
  String get familyId => throw _privateConstructorUsedError;
  String get childId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get updatedBy => throw _privateConstructorUsedError;
  String? get notes =>
      throw _privateConstructorUsedError; // Weight (stored in oz for consistency, converted for display)
  double? get weightOz =>
      throw _privateConstructorUsedError; // Height (stored in inches for consistency, converted for display)
  double? get heightInches =>
      throw _privateConstructorUsedError; // Head circumference (stored in inches)
  double? get headCircumferenceInches => throw _privateConstructorUsedError;

  /// Serializes this Measurement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Measurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeasurementCopyWith<Measurement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeasurementCopyWith<$Res> {
  factory $MeasurementCopyWith(
    Measurement value,
    $Res Function(Measurement) then,
  ) = _$MeasurementCopyWithImpl<$Res, Measurement>;
  @useResult
  $Res call({
    String id,
    String familyId,
    String childId,
    DateTime date,
    DateTime createdAt,
    String createdBy,
    DateTime updatedAt,
    String updatedBy,
    String? notes,
    double? weightOz,
    double? heightInches,
    double? headCircumferenceInches,
  });
}

/// @nodoc
class _$MeasurementCopyWithImpl<$Res, $Val extends Measurement>
    implements $MeasurementCopyWith<$Res> {
  _$MeasurementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Measurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? childId = null,
    Object? date = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? updatedAt = null,
    Object? updatedBy = null,
    Object? notes = freezed,
    Object? weightOz = freezed,
    Object? heightInches = freezed,
    Object? headCircumferenceInches = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            familyId: null == familyId
                ? _value.familyId
                : familyId // ignore: cast_nullable_to_non_nullable
                      as String,
            childId: null == childId
                ? _value.childId
                : childId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedBy: null == updatedBy
                ? _value.updatedBy
                : updatedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            weightOz: freezed == weightOz
                ? _value.weightOz
                : weightOz // ignore: cast_nullable_to_non_nullable
                      as double?,
            heightInches: freezed == heightInches
                ? _value.heightInches
                : heightInches // ignore: cast_nullable_to_non_nullable
                      as double?,
            headCircumferenceInches: freezed == headCircumferenceInches
                ? _value.headCircumferenceInches
                : headCircumferenceInches // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MeasurementImplCopyWith<$Res>
    implements $MeasurementCopyWith<$Res> {
  factory _$$MeasurementImplCopyWith(
    _$MeasurementImpl value,
    $Res Function(_$MeasurementImpl) then,
  ) = __$$MeasurementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String familyId,
    String childId,
    DateTime date,
    DateTime createdAt,
    String createdBy,
    DateTime updatedAt,
    String updatedBy,
    String? notes,
    double? weightOz,
    double? heightInches,
    double? headCircumferenceInches,
  });
}

/// @nodoc
class __$$MeasurementImplCopyWithImpl<$Res>
    extends _$MeasurementCopyWithImpl<$Res, _$MeasurementImpl>
    implements _$$MeasurementImplCopyWith<$Res> {
  __$$MeasurementImplCopyWithImpl(
    _$MeasurementImpl _value,
    $Res Function(_$MeasurementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Measurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? childId = null,
    Object? date = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? updatedAt = null,
    Object? updatedBy = null,
    Object? notes = freezed,
    Object? weightOz = freezed,
    Object? heightInches = freezed,
    Object? headCircumferenceInches = freezed,
  }) {
    return _then(
      _$MeasurementImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        familyId: null == familyId
            ? _value.familyId
            : familyId // ignore: cast_nullable_to_non_nullable
                  as String,
        childId: null == childId
            ? _value.childId
            : childId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedBy: null == updatedBy
            ? _value.updatedBy
            : updatedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        weightOz: freezed == weightOz
            ? _value.weightOz
            : weightOz // ignore: cast_nullable_to_non_nullable
                  as double?,
        heightInches: freezed == heightInches
            ? _value.heightInches
            : heightInches // ignore: cast_nullable_to_non_nullable
                  as double?,
        headCircumferenceInches: freezed == headCircumferenceInches
            ? _value.headCircumferenceInches
            : headCircumferenceInches // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MeasurementImpl implements _Measurement {
  const _$MeasurementImpl({
    required this.id,
    required this.familyId,
    required this.childId,
    required this.date,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.notes,
    this.weightOz,
    this.heightInches,
    this.headCircumferenceInches,
  });

  factory _$MeasurementImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeasurementImplFromJson(json);

  @override
  final String id;
  @override
  final String familyId;
  @override
  final String childId;
  @override
  final DateTime date;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final DateTime updatedAt;
  @override
  final String updatedBy;
  @override
  final String? notes;
  // Weight (stored in oz for consistency, converted for display)
  @override
  final double? weightOz;
  // Height (stored in inches for consistency, converted for display)
  @override
  final double? heightInches;
  // Head circumference (stored in inches)
  @override
  final double? headCircumferenceInches;

  @override
  String toString() {
    return 'Measurement(id: $id, familyId: $familyId, childId: $childId, date: $date, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, updatedBy: $updatedBy, notes: $notes, weightOz: $weightOz, heightInches: $heightInches, headCircumferenceInches: $headCircumferenceInches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeasurementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.weightOz, weightOz) ||
                other.weightOz == weightOz) &&
            (identical(other.heightInches, heightInches) ||
                other.heightInches == heightInches) &&
            (identical(
                  other.headCircumferenceInches,
                  headCircumferenceInches,
                ) ||
                other.headCircumferenceInches == headCircumferenceInches));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    familyId,
    childId,
    date,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    notes,
    weightOz,
    heightInches,
    headCircumferenceInches,
  );

  /// Create a copy of Measurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeasurementImplCopyWith<_$MeasurementImpl> get copyWith =>
      __$$MeasurementImplCopyWithImpl<_$MeasurementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeasurementImplToJson(this);
  }
}

abstract class _Measurement implements Measurement {
  const factory _Measurement({
    required final String id,
    required final String familyId,
    required final String childId,
    required final DateTime date,
    required final DateTime createdAt,
    required final String createdBy,
    required final DateTime updatedAt,
    required final String updatedBy,
    final String? notes,
    final double? weightOz,
    final double? heightInches,
    final double? headCircumferenceInches,
  }) = _$MeasurementImpl;

  factory _Measurement.fromJson(Map<String, dynamic> json) =
      _$MeasurementImpl.fromJson;

  @override
  String get id;
  @override
  String get familyId;
  @override
  String get childId;
  @override
  DateTime get date;
  @override
  DateTime get createdAt;
  @override
  String get createdBy;
  @override
  DateTime get updatedAt;
  @override
  String get updatedBy;
  @override
  String? get notes; // Weight (stored in oz for consistency, converted for display)
  @override
  double? get weightOz; // Height (stored in inches for consistency, converted for display)
  @override
  double? get heightInches; // Head circumference (stored in inches)
  @override
  double? get headCircumferenceInches;

  /// Create a copy of Measurement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeasurementImplCopyWith<_$MeasurementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
