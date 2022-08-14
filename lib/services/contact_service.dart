import 'package:contact_picker/services/file_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../models/contacts.dart';

class ContactService {
  final contacts = StateNotifierProvider<ContactsNotifier, Contacts>(
    (ref) => ContactsNotifier(),
  );

  Future fetchContacts(WidgetRef ref) async {
    var state = ref.read(contacts.notifier);

    if (!await FlutterContacts.requestPermission(readonly: true)) {
      state.setPermissionDenied();
    } else {
      final contactList = await FlutterContacts.getContacts(
        withAccounts: true,
        withGroups: true,
        withPhoto: true,
        withProperties: true,
        withThumbnail: true,
      );
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

  void addContact(Contact contact) async {
    final contacts = Contacts.copy(
      list: state.list,
      selectedIdList: state.selectedIdList,
      permissionDenied: state.permissionDenied,
    );

    await FlutterContacts.insertContact(contact);

    contacts.list.add(contact);
    state = contacts;
  }

  void removeContact(Contact contact) async {
    final contacts = Contacts.copy(
      list: state.list,
      selectedIdList: state.selectedIdList,
      permissionDenied: state.permissionDenied,
    );

    await FlutterContacts.deleteContact(contact);

    contacts.list.remove(contact);
    state = contacts;
  }

  void removeSelectContact(Contact contact) async {
    final contacts = Contacts.copy(
      list: state.list,
      selectedIdList: state.selectedIdList,
      permissionDenied: state.permissionDenied,
    );

    await FlutterContacts.deleteContacts([contact]);

    contacts.list.remove(contact);
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

  sharedVcardList() async {
    final contacts = Contacts.copy(
      list: state.list,
      selectedIdList: state.selectedIdList,
      permissionDenied: state.permissionDenied,
    );

    final result = contacts.getVcardList();
    final fileService = FileService();
    final file = await fileService.writeFile(
      fileName: '${DateTime.now().toIso8601String()}.vcf',
      value: result,
    );

    await Share.shareFiles([file.path]);
  }
}
