import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/appointment.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/features/authentication/view/widgets/user_image_picker.dart';

class EmployeeProfileWidget extends StatefulWidget {
  const EmployeeProfileWidget(
      {super.key, required this.employee, this.isAlwaysReadOnly = false});

  final Employee employee;
  final bool? isAlwaysReadOnly;

  @override
  State<EmployeeProfileWidget> createState() => _EmployeeProfileWidgetState();
}

class _EmployeeProfileWidgetState extends State<EmployeeProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  var _isReadOnly = true;

  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController numberController;
  late TextEditingController descriptionController;

  String enteredName = '';
  String enteredSurname = '';
  String enteredNumber = '';
  String enteredDescription = '';

  void _submit() {
    // await FirebaseAuth.instance.setPersistence(Persistence.NONE);

    var isValid = _formKey.currentState!.validate();

    if (nameController.text != enteredName ||
        surnameController.text != enteredSurname ||
        numberController.text != enteredNumber ||
        descriptionController.text != enteredDescription) {
      return;
    }
    setState(() {
      _isReadOnly = true;
    });
  }

  void _toggleReadOnly() {
    setState(() {
      _isReadOnly = !_isReadOnly;
    });
  }

  @override
  void initState() {
    nameController = TextEditingController()..text = widget.employee.name;
    surnameController = TextEditingController()..text = widget.employee.surname;
    numberController = TextEditingController()..text = widget.employee.number;
    descriptionController = TextEditingController()
      ..text = widget.employee.description;

    enteredName = widget.employee.name;
    enteredSurname = widget.employee.surname;
    enteredNumber = widget.employee.number;
    enteredDescription = widget.employee.description;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    numberController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dialogWidth = MediaQuery.of(context).size.width - 10;

    return AlertDialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.all(10),
      // Уменьшаем отступы до 10
      titlePadding: const EdgeInsets.all(10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Transform.scale(scale: 1.3, child: const Icon(Icons.close)),
            // highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Профиль Vteme',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!_isReadOnly)
                            UserImagePicker(
                              child: NetworkImage(widget.employee.imageUrl),
                              onPickedImage: (File file) {},
                            )
                          else
                            CircleAvatar(
                              radius: 40,
                              foregroundImage:
                                  NetworkImage(widget.employee.imageUrl),
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            readOnly: _isReadOnly,
                            controller: nameController,
                            decoration: InputDecoration(
                                labelText: 'Имя',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 2 ||
                                  value.trim().length > 12) {
                                return 'Некорректное имя';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // _enteredName = value!;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            readOnly: _isReadOnly,
                            controller: surnameController,
                            decoration: InputDecoration(
                                labelText: 'Фамилия',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 2 ||
                                  value.trim().length > 12) {
                                return 'Некорректная фамилия';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // _enteredSurname = value!;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            readOnly: _isReadOnly,
                            controller: numberController,
                            decoration: InputDecoration(
                                labelText: 'Номер телефона',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            validator: (value) {
                              RegExp regex = RegExp(r'''''');
                              if (value != null &&
                                  regex.hasMatch(value) &&
                                  value != '') {
                                return null;
                              }
                              return 'Некорректный номер телефона';
                            },
                            onSaved: (value) {
                              // _enteredNumber = value!;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            readOnly: _isReadOnly,
                            controller: descriptionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                                labelText: 'Описание',
                                alignLabelWithHint: true,
                                // label: Align(
                                //   child: Text('data'),
                                // ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            validator: (value) {
                              if (value == null || value.length > 150) {
                                return 'Некорректное описание';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (widget.isAlwaysReadOnly == false)
                            if (!_isReadOnly)
                              ElevatedButton.icon(
                                  icon: const Icon(Icons.save),
                                  onPressed: _submit,
                                  label: const Text('Сохранить'))
                            else
                              ElevatedButton.icon(
                                icon: const Icon(Icons.edit),
                                onPressed: _toggleReadOnly,
                                label: const Text('Изменить'),
                              )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
