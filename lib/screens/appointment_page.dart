import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/config.dart';
import 'invoice_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { Upcoming, Approved, Complete, Paid }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<Map<String, dynamic>> schedules = [];
  bool isLoading = true;

  Future<void> getAppointments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final QuerySnapshot appointmentSnapshot = await FirebaseFirestore
            .instance
            .collection('appointments')
            .where('patient_id', isEqualTo: user.uid)
            .get();

        setState(() {
          schedules = appointmentSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          schedules = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      setState(() {
        schedules = [];
        isLoading = false;
      });
    }
  }

  Future<void> _cancelAppointment(String bookingId) async {
    try {
      // Show a confirmation dialog
      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Cancel Appointment"),
            content:
                const Text("Are you sure you want to cancel this appointment?"),
            actions: <Widget>[
              TextButton(
                child: const Text("No"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text("Yes"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        // Delete the appointment from Firestore
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(bookingId)
            .delete();

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment cancelled successfully')),
        );

        // Refresh the appointments list
        await getAppointments();
      }
    } catch (e) {
      print('Error cancelling appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to cancel appointment. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredSchedules = schedules.where((schedule) {
      String statusStr = schedule['status'] as String? ?? 'Pending';
      FilterStatus scheduleStatus;
      switch (statusStr) {
        case 'Pending':
          scheduleStatus = FilterStatus.Upcoming;
          break;
        case 'Approved':
          scheduleStatus = FilterStatus.Approved;
          break;
        case 'Complete':
          scheduleStatus = FilterStatus.Complete;
          break;
        case 'Paid':
          scheduleStatus = FilterStatus.Complete;
          break;
        default:
          scheduleStatus = FilterStatus.Upcoming;
      }
      return scheduleStatus == status;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Schedule'),
        backgroundColor: Config.primaryColor,
      ),
      body: SafeArea(
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
                      width: MediaQuery.of(context).size.width / 4 -
                          20, // Subtracting 20 for padding
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
                                        date:
                                            _formatTimestamp(schedule['date']),
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
                                          if (schedule['status'] == 'Pending')
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () =>
                                                    _cancelAppointment(
                                                        schedule['booking_id']),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color:
                                                          Config.primaryColor),
                                                ),
                                              ),
                                            ),
                                          if (schedule['status'] == 'Pending')
                                            const SizedBox(width: 20),
                                          Expanded(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    _getButtonColor(
                                                        schedule['status']),
                                              ),
                                              onPressed: () {
                                                if (schedule['status'] ==
                                                    'Pending') {
                                                  // Implement reschedule functionality
                                                } else if (schedule['status'] ==
                                                    'Complete') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          InvoicePage(
                                                              bookingId: schedule[
                                                                  'booking_id']),
                                                    ),
                                                  );
                                                }
                                                // No action for 'Approved' status
                                              },
                                              child: Text(
                                                _getButtonText(
                                                    schedule['status']),
                                                style: TextStyle(
                                                  color: schedule['status'] ==
                                                          'Approved'
                                                      ? Colors.black54
                                                      : Colors.white,
                                                ),
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
      ),
    );
  }
}

String _getButtonText(String status) {
  switch (status) {
    case 'Pending':
      return 'Reschedule';
    case 'Approved':
      return 'Waiting for Diagnosis';
    case 'Complete':
      return 'Invoice';
    default:
      return '';
  }
}

Color _getButtonColor(String status) {
  switch (status) {
    case 'Pending':
      return Config.primaryColor;
    case 'Approved':
      return Colors.grey;
    case 'Complete':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Alignment _getAlignment(FilterStatus filterStatus) {
  switch (filterStatus) {
    case FilterStatus.Upcoming:
      return Alignment.centerLeft;
    case FilterStatus.Approved:
      return Alignment(-0.33, 0.0);
    case FilterStatus.Complete:
      return Alignment(0.33, 0.0);
    case FilterStatus.Paid:
      return Alignment.centerRight;
  }
}

Alignment _getTextAlignment(FilterStatus filterStatus) {
  return Alignment.center; // Center all text within each tab
}

String _formatTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return DateFormat('yyyy-MM-dd').format(timestamp.toDate());
  }
  return 'Invalid Date';
}

String _getDayFromTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return DateFormat('EEEE').format(timestamp.toDate());
  }
  return 'Invalid Day';
}

String _getTimeFromTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return DateFormat('h:mm a').format(timestamp.toDate());
  }
  return 'Invalid Time';
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
