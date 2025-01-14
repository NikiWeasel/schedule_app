import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/settings/view/widgets/color_picker_dialog.dart';
import 'package:schedule_app/features/settings/view/widgets/color_tile.dart';
import 'package:schedule_app/features/settings/view/widgets/labeled_switch.dart';
import 'package:schedule_app/features/settings/bloc/settings_bloc.dart';

import 'package:schedule_app/core/models/settings.dart';
import 'package:schedule_app/features/settings/view/widgets/settings_content.dart';

import '../../../core/utils/snackbar_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        if (settingsState is SettingsLoaded) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Настройки'),
              ),
              body: SettingsContent(
                settings: settingsState.settings,
              ));
        }
        return Scaffold(
            appBar: AppBar(
              title: const Text('Настройки'),
            ),
            body: const Center(
              child: CardCircularProgressIndicator(),
            ));
      },
    );
  }
}
