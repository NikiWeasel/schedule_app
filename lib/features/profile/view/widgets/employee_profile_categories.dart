import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_categories/local_categories_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_categories/local_categories_bloc.dart';
import 'package:schedule_app/core/models/category.dart';
import 'package:schedule_app/features/categories/bloc/actions_categories_bloc.dart';

class EmployeeProfileCategories extends StatefulWidget {
  const EmployeeProfileCategories(
      {super.key,
      required this.userCategories,
      required this.allCategories,
      required this.isReadOnly,
      required this.setCategoreis});

  final List<String> userCategories;
  final List<RegCategory> allCategories;
  final bool isReadOnly;

  final Function(List<RegCategory>) setCategoreis;

  @override
  State<EmployeeProfileCategories> createState() =>
      _EmployeeProfileCategoriesState();
}

class _EmployeeProfileCategoriesState extends State<EmployeeProfileCategories> {
  bool didSetValues = false;
  List<RegCategory> filteredCategories = [];

  List<bool> catBoolList = [];

  void setBoolValue(int index, List<RegCategory> allCats) {
    setState(() {
      // catBoolList[index] = !catBoolList[index];

      catBoolList[index]
          ? filteredCategories.add(allCats[index])
          : filteredCategories.remove(allCats[index]);
    });
    widget.setCategoreis(filteredCategories);
    print(filteredCategories);
  }

  bool isAnyCatIdNull(List<RegCategory> cats) {
    if (cats.any(
      (element) => element.id == null,
    )) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalCategoriesBloc, FetchCategoriesState>(
      listener: (context, state) {
        didSetValues = false;
      },
      child: Builder(
        builder: (
          context,
        ) {
          if (!didSetValues) {
            catBoolList = List.generate(
              widget.allCategories.length,
              (index) {
                if (widget.userCategories
                    .contains(widget.allCategories[index].id)) {
                  return true;
                }
                return false;
              },
            );
            filteredCategories = widget.allCategories
                .where(
                    (category) => widget.userCategories.contains(category.id))
                .toList();

            if (isAnyCatIdNull(widget.allCategories)) {
              context.read<LocalCategoriesBloc>().add(FetchCategoriesData());
            }

            didSetValues = true;
          }
          print(catBoolList);

          return IgnorePointer(
            ignoring: widget.isReadOnly,
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final Offset offset =
                            renderBox.localToGlobal(Offset.zero);
                        final RelativeRect position = RelativeRect.fromLTRB(
                          offset.dx,
                          offset.dy + renderBox.size.height, // Под виджетом
                          offset.dx + renderBox.size.width,
                          offset.dy + renderBox.size.height + 200,
                        );

                        final selected = await showMenu(
                          context: context,
                          position: position,
                          items: [
                            for (int i = 0; i < catBoolList.length; i++)
                              PopupMenuItem<int>(
                                value: i,
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return SizedBox(
                                      width: 200,
                                      child: CheckboxListTile(
                                        value: catBoolList[i],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            catBoolList[i] = value!;
                                          });
                                          setBoolValue(i, widget.allCategories);
                                        },
                                        title:
                                            Text(widget.allCategories[i].name),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: filteredCategories.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 4),
                                  child: Text(widget.isReadOnly
                                      ? 'Нет категорий'
                                      : 'Нажмите, чтобы добавить'),
                                )
                              : Wrap(
                                  spacing: 8.0,
                                  children: [
                                    for (int i = 0;
                                        i < filteredCategories.length;
                                        i++)
                                      Chip(
                                        label: Text(filteredCategories[i].name),
                                        onDeleted: widget.isReadOnly
                                            ? null
                                            : () {
                                                int index = widget.allCategories
                                                    .indexOf(
                                                        filteredCategories[i]);

                                                setState(() {
                                                  catBoolList[index] = false;
                                                });
                                                setBoolValue(index,
                                                    widget.allCategories);
                                              },
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: 0,
                    left: 6,
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          'Категории',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
