import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_app/core/models/settings.dart';
import 'package:schedule_app/features/settings/bloc/settings_bloc.dart';

class SettingsRepository {
  Future<UserSettings> fetchSettings() async {
    var instance = await SharedPreferences.getInstance();

    int monthsOldToDelete = instance.getInt('monthsOldToDelete') ?? 6;
    bool deleteWithoutAsking = instance.getBool('deleteWithoutAsking') ?? false;
    bool didAsk = instance.getBool('didAsk') ?? false;
    int themeSeed = (instance.getInt('themeSeed')) ?? 0xFF9A00A5;

    UserSettings settings = UserSettings(
        monthsOldToDelete: monthsOldToDelete,
        deleteWithoutAsking: deleteWithoutAsking,
        themeSeed: themeSeed,
        didAsk: didAsk);

    return settings;
  }

  Future<UserSettings> updateSettings(UpdateSettings event) async {
    var instance = await SharedPreferences.getInstance();
    UserSettings settings = UserSettings(
        monthsOldToDelete: event.settings.monthsOldToDelete,
        deleteWithoutAsking: event.settings.deleteWithoutAsking,
        themeSeed: event.settings.themeSeed,
        didAsk: event.settings.didAsk);

    instance.setInt('monthsOldToDelete', event.settings.monthsOldToDelete);
    instance.setBool('deleteWithoutAsking', event.settings.deleteWithoutAsking);
    instance.setBool('didAsk', event.settings.didAsk);
    instance.setInt('themeSeed', event.settings.themeSeed);

    return settings;
  }
}
