import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "appointments_dbworker.dart";
import "appointments_list.dart";
import "appointments_entry.dart";
import "appointments_model.dart";


/// Tela de compromissos
class Appointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppointmentsModel>(
        create: (context) {
          AppointmentsModel model = AppointmentsModel(apptTime: '');
          model.loadData("appointments", AppointmentsDBWorker.db);
          return model;
        },
        child: Consumer<AppointmentsModel>(
            builder: (context, inModel, child) {
              return IndexedStack(
                  index: inModel.stackIndex,
                  children: [
                    AppointmentsList(),
                    AppointmentsEntry()
                  ]
              );
            }
        )
    );
  }
}
