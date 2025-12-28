class RouteNames {
  // Auth
  static const String login = '/login';
  static const String signup = '/signup';

  // Onboarding
  static const String onboarding = '/onboarding';

  // Main
  static const String dashboard = '/';
  static const String family = '/family';
  static const String settings = '/settings';

  // Baby Management
  static const String babyList = '/babies';
  static const String addBaby = '/babies/add';
  static const String editBaby = '/babies/:id/edit';

  // Tracking
  static const String feedingForm = '/feeding';
  static const String diaperForm = '/diaper';
  static const String sleepForm = '/sleep';
  static const String measurementForm = '/measurement';
  static const String measurementHistory = '/measurements';
  static const String stats = '/stats';

  // Media
  static const String gallery = '/gallery';
  static const String mediaDetail = '/media/:id';

  // Child
  static const String childProfile = '/child/:id';
}
