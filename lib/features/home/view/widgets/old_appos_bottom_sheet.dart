import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/core/models/appointment.dart';

class OldApposBottomSheet extends StatelessWidget {
  const OldApposBottomSheet(
      {super.key,
      required this.oldAppos,
      required this.onDeleteAllAppos,
      required this.monthsOldToDelete,
      required this.onChangeSettings});

  final List<Appointment> oldAppos;
  final int monthsOldToDelete;
  final void Function() onDeleteAllAppos;
  final void Function() onChangeSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                  'Удалить старые записи',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Существует ${oldAppos.length} записей, дата которых превышает $monthsOldToDelete месяц(ев)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    onDeleteAllAppos();
                    onChangeSettings();
                    Navigator.pop(context);
                  },
                  child: const Text('Удалить')),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    onChangeSettings();
                    Navigator.pop(context);
                  },
                  child: const Text('Не удалять в этом месяце'))
            ],
          ),
        ],
      ),
    );
  }
}
