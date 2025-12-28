// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeasurementImpl _$$MeasurementImplFromJson(Map<String, dynamic> json) =>
    _$MeasurementImpl(
      id: json['id'] as String,
      familyId: json['familyId'] as String,
      childId: json['childId'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String,
      notes: json['notes'] as String?,
      weightOz: (json['weightOz'] as num?)?.toDouble(),
      heightInches: (json['heightInches'] as num?)?.toDouble(),
      headCircumferenceInches: (json['headCircumferenceInches'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$$MeasurementImplToJson(_$MeasurementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'childId': instance.childId,
      'date': instance.date.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'notes': instance.notes,
      'weightOz': instance.weightOz,
      'heightInches': instance.heightInches,
      'headCircumferenceInches': instance.headCircumferenceInches,
    };
