import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:schedule_app/features/settings/view/settings_screen.dart';
import 'package:schedule_app/core/widgets/person_header_progress_indicator.dart';
import 'package:schedule_app/core/widgets/person_header_widget.dart';
import 'package:schedule_app/core/models/employee.dart';

class HomeScreenDrawer extends StatefulWidget {
  const HomeScreenDrawer({super.key, required this.employee});

  final Employee employee;

  @override
  State<HomeScreenDrawer> createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer> {
  void onLogout() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
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
                      Navigator.pop(context);
                    },
                    child: const Text('Подтвердить')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Отмена'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 80,
                  child: DrawerHeader(
                    padding: const EdgeInsets.all(2),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: MasterHeaderWidget(
                        title: widget.employee.name,
                        subtitle: widget.employee.number,
                        onTap: () {},
                        imageProvider: NetworkImage(widget.employee.imageUrl),
                      ),
                    ),
                  ),
                ),
                ExpansionTile(
                  title: Text('Отзывы'),
                  children: <Widget>[
                    ListTile(title: Text('Элемент 1')),
                    ListTile(title: Text('Элемент 2')),
                    ListTile(title: Text('Элемент 3')),
                  ],
                ),
                ExpansionTile(
                  title: Text('Управление персоналом'),
                  children: <Widget>[
                    ListTile(title: Text('Элемент 4')),
                    ListTile(title: Text('Элемент 5')),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ))),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  label: const Text('Проверить\nобновления'),
                  icon: const Icon(Icons.upload),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const SettingsScreen()));
                  },
                  // label: const Text('Настройки'),
                  icon: const Icon(Icons.settings),
                ),
                IconButton(
                  onPressed: onLogout,
                  // label: const Text('Выйти'),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
