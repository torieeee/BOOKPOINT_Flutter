import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/config.dart';

class RequestDoctor extends StatefulWidget {
  const RequestDoctor({super.key});

  @override
  State<RequestDoctor> createState() => _RequestDoctorState();
}
enum FilterStatus{
      Pending,
      Approved,
      Completed,
      }

class _RequestDoctorState extends State<RequestDoctor> {
  FilterStatus status = FilterStatus.Pending;
  Alignment _alignment=Alignment.centerLeft;
  //Alignment _alignmentR = Alignment.centerRight;
  List<Map<String, dynamic>> schedules = [];
  bool isLoading = true;
  

Future<String?> getDoctorIdByName(String doctorName) async {
  try {
    final QuerySnapshot doctorSnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .where('name', isEqualTo: doctorName)
        .get();
    if (doctorSnapshot.docs.isNotEmpty) {
    
      return doctorSnapshot.docs.first.id;
    } else {
      return null; // No matching doctor found
    }
  } catch (e) {
    print(e);
    return null; // Error occurred
  }
}


 /* Future<void> getAppointments() async {
    setState(() {
      isLoading = true;
    });
/*
try {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Assuming you have a way to get the doctor's name using the user's ID
      // This could be from the user's profile or another method
      final String? doctorName = await getDoctorNameByUserId(user.uid);
      if (doctorName != null) {
        final String? doctorId = await getDoctorIdByName(doctorName);
        if (doctorId != null) {
          final QuerySnapshot appointmentSnapshot = await FirebaseFirestore.instance
              .collection('appointments')
              .where('doc_id', isEqualTo: doctorId)
              .get();
          schedules = appointmentSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        } else {
          print("Doctor not found");
        }
      } else {
        print("Doctor name not found");
      }
    }
  } catch (e) {
    print(e);
  } finally {setState(() {
      isLoading = false;
    }
    );
  
    }*/
     try {
      // Step 1: Get Current User ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Step 2: Get Doctor's Name
      // This step assumes there's a 'users' collection with a document for each user
      // that includes the doctor's name or ID. Adjust according to your database structure.
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      final doctorName = userDoc.data()?['name'];
      if (doctorName == null) {
        throw Exception("Doctor name not found for user");
      }

      // Step 3: Get Doctor's ID
      final doctorId = await getDoctorIdByName(doctorName);
      if (doctorId == null) {
        throw Exception("Doctor not found");
      }
      final appointmentsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doc_id', isEqualTo: doctorId)
          .get();

      final appointments = appointmentsSnapshot.docs
          .map((doc) => doc.data())
          .toList();

      setState(() {
        schedules = appointments;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
    

  }*/

  Future<List<Map<String, dynamic>>> fetchAppointmentsForUserDoctor(String userId) async {
  try {
    // Step 1: Fetch Doctor's Name from User's Document
    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if (!userDoc.exists) {
      print("User document does not exist.");
      return [];
    }
    final doctorName = userDoc.data()?['name'];
    if (doctorName == null) {
      print("Doctor name not found in user's document.");
      return [];
    }else{
      print(doctorName);
    }

    // Step 2: Find Doctor's ID Using Doctor's Name
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Doctors')
        .where('doc_name', isEqualTo: doctorName)
        .get();
    if (querySnapshot.docs.isEmpty) {
      print("Doctor not found.");
      return [];
    }
    final doctorId = querySnapshot.docs.first.id; // Assuming unique doctor names

    // Step 3: Fetch Appointments for the Doctor
    final appointmentsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doc_name', isEqualTo: doctorName)
        .get();

      print("Running...");
    return appointmentsSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print("Error fetching appointments: $e");
    return [];
  }
}

  Future<String?> getDoctorNameByUserId(String userId) async {
    try {
    
    final DocumentSnapshot userDoc = await FirebaseFirestore
    .instance
    .collection('Users')
    .doc(userId)
    .get();
    if (userDoc.exists) {
      // Assuming the user's document contains a 'name' field
      return userDoc['name'];
    } else {
      print("User document does not exist.");
      return null;
    }
  } catch (e) {
    print("Error fetching user name: $e");
    return null;
  }
  
}
void updateAlignment(FilterStatus status) {
  setState(() {
    switch (status) {
      case FilterStatus.Pending:
        _alignment = Alignment.centerLeft;
        break;
      case FilterStatus.Approved:
        _alignment = Alignment.center;
        break;
      case FilterStatus.Completed:
        _alignment = Alignment.centerRight;
        break;
    }
  });
}

@override
  void initState() {
    super.initState();
    //getDoctorIdByName(doctorName);
    fetchAppointmentsForUserDoctor(FirebaseAuth.instance.currentUser!.uid);
    updateAlignment( FilterStatus.Pending);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredSchedules = schedules.where((schedule) {
      String statusStr = schedule['status'] as String? ?? 'pending';
      FilterStatus scheduleStatus;
      switch (statusStr) {
        case 'pending':
          scheduleStatus = FilterStatus.Pending;
          break;
        case 'approved':
          scheduleStatus = FilterStatus.Approved;
          break;
        case 'complete':
          scheduleStatus = FilterStatus.Completed;
          break;

        default:
          scheduleStatus = FilterStatus.Approved;
      }
      return scheduleStatus == status;
    }).toList();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Appointment Schedule',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //this is the filter tabs
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                status = filterStatus;
                                _alignment = _getAlignment(filterStatus);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Align(
                                alignment: _getTextAlignment(filterStatus),
                                child: Text(
                                  filterStatus.name,
                                  style: TextStyle(
                                    color: status == filterStatus
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: status == filterStatus
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Config.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Config.spaceSmall,
            Config.spaceSmall,
            Config.spaceSmall,
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredSchedules.isEmpty
                      ? const Center(child: Text('No appointments found'))
                      : ListView.builder(
                          itemCount: filteredSchedules.length,
                          itemBuilder: ((context, index) {
                            var schedule = filteredSchedules[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      schedule['doc_name'] ?? 'No name',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(schedule['status'] ?? 'No category'),
                                    const SizedBox(height: 15),
                                    ScheduleCard(
                                      date: _formatTimestamp(schedule['date']),
                                      day: _getDayFromTimestamp(
                                          schedule['date']),
                                      time: _getTimeFromTimestamp(
                                          schedule['date']),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Config.primaryColor),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Config.primaryColor,
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              'Reschedule',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
Alignment _getAlignment(FilterStatus filterStatus) {
  switch (filterStatus) {
    case FilterStatus.Pending:
      return Alignment.centerLeft;
    case FilterStatus.Approved:
      return Alignment.center;
    case FilterStatus.Completed:
      return Alignment.centerRight;
    
  }
}
Alignment _getTextAlignment(FilterStatus filterStatus) {
  switch (filterStatus) {
    case FilterStatus.Pending:
      return Alignment.centerLeft;
    case FilterStatus.Approved:
      return Alignment.center;
    case FilterStatus.Completed:
      return Alignment.center;
    default:  
    return Alignment.centerLeft;
  }
  
}


String _formatTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return DateFormat('yyyy-MM-dd').format(timestamp.toDate());
  }
  return 'Invalid Date';
}
String _getTimeFromTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return DateFormat('h:mm a').format(timestamp.toDate());
  }
  return 'Invalid Time';
}
String _getDayFromTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return DateFormat('EEEE').format(timestamp.toDate());
  }
  return 'Invalid Day';
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      {Key? key, required this.date, required this.day, required this.time})
      : super(key: key);
  final String date;
  final String day;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Config.primaryColor,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$day, $date',
            style: const TextStyle(
              color: Config.primaryColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Config.primaryColor,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            time,
            style: const TextStyle(
              color: Config.primaryColor,
            ),
          ))
        ],
      ),
    );
  }
}
