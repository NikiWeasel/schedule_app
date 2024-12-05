import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/features/regulations/bloc/actions_regulations_bloc.dart';

class RegulationDialog extends StatefulWidget {
  const RegulationDialog({super.key, required this.regulation});

  final Regulation? regulation;

  @override
  State<RegulationDialog> createState() => _RegulationDialogState();
}

class _RegulationDialogState extends State<RegulationDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late TextEditingController nameController;
  late TextEditingController durationController;
  late TextEditingController costController;

  String selectedName = '';
  int selectedDuration = 0;
  int selectedCost = 0;

  @override
  void initState() {
    nameController = TextEditingController();
    costController = TextEditingController();
    durationController = TextEditingController();

    var regulation = widget.regulation;

    if (regulation != null) {
      nameController.text = regulation.name;
      costController.text = regulation.cost.toString();
      durationController.text = regulation.duration.toString();
    }

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    durationController.dispose();
    costController.dispose();

    super.dispose();
  }

  bool _submit() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    _formKey.currentState!.save();

    return true;
  }

  void completeEditing(void Function(Regulation reg) updateRegulation,
      void Function(Regulation reg) createRegulation) {
    if (!_submit()) {
      return;
    }
    var newReg = Regulation(
        name: selectedName, duration: selectedDuration, cost: selectedCost);
    var regulation = widget.regulation;

    if (regulation != null) {
      if (regulation.name == nameController.text &&
          regulation.cost == int.parse(costController.text) &&
          regulation.duration == int.parse(durationController.text)) {
        return;
      }
      newReg.id = regulation.id;
      updateRegulation(newReg);
    } else {
      createRegulation(newReg);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionsRegulationsBloc(_firebaseFirestore),
      child: BlocBuilder<ActionsRegulationsBloc, ActionsRegulationsState>(
        builder: (context, state) {
          return Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                      right: 8,
                      bottom: 8 + MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 3,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text(
                                widget.regulation != null
                                    ? 'Изменить услугу'
                                    : 'Добавить услугу',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Transform.scale(
                                scale: 1.3,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close)),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              label: const Text('Название'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Незаполненное поле';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            selectedName = value!;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: durationController,
                                decoration: InputDecoration(
                                    label: const Text('Длительность'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == '0') {
                                    return 'Незаполненное поле';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  selectedDuration = int.parse(value!);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: costController,
                                decoration: InputDecoration(
                                    label: const Text('Цена'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == '0') {
                                    return 'Незаполненное поле';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  selectedCost = int.parse(value!);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              completeEditing((newReg) {
                                context.read<ActionsRegulationsBloc>().add(
                                    UpdateRegulationEvent(regulation: newReg));
                              }, (newReg) {
                                context.read<ActionsRegulationsBloc>().add(
                                    CreateRegulationEvent(regulation: newReg));
                              });
                            },
                            child: const Text('Подтвердить'))
                      ])));
        },
      ),
    );
  }
}
