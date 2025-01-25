import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_app/features/settings/settings_repository.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc(this.settingsRepository) : super(SettingsInitial()) {
    on<UpdateSettings>((event, emit) async {
      emit(SettingsLoading());
      try {
        var settings = await settingsRepository.updateSettings(event);
        emit(SettingsLoaded(settings: settings));
      } catch (e) {
        emit(SettingsError(errorMessage: e.toString()));
      }
    });

    on<FetchSettings>((event, emit) async {
      emit(SettingsLoading());
      try {
        var settings = await settingsRepository.fetchSettings();
        emit(SettingsLoaded(settings: settings));
      } catch (e) {
        emit(SettingsError(errorMessage: e.toString()));
      }
    });
  }
}
