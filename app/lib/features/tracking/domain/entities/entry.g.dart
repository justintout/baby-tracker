// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntryImpl _$$EntryImplFromJson(Map<String, dynamic> json) => _$EntryImpl(
  id: json['id'] as String,
  familyId: json['familyId'] as String,
  childId: json['childId'] as String,
  type: $enumDecode(_$EntryTypeEnumMap, json['type']),
  timestamp: DateTime.parse(json['timestamp'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  createdBy: json['createdBy'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  notes: json['notes'] as String?,
  mediaIds:
      (json['mediaIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  feedingType: $enumDecodeNullable(_$FeedingTypeEnumMap, json['feedingType']),
  amount: (json['amount'] as num?)?.toDouble(),
  duration: (json['duration'] as num?)?.toInt(),
  diaperType: $enumDecodeNullable(_$DiaperTypeEnumMap, json['diaperType']),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  quality: $enumDecodeNullable(_$SleepQualityEnumMap, json['quality']),
);

Map<String, dynamic> _$$EntryImplToJson(_$EntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'childId': instance.childId,
      'type': _$EntryTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'notes': instance.notes,
      'mediaIds': instance.mediaIds,
      'feedingType': _$FeedingTypeEnumMap[instance.feedingType],
      'amount': instance.amount,
      'duration': instance.duration,
      'diaperType': _$DiaperTypeEnumMap[instance.diaperType],
      'endTime': instance.endTime?.toIso8601String(),
      'quality': _$SleepQualityEnumMap[instance.quality],
    };

const _$EntryTypeEnumMap = {
  EntryType.feeding: 'feeding',
  EntryType.diaper: 'diaper',
  EntryType.sleep: 'sleep',
};

const _$FeedingTypeEnumMap = {
  FeedingType.breastLeft: 'breastLeft',
  FeedingType.breastRight: 'breastRight',
  FeedingType.bottle: 'bottle',
  FeedingType.formula: 'formula',
};

const _$DiaperTypeEnumMap = {
  DiaperType.wet: 'wet',
  DiaperType.dirty: 'dirty',
  DiaperType.both: 'both',
};

const _$SleepQualityEnumMap = {
  SleepQuality.good: 'good',
  SleepQuality.fair: 'fair',
  SleepQuality.poor: 'poor',
};
