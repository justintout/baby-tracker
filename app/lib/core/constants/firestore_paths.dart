class FirestorePaths {
  // Collections
  static const String users = 'users';
  static const String families = 'families';
  static const String invitations = 'invitations';

  // Subcollections
  static const String children = 'children';
  static const String entries = 'entries';
  static const String media = 'media';

  // Document paths
  static String user(String userId) => '$users/$userId';

  static String family(String familyId) => '$families/$familyId';

  static String child(String familyId, String childId) =>
      '$families/$familyId/$children/$childId';

  static String entry(String familyId, String childId, String entryId) =>
      '$families/$familyId/$children/$childId/$entries/$entryId';

  static String mediaItem(String familyId, String childId, String mediaId) =>
      '$families/$familyId/$children/$childId/$media/$mediaId';

  static String invitation(String invitationId) =>
      '$invitations/$invitationId';

  // Collection paths
  static String childrenCollection(String familyId) =>
      '$families/$familyId/$children';

  static String entriesCollection(String familyId, String childId) =>
      '$families/$familyId/$children/$childId/$entries';

  static String mediaCollection(String familyId, String childId) =>
      '$families/$familyId/$children/$childId/$media';
}
