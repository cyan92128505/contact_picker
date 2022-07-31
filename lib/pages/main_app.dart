import 'package:contact_picker/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/contact_detail.dart';

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
      home: Scaffold(
        appBar: AppBar(title: const Text('聯絡人複製')),
        body: _body(
          contacts: contacts.list,
          permissionDenied: contacts.permissionDenied,
        ),
      ),
    );
  }

  Widget _body({
    required List<Contact> contacts,
    required bool permissionDenied,
  }) {
    if (permissionDenied) {
      return const Center(
        child: Text('Permission denied'),
      );
    }
    if (contacts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(contacts[i].displayName),
        onTap: () async {
          final fullContact = await FlutterContacts.getContact(
            contacts[i].id,
          );
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ContactDetail(
                contact: fullContact!,
              ),
            ),
          );
        },
      ),
    );
  }
}
