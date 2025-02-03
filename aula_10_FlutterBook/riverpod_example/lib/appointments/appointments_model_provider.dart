import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../base_model_provider.dart';
import 'appointment.dart';
import 'appointments_dbworker.dart';
import 'appointments_model.dart';

part 'appointments_model_provider.g.dart';

@riverpod
class AppointmentsModelNotifier extends BaseModelNotifier<AppointmentsModel> {
  AppointmentsModelNotifier() : super(AppointmentsModel(apptTime: ''));
  //AppointmentsModelNotifier(super.state);

  AppointmentsModel build(){
    var model = AppointmentsModel(apptTime:'');
    loadData("appointments", AppointmentsDBWorker.db);
    return model;
  }

  void setApptTime(String inApptTime) {
    state = state.copyWith(apptTime: inApptTime);
  }

  void editAppointment(Appointment appointment) {
    state = state.copyWith(entityBeingEdited: appointment);
  }

}