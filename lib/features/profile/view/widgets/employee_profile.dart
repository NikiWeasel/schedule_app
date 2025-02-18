import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_categories/local_categories_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_categories/local_categories_bloc.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/authentication/view/widgets/user_image_picker.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/features/profile/view/widgets/employee_profile_categories.dart';
import 'package:schedule_app/core/models/category.dart';

class EmployeeProfile extends StatefulWidget {
  EmployeeProfile({super.key, required this.employee, this.isAlwaysReadOnly});

  final Employee employee;

  bool? isAlwaysReadOnly = false;

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
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
  File? _selectedImage;
  List<RegCategory> selectedCategories = [];

  void _submit(void Function(Employee employee) editUser) async {
    // await FirebaseAuth.instance.setPersistence(Persistence.NONE);

    var isValid = _formKey.currentState!.validate();

    List<String> selectedCatIds = selectedCategories
        .map(
          (e) => e.id!,
        )
        .toList();

    if (nameController.text == enteredName &&
        surnameController.text == enteredSurname &&
        numberController.text == enteredNumber &&
        descriptionController.text == enteredDescription &&
        _selectedImage == null &&
        selectedCatIds == widget.employee.categoryIds) {
      print('Данные такие же');
      setState(() {
        _isReadOnly = true;
      });
      return;
    }
    print('selectedCatIds');
    print(selectedCatIds);

    String imageUrl = '';
    if (_selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${widget.employee.employeeId}.jpg');

      await storageRef.putFile(_selectedImage!);

      imageUrl = await storageRef.getDownloadURL();
    }

    var employee = Employee(
        employeeId: widget.employee.employeeId,
        name: nameController.text,
        surname: surnameController.text,
        isAdmin: widget.employee.isAdmin,
        description: descriptionController.text,
        email: widget.employee.email,
        number: numberController.text,
        imageUrl: imageUrl == '' ? widget.employee.imageUrl : imageUrl,
        categoryIds: selectedCatIds);

    editUser(employee);
    setState(() {
      _isReadOnly = true;
    });
  }

  void _toggleReadOnly() {
    setState(() {
      _isReadOnly = !_isReadOnly;
    });
  }

  void setCategoreis(List<RegCategory> cats) {
    selectedCategories = cats;
  }

  @override
  void initState() {
    nameController = TextEditingController()..text = widget.employee.name;
    surnameController = TextEditingController()..text = widget.employee.surname;
    numberController = TextEditingController()..text = widget.employee.number;
    descriptionController = TextEditingController()
      ..text = widget.employee.description;

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
    enteredName = widget.employee.name;
    enteredSurname = widget.employee.surname;
    enteredNumber = widget.employee.number;
    enteredDescription = widget.employee.description;

    return BlocBuilder<LocalCategoriesBloc, FetchCategoriesState>(
      builder: (context, state) {
        if (state is LocalCategoriesLoadedState) {
          return SingleChildScrollView(
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
                                onPickedImage: (File pickedImage) {
                                  _selectedImage = pickedImage;
                                },
                              )
                            else
                              CircleAvatar(
                                radius: 40,
                                foregroundImage:
                                    NetworkImage(widget.employee.imageUrl),
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                ),
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
                            EmployeeProfileCategories(
                              userCategories: widget.employee.categoryIds,
                              allCategories: state.categories,
                              isReadOnly: _isReadOnly,
                              setCategoreis: setCategoreis,
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
                                BlocBuilder<UserBloc, UserState>(
                                  builder: (context, state) {
                                    return state is UserLoading
                                        ? ElevatedButton.icon(
                                            label: const Text('Загрузка'),
                                            onPressed: null,
                                            icon: const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                        : ElevatedButton.icon(
                                            icon: const Icon(Icons.save),
                                            onPressed: () {
                                              _submit((Employee employee) {
                                                context.read<UserBloc>().add(
                                                      UpdateUserData(
                                                          employee: employee),
                                                    );
                                              });
                                            },
                                            label: const Text('Сохранить'));
                                  },
                                )
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
          );
        }
        return const Center(
          child: CardCircularProgressIndicator(),
        );
      },
    );
  }
}
