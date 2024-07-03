//import 'package:book_point/components/appointments_card.dart';
import 'package:book_point/doctor_section/prescription.dart';
//import 'package:book_point/utils/config.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


/*class RequestsCard extends StatelessWidget {
  final Map<String,dynamic> doctor;
  final Map<String,dynamic> patient;
  const RequestsCard({super.key, required this.doctor, required this.patient});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> doctor;
    final Map<String,dynamic> patient;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return  Column(
      children:[
        Container(
          child:Column(
            children: [
              Config.spaceSmall,
              ScheduleCard(appointment: this.doctor['requests']
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Cancel',
                        style:TextStyle(color:Colors.white)
                      ) ,
                      onPressed: (){},

                      ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: (){},
                      ),
                  ),
                ],)

            ],)
        ),
          Container(
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.25),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8.0),
            ),
          ),
        ),
        Container(
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8.0),
            ),
          ),
        ),

      ]
    );
  }
}
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.appointment}) : super(key: key);
  final Map<String, dynamic> appointment;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> patient = {};
    Map<String, dynamic> doctor = {};
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '${appointment['day']}, ${appointment['date']}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            appointment['time'],
            style: const TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }
}*/
class RequestsCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final Map<String, dynamic> patient;
   final VoidCallback? onCompleted;

  const RequestsCard({
    super.key,
    required this.doctor,
    required this.patient,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    //final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScheduleCard(appointment: doctor['requests']),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _cancelAppointment(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        _markAsCompleted(context);
                      },
                      child: const Text(
                        'Completed',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.25),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8.0),
            ),
          ),
        ),
        Container(
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
  void _markAsCompleted(BuildContext context) {
    // Assuming you have the appointment ID and status change functionality
    String appointmentId = ''; // Replace with your appointment ID logic
    _updateAppointmentStatus(appointmentId, 'completed');

    // Navigate to PrescriptionForm with necessary data
    if (onCompleted != null) {
      onCompleted!();
    }
  }
  void _cancelAppointment(BuildContext context) {
    // Assuming you have the appointment ID and status change functionality
    String appointmentId = ''; // Replace with your appointment ID logic
    _updateAppointmentStatus(appointmentId, 'cancelled');
  }
  Future<void> _updateAppointmentStatus(String id, String status) async {
    await FirebaseFirestore.instance.collection('appointments').doc(id).update({'status': status});
   //_fetchAppointments();
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.appointment});

  final Map<String, dynamic> appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(width: 5),
          Text(
            '${appointment['day']}, ${appointment['date']}',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 20),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              appointment['time'],
              style:const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}