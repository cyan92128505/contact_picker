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
  ContactsNotifier() : super(Contacts(list: [], permissionDenied: false));

  void setPermissionDenied() {
    final contacts = Contacts.copy(
      list: state.list,
      permissionDenied: true,
    );
    state = contacts;
  }

  void addContact(Contact contact) {
    final contacts = Contacts.copy(
      list: state.list,
      permissionDenied: state.permissionDenied,
    );
    contacts.list.add(contact);
    state = contacts;
  }

  void resetList(List<Contact> contactList) {
    final contacts = Contacts.copy(
      list: contactList,
      permissionDenied: state.permissionDenied,
    );
    state = contacts;
  }
}

class Contacts {
  List<Contact> list;
  bool permissionDenied;

  Contacts({
    required this.list,
    required this.permissionDenied,
  });

  factory Contacts.copy({
    required list,
    required permissionDenied,
  }) {
    return Contacts(
      list: list,
      permissionDenied: permissionDenied,
    );
  }
}
