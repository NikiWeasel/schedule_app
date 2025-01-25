part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

// final class SettingsUpdated extends SettingsState {}

final class SettingsLoaded extends SettingsState {
  final UserSettings settings;

  SettingsLoaded({required this.settings});
}

final class SettingsError extends SettingsState {
  final String errorMessage;

  SettingsError({required this.errorMessage});
}
