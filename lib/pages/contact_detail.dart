import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

class ContactDetail extends StatelessWidget {
  final Contact contact;
  final formKey = GlobalKey<FormState>();

  ContactDetail({
    Key? key,
    GlobalKey? formKey,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.displayName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FastForm(
            formKey: formKey,
            children: [
              FastTextField(
                name: 'first_name',
                labelText: 'First name',
                placeholder: 'Where are you going?',
              ),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(title: Text(contact.displayName)),
    //   body: ListView(
    //     children: [
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text('First name: ${contact.name.first}'),
    //           Text('Last name: ${contact.name.last}'),
    //           Text(
    //               'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
    //           Text(
    //               'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
    //           Text(
    //             'VCard: ${contact.toVCard()}',
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
