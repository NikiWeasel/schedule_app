class UserSettings {
  UserSettings(
      {required this.monthsOldToDelete,
      required this.deleteWithoutAsking,
      required this.didAsk,
      required this.themeSeed});

  final int monthsOldToDelete;
  final bool deleteWithoutAsking;
  final bool didAsk;
  final int themeSeed;
}
