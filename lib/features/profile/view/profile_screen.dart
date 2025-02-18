import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';
import 'package:schedule_app/features/profile/view/widgets/employee_profile.dart';
import 'package:schedule_app/features/profile/view/widgets/log_out_alert.dart';
import 'package:schedule_app/features/schedule/bloc/local_employees_bloc.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';
import 'package:schedule_app/features/home/bloc/user_bloc.dart';
import 'package:schedule_app/core/bloc/fetch_categories/local_categories_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _instance = FirebaseAuth.instance;
  Widget _content = const Center(
    child: CardCircularProgressIndicator(),
  );

  void onLogout() {
    showDialog(context: context, builder: (ctx) => const LogOutAlert());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoading) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Загрузка...',
              duration: const Duration(seconds: 60));
        }
        if (state is UserLoaded && state.isUpdated) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Профиль обновлен!');
        }
        if (state is UserError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          showTopSnackBar(context, 'Произошла ошибка: ${state.error}');
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          return BlocBuilder<LocalEmployeesBloc, LocalEmployeesState>(
              builder: (context, allEmployeesState) {
            List<Employee> emps = [];
            if (userState is UserLoaded) {
              Employee currentUser = (userState).user;

              _content = EmployeeProfile(
                employee: currentUser,
                isAlwaysReadOnly: false,
              );
            } else {
              _content = const Center(
                child: CardCircularProgressIndicator(),
              );
            }

            return Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(
                      onPressed: onLogout,
                      // label: const Text('Выйти'),
                      icon: const Icon(Icons.logout),
                    ),
                    IconButton(
                      onPressed: () {
                        context.push('/settings');
                      },
                      // label: const Text('Настройки'),
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                  title: const Text('Профиль Vteme'),
                ),
                body: _content);
          });
        },
      ),
    );
  }
}
