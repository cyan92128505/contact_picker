import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactDetail extends StatelessWidget {
  final Contact contact;
  const ContactDetail({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First name: ${contact.name.first}'),
              Text('Last name: ${contact.name.last}'),
              Text(
                  'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
              Text(
                  'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
              Text(
                'VCard: ${contact.toVCard()}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
