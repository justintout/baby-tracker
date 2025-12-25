// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Entry _$EntryFromJson(Map<String, dynamic> json) {
  return _Entry.fromJson(json);
}

/// @nodoc
mixin _$Entry {
  String get id => throw _privateConstructorUsedError;
  String get familyId => throw _privateConstructorUsedError;
  String get childId => throw _privateConstructorUsedError;
  EntryType get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get updatedBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String> get mediaIds =>
      throw _privateConstructorUsedError; // Feeding-specific
  FeedingType? get feedingType => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError; // Diaper-specific
  DiaperType? get diaperType =>
      throw _privateConstructorUsedError; // Sleep-specific
  DateTime? get endTime => throw _privateConstructorUsedError;
  SleepQuality? get quality => throw _privateConstructorUsedError;

  /// Serializes this Entry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntryCopyWith<Entry> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryCopyWith<$Res> {
  factory $EntryCopyWith(Entry value, $Res Function(Entry) then) =
      _$EntryCopyWithImpl<$Res, Entry>;
  @useResult
  $Res call({
    String id,
    String familyId,
    String childId,
    EntryType type,
    DateTime timestamp,
    DateTime createdAt,
    String createdBy,
    DateTime updatedAt,
    String updatedBy,
    String? notes,
    List<String> mediaIds,
    FeedingType? feedingType,
    double? amount,
    int? duration,
    DiaperType? diaperType,
    DateTime? endTime,
    SleepQuality? quality,
  });
}

/// @nodoc
class _$EntryCopyWithImpl<$Res, $Val extends Entry>
    implements $EntryCopyWith<$Res> {
  _$EntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? childId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? updatedAt = null,
    Object? updatedBy = null,
    Object? notes = freezed,
    Object? mediaIds = null,
    Object? feedingType = freezed,
    Object? amount = freezed,
    Object? duration = freezed,
    Object? diaperType = freezed,
    Object? endTime = freezed,
    Object? quality = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as EntryType,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
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
            mediaIds: null == mediaIds
                ? _value.mediaIds
                : mediaIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            feedingType: freezed == feedingType
                ? _value.feedingType
                : feedingType // ignore: cast_nullable_to_non_nullable
                      as FeedingType?,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
            diaperType: freezed == diaperType
                ? _value.diaperType
                : diaperType // ignore: cast_nullable_to_non_nullable
                      as DiaperType?,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            quality: freezed == quality
                ? _value.quality
                : quality // ignore: cast_nullable_to_non_nullable
                      as SleepQuality?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EntryImplCopyWith<$Res> implements $EntryCopyWith<$Res> {
  factory _$$EntryImplCopyWith(
    _$EntryImpl value,
    $Res Function(_$EntryImpl) then,
  ) = __$$EntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String familyId,
    String childId,
    EntryType type,
    DateTime timestamp,
    DateTime createdAt,
    String createdBy,
    DateTime updatedAt,
    String updatedBy,
    String? notes,
    List<String> mediaIds,
    FeedingType? feedingType,
    double? amount,
    int? duration,
    DiaperType? diaperType,
    DateTime? endTime,
    SleepQuality? quality,
  });
}

