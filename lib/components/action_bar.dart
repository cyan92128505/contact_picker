import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

import '../models/contacts.dart';
import '../services/contact_service.dart';

class ActionBar extends HookConsumerWidget {
  final StateNotifierProvider<ContactsNotifier, Contacts> contactsProvider;
  const ActionBar({
    Key? key,
    required this.contactsProvider,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Contacts contacts = ref.watch(
      contactsProvider,
    );

    return Row(children: [
      Expanded(
        child: Text('聯絡人管理 (${contacts.list.length})'),
      ),
      TextButton(
        style: TextButton.styleFrom(primary: Colors.white),
        child: const Text('匯出'),
        onPressed: () {
          var contactsNotifier = ref.read(contactsProvider.notifier);
          contactsNotifier.sharedVcardList();
        },
      ),
      TextButton(
        style: TextButton.styleFrom(primary: Colors.white),
        child: const Text('匯入'),
        onPressed: () {},
      ),
      TextButton(
        style: TextButton.styleFrom(primary: Colors.white),
        child: const Text('刪除'),
        onPressed: () async {
          if (contacts.selectedIdList.isEmpty) {
            return;
          }
          if (await confirm(
            context,
            title: const Text('刪除'),
            content: const Text('確認刪除所選擇的聯絡人?'),
            textOK: const Text('是'),
            textCancel: const Text('否'),
          )) {
            return print('pressedOK');
          }
          return print('pressedCancel');
        },
      ),
    ]);
  }
}
