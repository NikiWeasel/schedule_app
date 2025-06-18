import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/models/settings.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:schedule_app/features/settings/bloc/settings_bloc.dart';
import 'package:schedule_app/features/settings/view/widgets/color_picker_dialog.dart';
import 'package:schedule_app/features/settings/view/widgets/color_tile.dart';
import 'package:schedule_app/features/settings/view/widgets/labeled_switch.dart';
import 'package:vibration/vibration.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key, required this.settings});

  final UserSettings settings;

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  final _formKey = GlobalKey<FormState>();
  late int monthsOldToDelete;
  late bool deleteWithoutAsking;
  late bool didAsk;
  late int themeSeed;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    monthsOldToDelete = widget.settings.monthsOldToDelete;
    controller.text = widget.settings.monthsOldToDelete.toString();
    deleteWithoutAsking = widget.settings.deleteWithoutAsking;
    didAsk = widget.settings.didAsk;
    themeSeed = widget.settings.themeSeed;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _vibrate() async {
    if ((await Vibration.hasVibrator() ?? false) &&
        (await Vibration.hasAmplitudeControl() ?? false)) {
      Vibration.vibrate(amplitude: 64, duration: 250);
    }
  }

  bool _submit() {
    var isValid = _formKey.currentState!.validate();

    if (isValid) {
      return true;
    }
    return false;
  }

  Future<void> openColorPicker() async {
    var color = await showDialog(
        context: context,
        builder: (context) => ColorPickerDialog(
              activeColor: themeSeed,
            ));
    if (color == null) return;
    setState(() {
      themeSeed = color;
    });
  }

  void onChangedDeleteWithoutAsking(bool value) {
    print('onChangedDeleteWithoutAsking');
    setState(() {
      deleteWithoutAsking = value;
    });
  }

  bool didChange() {
    if (monthsOldToDelete != widget.settings.monthsOldToDelete ||
        controller.text != widget.settings.monthsOldToDelete.toString() ||
        deleteWithoutAsking != widget.settings.deleteWithoutAsking ||
        themeSeed != widget.settings.themeSeed) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        var isAdmin = false;

        if (userState is UserLoaded) {
          isAdmin = userState.user.isAdmin;
        }

        return Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (isAdmin) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  'Статистика',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            if (value == '') return;
                            monthsOldToDelete = int.parse(value);
                          });
                        },
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            label: Text('Удалять записи старее (месяцев)'),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value == '' || value == '0') {
                            return 'Некорректное значение';
                          }
                          return null;
                        },
                      ),
                    ),
                    LabeledSwitch(
                      label: 'Удалять без спроса',
                      value: deleteWithoutAsking,
                      onChanged: onChangedDeleteWithoutAsking,
                    ),
                  ])),
            ],
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                'Персонализация',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ColorTile(
                activeColor: themeSeed,
                onTap: openColorPicker,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                'Уведомления',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  LabeledSwitch(
                    label: 'Уведомлять при новых отзывах',
                    value: false,
                    onChanged: (bool b) {},
                  ),
                  LabeledSwitch(
                    label: 'Уведомлять о сессиях заранее',
                    value: false,
                    onChanged: (bool b) {},
                  ),
                ])),
            const SizedBox(
              height: 8,
            ),
            if (didChange())
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (!_submit()) return;

                    var s = UserSettings(
                        monthsOldToDelete: monthsOldToDelete,
                        deleteWithoutAsking: deleteWithoutAsking,
                        themeSeed: themeSeed,
                        didAsk: didAsk);
                    context.read<SettingsBloc>().add(
                          UpdateSettings(settings: s),
                        );
                    _vibrate();
                  },
                  label: const Text('Сохранить'),
                  icon: const Icon(Icons.save),
                ),
              )
          ]),
        );
      },
    );
  }
}
