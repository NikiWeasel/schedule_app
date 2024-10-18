import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:schedule_app/screens/settings_screen.dart';
import 'package:schedule_app/widgets/person_header_progress_indicator.dart';
import 'package:schedule_app/widgets/person_header_widget.dart';

class MainScreenDrawer extends StatefulWidget {
  const MainScreenDrawer({super.key});

  @override
  State<MainScreenDrawer> createState() => _MainScreenDrawerState();
}

class _MainScreenDrawerState extends State<MainScreenDrawer> {
  User? user;
  var userData;
  bool _isLoading = true;

  void firebaseInit() async {
    user = FirebaseAuth.instance.currentUser;
    userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    print(userData.data().toString() + '!!!!!!!!!!!!!!');

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseInit();
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
                    padding: EdgeInsets.all(2),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: userData == null && _isLoading == true
                          ? const PersonHeaderProgressIndicator()
                          : MasterHeaderWidget(
                              title: userData.data()['name'] ?? '',
                              subtitle: userData.data()['email'] ?? '',
                              onTap: () {},
                              imageProvider: NetworkImage(
                                  userData.data()['image_url'] ?? ''),
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
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
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