/// @nodoc
class __$$EntryImplCopyWithImpl<$Res>
    extends _$EntryCopyWithImpl<$Res, _$EntryImpl>
    implements _$$EntryImplCopyWith<$Res> {
  __$$EntryImplCopyWithImpl(
    _$EntryImpl _value,
    $Res Function(_$EntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? childId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? updatedAt = null,
    Object? updatedBy = null,
    Object? notes = freezed,
    Object? mediaIds = null,
    Object? feedingType = freezed,
    Object? amount = freezed,
    Object? duration = freezed,
    Object? diaperType = freezed,
    Object? endTime = freezed,
    Object? quality = freezed,
  }) {
    return _then(
      _$EntryImpl(
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
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as EntryType,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
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
        mediaIds: null == mediaIds
            ? _value._mediaIds
            : mediaIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        feedingType: freezed == feedingType
            ? _value.feedingType
            : feedingType // ignore: cast_nullable_to_non_nullable
                  as FeedingType?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        diaperType: freezed == diaperType
            ? _value.diaperType
            : diaperType // ignore: cast_nullable_to_non_nullable
                  as DiaperType?,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        quality: freezed == quality
            ? _value.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as SleepQuality?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EntryImpl implements _Entry {
  const _$EntryImpl({
    required this.id,
    required this.familyId,
    required this.childId,
    required this.type,
    required this.timestamp,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.notes,
    final List<String> mediaIds = const [],
    this.feedingType,
    this.amount,
    this.duration,
    this.diaperType,
    this.endTime,
    this.quality,
  }) : _mediaIds = mediaIds;

  factory _$EntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntryImplFromJson(json);

  @override
  final String id;
  @override
  final String familyId;
  @override
  final String childId;
  @override
  final EntryType type;
  @override
  final DateTime timestamp;
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
  final List<String> _mediaIds;
  @override
  @JsonKey()
  List<String> get mediaIds {
    if (_mediaIds is EqualUnmodifiableListView) return _mediaIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaIds);
  }

  // Feeding-specific
  @override
  final FeedingType? feedingType;
  @override
  final double? amount;
  @override
  final int? duration;
  // Diaper-specific
  @override
  final DiaperType? diaperType;
  // Sleep-specific
  @override
  final DateTime? endTime;
  @override
  final SleepQuality? quality;

  @override
  String toString() {
    return 'Entry(id: $id, familyId: $familyId, childId: $childId, type: $type, timestamp: $timestamp, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, updatedBy: $updatedBy, notes: $notes, mediaIds: $mediaIds, feedingType: $feedingType, amount: $amount, duration: $duration, diaperType: $diaperType, endTime: $endTime, quality: $quality)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._mediaIds, _mediaIds) &&
            (identical(other.feedingType, feedingType) ||
                other.feedingType == feedingType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.diaperType, diaperType) ||
                other.diaperType == diaperType) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    familyId,
    childId,
    type,
    timestamp,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    notes,
    const DeepCollectionEquality().hash(_mediaIds),
    feedingType,
    amount,
    duration,
    diaperType,
    endTime,
    quality,
  );

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryImplCopyWith<_$EntryImpl> get copyWith =>
      __$$EntryImplCopyWithImpl<_$EntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntryImplToJson(this);
  }
}

abstract class _Entry implements Entry {
  const factory _Entry({
    required final String id,
    required final String familyId,
    required final String childId,
    required final EntryType type,
    required final DateTime timestamp,
    required final DateTime createdAt,
    required final String createdBy,
    required final DateTime updatedAt,
    required final String updatedBy,
    final String? notes,
    final List<String> mediaIds,
    final FeedingType? feedingType,
    final double? amount,
    final int? duration,
    final DiaperType? diaperType,
    final DateTime? endTime,
    final SleepQuality? quality,
  }) = _$EntryImpl;

  factory _Entry.fromJson(Map<String, dynamic> json) = _$EntryImpl.fromJson;

  @override
  String get id;
  @override
  String get familyId;
  @override
  String get childId;
  @override
  EntryType get type;
  @override
  DateTime get timestamp;
  @override
  DateTime get createdAt;
  @override
  String get createdBy;
  @override
  DateTime get updatedAt;
  @override
  String get updatedBy;
  @override
  String? get notes;
  @override
  List<String> get mediaIds; // Feeding-specific
  @override
  FeedingType? get feedingType;
  @override
  double? get amount;
  @override
  int? get duration; // Diaper-specific
  @override
  DiaperType? get diaperType; // Sleep-specific
  @override
  DateTime? get endTime;
  @override
  SleepQuality? get quality;

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntryImplCopyWith<_$EntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
