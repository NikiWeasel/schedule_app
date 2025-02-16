import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/models/category.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/features/categories/bloc/actions_categories_bloc.dart';
import 'package:schedule_app/features/categories/view/widgets/regs_dialog.dart';
import 'package:schedule_app/features/regulations/bloc/actions_regulations_bloc.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({
    super.key,
    required this.category,
    required this.regsList,
  });

  final RegCategory? category;
  final List<Regulation> regsList;

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isServicesEmptyError = false;

  late TextEditingController nameController;
  late TextEditingController decsriptionController;
  List<String> selectedRegsIds = [];
  late List<bool> regsBoolList = [];

  late List<String> availibleRegsList;

  String selectedName = '';
  String selectedDescription = '';

  @override
  void initState() {
    nameController = TextEditingController();
    decsriptionController = TextEditingController();

    if (widget.category != null && widget.category!.regulationIds.isNotEmpty) {
      List<String?> availibleRegulationIds = widget.regsList
          .map(
            (element) => element.id,
          )
          .toList();
      for (int i = 0; i < availibleRegulationIds.length; i++) {
        // if (widget.category!.regulationIds[i] == availibleRegulationIds[i]) {
        if (widget.category!.regulationIds
            .contains(availibleRegulationIds[i])) {
          regsBoolList.add(true);
        } else {
          regsBoolList.add(false);
        }
      }
      print(regsBoolList);
      selectedRegsIds = List.generate(regsBoolList.length, (index) {
        print(regsBoolList[index] ? availibleRegulationIds[index] : null);
        return regsBoolList[index] ? availibleRegulationIds[index] : null;
      })
          .whereType<String>() // Фильтруем только элементы типа String
          .toList();
      print(selectedRegsIds);
    } else {
      regsBoolList = List.generate(
        widget.regsList.length,
        (index) => false,
      );
    }

    var regulation = widget.category;

    if (regulation != null) {
      nameController.text = regulation.name;
      decsriptionController.text = regulation.description;
    }

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    decsriptionController.dispose();
    super.dispose();
  }

  void openRegsSelection() async {
    List<String> regs = await showDialog(
          context: context,
          builder: (context) =>
              RegsDialog(regsList: widget.regsList, regsBoolList: regsBoolList),
        ) ??
        [];
    setState(() {
      selectedRegsIds = regs;
    });
  }

  bool _submit() {
    var isValid = _formKey.currentState!.validate();

    if (selectedRegsIds.isEmpty) {
      setState(() {
        isServicesEmptyError = true;
      });
    }
    if (!isValid || selectedRegsIds.isEmpty) {
      return false;
    }
    _formKey.currentState!.save();

    return true;
  }

  void completeEditing(void Function(RegCategory cat) updateCategory,
      void Function(RegCategory reg) createCategory) {
    if (!_submit()) {
      return;
    }
    var newCat = RegCategory(
      name: selectedName,
      description: selectedDescription,
      regulationIds: selectedRegsIds,
    );
    var category = widget.category;

    if (category != null) {
      if (category.name == nameController.text &&
          category.description == decsriptionController.text) {
        return;
      }
      newCat.id = category.id;
      updateCategory(newCat);
    } else {
      createCategory(newCat);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionsRegulationsBloc, ActionsRegulationsState>(
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
                              widget.category != null
                                  ? 'Изменить категорию'
                                  : 'Добавить категорию',
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
                        height: 16,
                      ),
                      TextFormField(
                        controller: decsriptionController,
                        // minLines: 4,
                        // maxLines: 4,
                        decoration: InputDecoration(
                            label: const Text('Описание'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Незаполненное поле';
                          // }
                          return null;
                        },
                        onSaved: (value) {
                          selectedDescription = value!;
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: openRegsSelection,
                          child: Text(
                              'Выбрать услуги ${selectedRegsIds.isNotEmpty ? '(Выбрано ${selectedRegsIds.length})' : ''}'),
                        ),
                      ),
                      if (selectedRegsIds.isEmpty && isServicesEmptyError)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Нет услуг',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            completeEditing((newCat) {
                              context
                                  .read<ActionsCategoriesBloc>()
                                  .add(UpdateCategoryEvent(category: newCat));
                            }, (newReg) {
                              context
                                  .read<ActionsCategoriesBloc>()
                                  .add(CreateCategoryEvent(category: newReg));
                            });
                          },
                          child: const Text('Подтвердить'))
                    ])));
      },
    );
  }
}
