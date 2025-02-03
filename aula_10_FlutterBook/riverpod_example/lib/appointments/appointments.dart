import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "appointments_list.dart";
import "appointments_entry.dart";
import "appointments_model_provider.dart";


/// Tela de compromissos
class Appointments extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsModel = ref.watch(appointmentsModelNotifierProvider);

    return IndexedStack(
        index: appointmentsModel.stackIndex,
        children: [
          AppointmentsList(),
          AppointmentsEntry()
        ]
    );
  }
}