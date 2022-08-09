import 'package:flutter_contacts/flutter_contacts.dart';

class Contacts {
  List<Contact> list;
  List<String> selectedIdList;
  bool permissionDenied;

  Contacts({
    required this.list,
    required this.selectedIdList,
    required this.permissionDenied,
  });

  factory Contacts.initail() {
    return Contacts(
      list: [],
      selectedIdList: [],
      permissionDenied: false,
    );
  }

  factory Contacts.copy({
    required List<Contact> list,
    required List<String> selectedIdList,
    required bool permissionDenied,
  }) {
    return Contacts(
      list: list,
      selectedIdList: selectedIdList,
      permissionDenied: permissionDenied,
    );
  }

  String getVcardList() {
    return list.map((e) => e.toVCard()).join('\n');
  }
}
