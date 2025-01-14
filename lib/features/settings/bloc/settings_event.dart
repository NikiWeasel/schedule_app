part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class UpdateSettings extends SettingsEvent {
  final Settings settings;

  UpdateSettings({required this.settings});
}

class FetchSettings extends SettingsEvent {}
