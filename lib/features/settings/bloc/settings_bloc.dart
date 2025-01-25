import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<UpdateSettings>((event, emit) async {
      emit(SettingsLoading());

      try {
        print('BLOC.didAsk1');
        print(event.settings.didAsk);
        var settings = await _updateSettings(event);
        emit(SettingsLoaded(settings: settings));
      } catch (e) {
        emit(SettingsError(errorMessage: e.toString()));
      }
    });

    on<FetchSettings>((event, emit) async {
      emit(SettingsLoading());
      try {
        print('fetch settings');
        var settings = await _fetchSettings();
        emit(SettingsLoaded(settings: settings));
      } catch (e) {
        emit(SettingsError(errorMessage: e.toString()));
      }
    });
  }

  Future<UserSettings> _fetchSettings() async {
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

  Future<UserSettings> _updateSettings(UpdateSettings event) async {
    var instance = await SharedPreferences.getInstance();
    UserSettings settings = UserSettings(
        monthsOldToDelete: event.settings.monthsOldToDelete,
        deleteWithoutAsking: event.settings.deleteWithoutAsking,
        themeSeed: event.settings.themeSeed,
        didAsk: event.settings.didAsk);

    print('event.settings.didAsk');
    print(event.settings.didAsk);
    instance.setInt('monthsOldToDelete', event.settings.monthsOldToDelete);
    instance.setBool('deleteWithoutAsking', event.settings.deleteWithoutAsking);
    instance.setBool('didAsk', event.settings.didAsk);
    instance.setInt('themeSeed', event.settings.themeSeed);

    return settings;
  }
}
