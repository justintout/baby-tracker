import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

enum EntryType {
  feeding,
  diaper,
  sleep,
}

enum FeedingType {
  breastLeft,
  breastRight,
  bottle,
  formula,
}

enum DiaperType {
  wet,
  dirty,
  both,
}

enum SleepQuality {
  good,
  fair,
  poor,
}

@freezed
class Entry with _$Entry {
  const factory Entry({
    required String id,
    required String familyId,
    required String childId,
    required EntryType type,
    required DateTime timestamp,
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    String? notes,
    @Default([]) List<String> mediaIds,

    // Feeding-specific
    FeedingType? feedingType,
    double? amount,
    int? duration,

    // Diaper-specific
    DiaperType? diaperType,

    // Sleep-specific
    DateTime? endTime,
    SleepQuality? quality,
  }) = _Entry;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
}

extension EntryExtensions on Entry {
  bool get isFeeding => type == EntryType.feeding;
  bool get isDiaper => type == EntryType.diaper;
  bool get isSleep => type == EntryType.sleep;

  Duration? get sleepDuration {
    if (!isSleep || endTime == null) return null;
    return endTime!.difference(timestamp);
  }
}
