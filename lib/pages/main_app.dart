import 'package:contact_picker/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/action_bar.dart';
import '../components/contact_term.dart';
import '../models/contacts.dart';

class MainAPP extends StatefulHookConsumerWidget {
  final ContactService contactService;

  const MainAPP({
    Key? key,
    required this.contactService,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAPPState();
}

class _MainAPPState extends ConsumerState<MainAPP> {
  @override
  void initState() {
    widget.contactService.fetchContacts(ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Contacts contacts = ref.watch(
      widget.contactService.contacts,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: ActionBar(
            contactsProvider: widget.contactService.contacts,
          ),
        ),
        body: _body(
          contacts: contacts,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _body({
    required Contacts contacts,
  }) {
    if (contacts.permissionDenied) {
      return const Center(
        child: Text('Permission denied'),
      );
    }
    if (contacts.list.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: contacts.list.length,
      itemBuilder: (context, i) => ContactTerm(
        contact: contacts.list[i],
        selectedIdList: contacts.selectedIdList,
        onChange: () {
          var contactsNotifier =
              ref.read(widget.contactService.contacts.notifier);

          contactsNotifier.addSelect(contacts.list[i]);
        },
      ),
    );
  }
}
