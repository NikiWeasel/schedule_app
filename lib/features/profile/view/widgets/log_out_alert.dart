import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogOutAlert extends StatelessWidget {
  const LogOutAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Выйти?',
        style: Theme.of(context).textTheme.titleLarge!,
      ),
      content: Text(
        'Вас выкинет на экран входа.',
        style: Theme.of(context).textTheme.titleMedium!,
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // context
              //     .read<UserBloc>()
              //     .add(FetchUserData());
              Navigator.pop(context);
              // AppRouter.hideNavigationBar.value = true;
              context.go('/app');
            },
            child: const Text('Подтвердить')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Отмена'))
      ],
    );
  }
}
