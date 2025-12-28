import 'package:freezed_annotation/freezed_annotation.dart';

part 'family.freezed.dart';
part 'family.g.dart';

enum MemberRole { owner, caregiver }

@freezed
class Member with _$Member {
  const factory Member({
    required MemberRole role,
    required DateTime joinedAt,
    required String displayName,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

@freezed
class Family with _$Family {
  const factory Family({
    required String id,
    required String name,
    required DateTime createdAt,
    required String createdBy,
    @Default([]) List<String> memberIds,
    @Default({}) Map<String, Member> members,
  }) = _Family;

  factory Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);
}
