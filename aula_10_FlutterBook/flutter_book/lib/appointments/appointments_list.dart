import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';
import "package:intl/intl.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:provider/provider.dart";
import "appointments_dbworker.dart";
import "appointments_model.dart";

/// Sub-tela de listagem de compromissos
class AppointmentsList extends StatelessWidget {
  Widget build(BuildContext context) {
    print("## AppointmentsList.build()");
    AppointmentsModel model = Provider.of<AppointmentsModel>(context, listen: false);

    EventList<Event> _markedDateMap = EventList(events: {});
    for (int i = 0; i < model.entityList.length; i++) {
      Appointment appointment = model.entityList[i];
      List dateParts = appointment.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
        apptDate, Event(date : apptDate,
          icon : Container(decoration : BoxDecoration(color : Colors.blue)))
      );
    }

    return Consumer<AppointmentsModel>(
        builder: (context, model, child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                model.entityBeingEdited = Appointment(
                    title: '',
                    description: '',
                    apptDate: ''
                );
                DateTime now = DateTime.now();
                model.entityBeingEdited.apptDate = "${now.year},${now.month},${now.day}";
                model.setChosenDate(DateFormat.yMMMMd("en_US").format(now.toLocal()));
                model.setApptTime('');
                model.setStackIndex(1);
              },
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: CalendarCarousel<Event>(
                        thisMonthDayBorderColor: Colors.grey,
                        daysHaveCircularBorder: false,
                        markedDatesMap: _markedDateMap,
                        onDayPressed: (DateTime inDate, List<Event> inEvents) {
                          _showAppointments(inDate, context);
                        }),
                  ),
                ),
              ],
            ),
        );
      }
    );
  }

  /// Show a bottom sheet to see the appointments for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showAppointments(DateTime inDate, BuildContext inContext) async {
    AppointmentsModel model = Provider.of<AppointmentsModel>(inContext);

    print(
      "## AppointmentsList._showAppointments(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})"
    );
    print("## AppointmentsList._showAppointments(): appointmentsModel.entityList.length = "
        "${model.entityList.length}");
    print("## AppointmentsList._showAppointments(): appointmentsModel.entityList = "
        "${model.entityList}");

    showModalBottomSheet(
      context : inContext,
      builder : (BuildContext context) {
            return Scaffold(
              body : Container(
                child : Padding(
                  padding : EdgeInsets.all(10),
                  child : GestureDetector(
                    child : Column(
                      children : [
                        Text(
                          DateFormat.yMMMMd("en_US").format(inDate.toLocal()),
                          textAlign : TextAlign.center,
                          style : TextStyle(color : Theme.of(context).colorScheme.primary, fontSize : 24)
                        ),
                        Divider(),
                        Expanded(
                          child : ListView.builder(
                            itemCount : model.entityList.length,
                            itemBuilder : (BuildContext inBuildContext, int inIndex) {
                              Appointment appointment = model.entityList[inIndex];
                              print("## AppointmentsList._showAppointments().ListView.builder(): "
                                "appointment = $appointment");
                              if (appointment.apptDate != "${inDate.year},${inDate.month},${inDate.day}") {
                                return Container(height : 0);
                              }
                              print("## AppointmentsList._showAppointments().ListView.builder(): "
                                "INCLUDING appointment = $appointment");
                              String apptTime = "";
                              if (appointment.apptTime != null) {
                                List timeParts = appointment.apptTime!.split(",");
                                TimeOfDay at = TimeOfDay(
                                  hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
                                );
                                apptTime = " (${at.format(context)})";
                              }
                              return Slidable(
                                key: ValueKey(appointment.id),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  extentRatio: 0.25,
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) => _deleteAppointment(inBuildContext, appointment, model),
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  color: Colors.grey.shade300,
                                  child: ListTile(
                                    title: Text("${appointment.title}$apptTime"),
                                    subtitle: Text(appointment.description),
                                    onTap: () async {
                                      _editAppointment(context, appointment, model);
                                    },
                                  ),
                                ),
                              );
                            }
                          )
                        )
                      ]
                    )
                  )
                )
              )
            );
          }
        );
  }

  /// Handle taps on an appointment to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inAppointment The Appointment being edited.
  void _editAppointment(BuildContext inContext, Appointment inAppointment, AppointmentsModel inModel) async {
    print("## AppointmentsList._editAppointment(): inAppointment = $inAppointment");
    inModel.entityBeingEdited = await AppointmentsDBWorker.db.get(inAppointment.id!);
    if (inModel.entityBeingEdited.apptDate == null) {
      inModel.setChosenDate('');
    } else {
      List dateParts = inModel.entityBeingEdited.apptDate.split(",");
      DateTime apptDate = DateTime(
        int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])
      );
      inModel.setChosenDate(
        DateFormat.yMMMMd("en_US").format(apptDate.toLocal())
      );
    }
    if (inModel.entityBeingEdited.apptTime == null) {
      inModel.setApptTime('');
    } else {
      List timeParts = inModel.entityBeingEdited.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(
        hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
      );
      inModel.setApptTime(apptTime.format(inContext));
    }
    inModel.setStackIndex(1);
    Navigator.pop(inContext);
  }

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inAppointment The appointment (potentially) being deleted.
  /// @return               Future.
  Future _deleteAppointment(BuildContext inContext, Appointment inAppointment, AppointmentsModel inModel) async {
    print("## AppointmentsList._deleteAppointment(): inAppointment = $inAppointment");
    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete Appointment"),
          content : Text("Are you sure you want to delete ${inAppointment.title}?"),
          actions : [
            ElevatedButton(child : Text("Cancel"),
              onPressed: () {
                //Apenas omite a janela
                Navigator.of(inAlertContext).pop();
              }
            ),
            ElevatedButton(child : Text("Delete"),
              onPressed : () async {
                // Remove da base de dados, omite a caixa de diálogo, exibe mensagem informando a remoção e recarrega a listagem
                await AppointmentsDBWorker.db.delete(inAppointment.id!);
                Navigator.of(inAlertContext).pop();
                ScaffoldMessenger.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("Appointment deleted")
                  )
                );
                // Atualiza a listagem de compromissos
                inModel.loadData("appointments", AppointmentsDBWorker.db);
              }
            )
          ]
        );
      }
    );
  }


}
