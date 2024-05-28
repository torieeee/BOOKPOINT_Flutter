import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}
enum FilterStatus{upcoming, complete,cancel}

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status=FilterStatus.upcoming;//initial status
  Alignment _alignment=Alignment.centerLeft;
  List<dynamic> schedules=[{
    "doctor_name":"Victoria Mwaura",
    "doctor_profile":"icons/doctor_picture.jpg",
    "category":"Dental",
    "status":"upcoming",
  },
  {
    "doctor_name":"Victor Mwaura",
    "doctor_profile":"icons/doctor_picture.jpg",
    "category":"Dental",
    "status":"upcoming",
  },
  {
    "doctor_name":"Vanessa Mdee",
    "doctor_profile":"icons/doctor_picture.jpg",
    "category":"Dental",
    "status":"upcoming",
  },
  {
    "doctor_name":"Matthew Karani",
    "doctor_profile":"icons/doctor_picture.jpg",
    "category":"Dental",
    "status":"cancel",
  }
  ];
  @override
  Widget build(BuildContext context) {
    //in this appointment page. It has 3 states
    //upcoming, complete and cancelled
    //3 status tabs
    List<dynamic> filteredSchedule=schedules.where((var schedule){
      switch(schedule['status']){
        case 'upcoming':
        schedule['status']=FilterStatus.upcoming;
        break;
        case 'complete':
        schedule['status']=FilterStatus.complete;
        case 'cancel':
        schedule['Status']=FilterStatus.cancel;
        break;
      }return schedule['status']
    }).toList();

    return SafeArea(
     child: Padding(
      padding: const EdgeInsects.only(left)
     ),



    );
  }
}