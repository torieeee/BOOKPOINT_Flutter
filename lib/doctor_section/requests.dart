import 'package:book_point/doctor_section/diagnosis_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/invoice_page.dart';
import '../utils/config.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

enum FilterStatus { Upcoming, Approved, Complete, Paid }

class _RequestPageState extends State<RequestPage> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<Map<String, dynamic>> schedules = [];
  bool isLoading = true;

  Future<void> getRequests() async {
    setState(() {
      isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
            .collection('Requests')
            .where('doc_id', isEqualTo: user.uid)
            .get();

        setState(() {
          schedules = requestSnapshot.docs
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
      print('Error fetching requests: $e');
      setState(() {
        schedules = [];
        isLoading = false;
      });
    }
  }

  Future<void> approveRequest(String bookingId) async {
    try {
      // Update the Requests collection
      await FirebaseFirestore.instance
          .collection('Requests')
          .where('booking_id', isEqualTo: bookingId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'status': 'Approved'});
        }
      });

      // Update the appointments collection
      await FirebaseFirestore.instance
          .collection('appointments')
          .where('booking_id', isEqualTo: bookingId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'status': 'Approved'});
        }
      });

      // Refresh the requests list
      await getRequests();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request approved successfully')),
      );
    } catch (e) {
      print('Error approving request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to approve request')),
      );
    }
  }

  Future<void> approvePayment(String bookingId) async {
    try {
      // Update the Requests collection
      await FirebaseFirestore.instance
          .collection('Requests')
          .where('booking_id', isEqualTo: bookingId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'status': 'Paid'});
        }
      });

      // Update the appointments collection
      await FirebaseFirestore.instance
          .collection('appointments')
          .where('booking_id', isEqualTo: bookingId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'status': 'Paid'});
        }
      });

      // Refresh the requests list
      await getRequests();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment approved successfully')),
      );
    } catch (e) {
      print('Error approving payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to approve payement')),
      );
    }
  }
// Then, modify the Approve button in the ListView.builder:

  @override
  void initState() {
    super.initState();
    getRequests();
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
          scheduleStatus = FilterStatus.Paid;
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
                'Request Schedule',
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                        ? const Center(child: Text('No requests found'))
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
                                        schedule['patient_name'] ?? 'No name',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                          'Status: ${schedule['status'] ?? 'No category'}'),
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
                                          Expanded(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: schedule[
                                                            'status'] ==
                                                        'Approved'
                                                    ? Colors.green
                                                    : schedule['status'] ==
                                                            'Complete'
                                                        ? Colors.blue
                                                        : schedule['status'] ==
                                                                'Paid'
                                                            ? Colors.grey
                                                            : Config
                                                                .primaryColor,
                                              ),
                                              onPressed: () {
                                                if (schedule['status'] ==
                                                    'Approved') {
                                                  // Navigate to diagnosis page
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DiagnosisPage(
                                                        patientId: schedule[
                                                            'patient_id'],
                                                        doctorId:
                                                            schedule['doc_id'],
                                                        bookingId: schedule[
                                                            'booking_id'],
                                                      ),
                                                    ),
                                                  );
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
                                                } else if (schedule['status'] ==
                                                    'Paid') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          InvoicePage(
                                                              bookingId: schedule[
                                                                  'booking_id']),
                                                    ),
                                                  );
                                                } else {
                                                  approveRequest(
                                                      schedule['booking_id']);
                                                }
                                              },
                                              child: Text(
                                                schedule['status'] == 'Approved'
                                                    ? 'Diagnose'
                                                    : schedule['status'] ==
                                                            'Complete'
                                                        ? 'View Invoice'
                                                        : schedule['status'] ==
                                                                'Paid'
                                                            ? 'Paid Invoice'
                                                            : 'Approve',
                                                style: TextStyle(
                                                  color: schedule['status'] ==
                                                          'Paid'
                                                      ? Colors.black54
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (schedule['status'] ==
                                              'Complete') ...[
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                                onPressed: () {
                                                  approvePayment(
                                                      schedule['booking_id']);
                                                },
                                                child: Text(
                                                  'Approve Payment',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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

// Alignment _getTextAlignment(FilterStatus filterStatus) {
//   switch (filterStatus) {
//     case FilterStatus.Upcoming:
//       return Alignment.topLeft;
//     case FilterStatus.Approved:
//       return Alignment.centerLeft;
//     case FilterStatus.Complete:
//       return Alignment.centerRight;
//     case FilterStatus.Paid:
//       return Alignment.topRight;
//   }
// }

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
