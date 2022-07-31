import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContactService {
  final contacts = StateNotifierProvider<ContactsNotifier, Contacts>(
    (ref) => ContactsNotifier(),
  );

  Future fetchContacts(WidgetRef ref) async {
    var state = ref.read(contacts.notifier);

    if (!await FlutterContacts.requestPermission(readonly: true)) {
      state.setPermissionDenied();
    } else {
      final contactList = await FlutterContacts.getContacts();
      state.resetList(contactList);
    }
  }
}

class ContactsNotifier extends StateNotifier<Contacts> {
  ContactsNotifier() : super(Contacts.initail());

  void setPermissionDenied() {
    final contacts = Contacts.copy(
      list: state.list,
      selectedIdList: state.selectedIdList,
      permissionDenied: true,
    );
    state = contacts;
  }

  void addContact(Contact contact) {
    final contacts = Contacts.copy(
      list: state.list,
      selectedIdList: state.selectedIdList,
      permissionDenied: state.permissionDenied,
    );
    contacts.list.add(contact);
    state = contacts;
  }

  void resetList(List<Contact> contactList) {
    final contacts = Contacts.copy(
      list: contactList,
      selectedIdList: state.selectedIdList,
      permissionDenied: state.permissionDenied,
    );
    state = contacts;
  }

  void addSelect(Contact contact) {
    final contacts = Contacts.copy(
      list: state.list,
      selectedIdList: state.selectedIdList,
      permissionDenied: state.permissionDenied,
    );

    if (contacts.selectedIdList.contains(contact.id)) {
      contacts.selectedIdList.remove(contact.id);
    } else {
      contacts.selectedIdList.add(contact.id);
    }

    state = contacts;
  }
}

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
}
