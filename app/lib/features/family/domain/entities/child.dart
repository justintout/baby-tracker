import 'package:freezed_annotation/freezed_annotation.dart';

part 'child.freezed.dart';
part 'child.g.dart';

@freezed
class Child with _$Child {
  const factory Child({
    required String id,
    required String familyId,
    required String name,
    required DateTime birthDate,
    String? photoURL,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Child;

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
}
