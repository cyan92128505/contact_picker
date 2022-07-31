import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pages/main_app.dart';
import 'services/contact_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final contactService = ContactService();

  return runApp(
    ProviderScope(
      child: MainAPP(
        contactService: contactService,
      ),
    ),
  );
}
