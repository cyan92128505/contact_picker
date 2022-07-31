import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'contact_detail.dart';

class ContactTerm extends StatelessWidget {
  final Contact contact;
  final List<String> selectedIdList;
  final Function onChange;

  const ContactTerm({
    Key? key,
    required this.contact,
    required this.selectedIdList,
    required this.onChange,
  }) : super(key: key);

  String get contectDisplayTitle {
    if (contact.displayName.isNotEmpty) {
      return contact.displayName;
    }

    if (contact.phones.isNotEmpty) {
      return contact.phones.first.number;
    }

    if (contact.emails.isNotEmpty) {
      return contact.emails.first.address;
    }

    return contact.id;
  }

  Widget get avatar {
    if (contact.photoOrThumbnail == null) {
      return Container();
    }

    return CircleAvatar(
      child: Image.memory(contact.photoOrThumbnail!),
    );
  }

  bool get isSelected {
    return selectedIdList.contains(contact.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isSelected ? Colors.black12 : Colors.white,
      title: Text(contectDisplayTitle),
      onLongPress: () => FlutterContacts.getContact(
        contact.id,
      ).then(
        (fullContact) => displayDetial(
          context,
          fullContact: fullContact!,
        ),
      ),
      onTap: () => onChange(),
    );
  }

  displayDetial(
    BuildContext context, {
    required Contact fullContact,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ContactDetail(
          contact: fullContact,
        ),
      ),
    );
  }
}
