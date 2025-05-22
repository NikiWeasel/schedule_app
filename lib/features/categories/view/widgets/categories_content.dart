import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_categories/local_categories_bloc.dart';
import 'package:schedule_app/core/models/regulation.dart';
import 'package:schedule_app/features/categories/bloc/actions_categories_bloc.dart';
import 'package:schedule_app/features/regulations/view/widgets/regulation_dialog.dart';
import 'package:schedule_app/features/regulations/view/widgets/regulation_tile.dart';
import 'package:schedule_app/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/core/widgets/alert_confirm_dialog.dart';
import 'package:schedule_app/features/regulations/bloc/actions_regulations_bloc.dart';
import 'package:schedule_app/core/models/category.dart';
import 'package:schedule_app/features/categories/view/widgets/category_dialog.dart';
import 'package:schedule_app/features/categories/view/widgets/category_tile.dart';

class CategoriesContent extends StatefulWidget {
  const CategoriesContent(
      {super.key,
      required this.catList,
      required this.isAdmin,
      required this.allRegs});

  final List<RegCategory> catList;
  final List<Regulation> allRegs;
  final bool isAdmin;

  @override
  State<CategoriesContent> createState() => _CategoriesContentState();
}

class _CategoriesContentState extends State<CategoriesContent> {
  void renew() {
    context.read<LocalCategoriesBloc>().add(FetchCategoriesData());
  }

  List<Regulation> getServicesForCategory(List<Regulation> allServices,
      List<RegCategory> allCategories, RegCategory? targetCategory) {
    final Set<String> assignedServiceIds = allCategories
        .where((category) =>
            targetCategory == null || category.id != targetCategory.id)
        .expand((category) => category.regulationIds)
        .toSet();

    // Фильтруем услуги: если targetCategory == null, возвращаем только свободные услуги
    return allServices
        .where((service) =>
            !assignedServiceIds.contains(service.id) ||
            (targetCategory != null &&
                targetCategory.regulationIds.contains(service.id)))
        .toList();
  }

  void onLongPress(RegCategory cat, bool isAdmin) {
    List<RegCategory> cats = widget.catList
        .where(
          (element) => cat.regulationIds.contains(element.id),
        )
        .toList();

    if (isAdmin) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true, // Важно!

          builder: (context) => CategoryDialog(
                regsList:
                    getServicesForCategory(widget.allRegs, widget.catList, cat),
                category: cat,
              ));
    } else {
      showSnackBar(context, 'Нельзя редактировать категории');
    }
  }

  Future<bool> confirmDismiss(RegCategory cat) async {
    bool wasDismissed = false;
    await showDialog(
        context: context,
        builder: (ctx) => AlertConfirmDialog(
            title: 'Удалить категорию?',
            content: 'Категория будет удалена навсегда.',
            onConfirm: () {
              context
                  .read<ActionsCategoriesBloc>()
                  .add(DeleteCategoryEvent(category: cat));
              wasDismissed = false;
            }));
    return wasDismissed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        actions: [
          IconButton(onPressed: renew, icon: const Icon(Icons.autorenew))
        ],
      ),
      body: widget.catList.isEmpty
          ? const Center(
              child: Text('Нет категорий'),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              children: [
                for (var reg in widget.catList)
                  widget.isAdmin
                      ? Dismissible(
                          direction: DismissDirection.endToStart,
                          dismissThresholds: const {
                            DismissDirection.endToStart: 0.5
                          },
                          confirmDismiss: (dis) {
                            return confirmDismiss(reg);
                          },
                          key: ValueKey<int>(widget.catList.indexOf(reg)),
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Theme.of(context).colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.delete_outline,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                          onDismissed: (DismissDirection direction) {
                            // context
                            //     .read<ActionsRegulationsBloc>()
                            //     .add(DeleteRegulationEvent(regulation: reg));
                          },
                          child: CategoryTile(
                            isAdmin: widget.isAdmin,
                            onLongPress: () {
                              onLongPress(reg, widget.isAdmin);
                            },
                            category: reg,
                          ),
                        )
                      : CategoryTile(
                          isAdmin: widget.isAdmin,
                          onLongPress: () {
                            onLongPress(reg, widget.isAdmin);
                          },
                          category: reg,
                        ),
              ],
            ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => CategoryDialog(
                          category: null,
                          regsList: getServicesForCategory(
                              widget.allRegs, widget.catList, null),
                        ));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
