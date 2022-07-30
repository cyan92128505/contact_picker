import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'components/contact_detail.dart';

void main() => runApp(const MainAPP());

class MainAPP extends StatefulWidget {
  const MainAPP({Key? key}) : super(key: key);

  @override
  State<MainAPP> createState() => _MainAPPState();
}

class _MainAPPState extends State<MainAPP> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('聯絡人複製')),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    if (_permissionDenied) {
      return const Center(
        child: Text('Permission denied'),
      );
    }
    if (_contacts == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(_contacts![i].displayName),
        onTap: () async {
          final fullContact = await FlutterContacts.getContact(
            _contacts![i].id,
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
