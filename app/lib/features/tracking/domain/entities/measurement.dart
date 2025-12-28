import 'package:freezed_annotation/freezed_annotation.dart';

part 'measurement.freezed.dart';
part 'measurement.g.dart';

enum MeasurementUnit {
  // Weight
  oz,
  lbs,
  kg,
  // Height
  inches,
  cm,
}

@freezed
class Measurement with _$Measurement {
  const factory Measurement({
    required String id,
    required String familyId,
    required String childId,
    required DateTime date,
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    String? notes,

    // Weight (stored in oz for consistency, converted for display)
    double? weightOz,

    // Height (stored in inches for consistency, converted for display)
    double? heightInches,

    // Head circumference (stored in inches)
    double? headCircumferenceInches,
  }) = _Measurement;

  factory Measurement.fromJson(Map<String, dynamic> json) =>
      _$MeasurementFromJson(json);
}

extension MeasurementExtensions on Measurement {
  // Weight conversions
  double? get weightLbs => weightOz != null ? weightOz! / 16 : null;
  double? get weightKg => weightOz != null ? weightOz! * 0.0283495 : null;

  // Height conversions
  double? get heightCm => heightInches != null ? heightInches! * 2.54 : null;

  // Head circumference conversions
  double? get headCircumferenceCm =>
      headCircumferenceInches != null ? headCircumferenceInches! * 2.54 : null;

  // Display helpers
  String formatWeight({bool metric = false}) {
    if (weightOz == null) return '-';
    if (metric) {
      return '${weightKg!.toStringAsFixed(2)} kg';
    }
    final lbs = weightOz! ~/ 16;
    final oz = (weightOz! % 16).round();
    if (lbs > 0 && oz > 0) {
      return '$lbs lbs $oz oz';
    } else if (lbs > 0) {
      return '$lbs lbs';
    } else {
      return '$oz oz';
    }
  }

  String formatHeight({bool metric = false}) {
    if (heightInches == null) return '-';
    if (metric) {
      return '${heightCm!.toStringAsFixed(1)} cm';
    }
    final feet = heightInches! ~/ 12;
    final inches = (heightInches! % 12).round();
    if (feet > 0 && inches > 0) {
      return '$feet\' $inches"';
    } else if (feet > 0) {
      return '$feet\'';
    } else {
      return '$inches"';
    }
  }

  String formatHeadCircumference({bool metric = false}) {
    if (headCircumferenceInches == null) return '-';
    if (metric) {
      return '${headCircumferenceCm!.toStringAsFixed(1)} cm';
    }
    return '${headCircumferenceInches!.toStringAsFixed(1)}"';
  }
}
