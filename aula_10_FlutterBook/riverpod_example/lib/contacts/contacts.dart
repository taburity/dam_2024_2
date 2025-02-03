import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "contacts_list.dart";
import "contacts_entry.dart";
import "contacts_model_provider.dart";

/// Tela de contatos
class Contacts extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsModel = ref.watch(contactsModelNotifierProvider);

    return IndexedStack(
        index: contactsModel.stackIndex,
        children: [
          ContactsList(),
          ContactsEntry()
        ]
    );
  }
}