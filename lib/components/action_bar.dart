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
      PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: TextButton(
                child: const Text('匯出'),
                onPressed: () async {
                  Future.delayed(Duration.zero).then(
                    (value) => Navigator.pop(context),
                  );
                  var contactsNotifier = ref.read(contactsProvider.notifier);
                  await contactsNotifier.sharedVcardList();
                },
              ),
            ),
            PopupMenuItem(
              child: TextButton(
                child: const Text('匯入'),
                onPressed: () {
                  Future.delayed(Duration.zero).then(
                    (value) => Navigator.pop(context),
                  );
                },
              ),
            ),
            PopupMenuItem(
              child: TextButton(
                child: const Text('刪除'),
                onPressed: () async {
                  Future.delayed(Duration.zero).then(
                    (value) => Navigator.pop(context),
                  );
                  if (contacts.selectedIdList.isEmpty) {
                    return;
                  }
                  final result = await confirm(
                    context,
                    title: const Text('刪除'),
                    content: const Text('確認刪除所選擇的聯絡人?'),
                    textOK: const Text('是'),
                    textCancel: const Text('否'),
                  );

                  if (result == true) {
                    return print('pressedOK');
                  }
                  return print('pressedCancel');
                },
              ),
            ),
          ];
        },
      ),
    ]);
  }
}
