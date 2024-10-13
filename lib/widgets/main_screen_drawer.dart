import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:schedule_app/screens/settings_screen.dart';
import 'package:schedule_app/widgets/person_header_widget.dart';

class MainScreenDrawer extends StatelessWidget {
  const MainScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: const [
                SizedBox(
                  height: 80,
                  child: DrawerHeader(
                    padding: EdgeInsets.all(2),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: MasterHeaderWidget(
                        title: 'Мастер 1',
                        child: Icon(Icons.person),
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
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const SettingsScreen()));
                  },
                  label: const Text('Настройки'),
                  icon: const Icon(Icons.settings),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  label: const Text('Выйти'),
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
