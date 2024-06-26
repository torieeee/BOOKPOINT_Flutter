/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:book_point/providers/dio_provider.dart';
import 'package:book_point/utils/config.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  final Map<String, dynamic> doctor;
  //final Color color;

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  late List<Map<String, dynamic>> _requests = [];
  late List<Map<String, dynamic>> _upcoming = [];
  late List<Map<String, dynamic>> _completed = [];
  late List<Map<String, dynamic>> _canceled = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String doctorName = widget.doctor['name'];

      // Fetch appointments for different statuses
      QuerySnapshot<Map<String, dynamic>> requestsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_name', isEqualTo: doctorName)
          .where('status', isEqualTo: 'requested')
          .get();

      QuerySnapshot<Map<String, dynamic>> upcomingSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_name', isEqualTo: doctorName)
          .where('status', isEqualTo: 'approved')
          .get();

      QuerySnapshot<Map<String, dynamic>> completedSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_name', isEqualTo: doctorName)
          .where('status', isEqualTo: 'completed')
          .get();

      QuerySnapshot<Map<String, dynamic>> canceledSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_name', isEqualTo: doctorName)
          .where('status', isEqualTo: 'canceled')
          .get();

      setState(() {
        _requests = requestsSnapshot.docs.map((doc) => doc.data()).toList();
        _upcoming = upcomingSnapshot.docs.map((doc) => doc.data()).toList();
        _completed = completedSnapshot.docs.map((doc) => doc.data()).toList();
        _canceled = canceledSnapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }

  Future<void> _updateAppointmentStatus(String id, String status) async {
    await FirebaseFirestore.instance.collection('appointments').doc(id).update({'status': status});
    _fetchAppointments(); // Refresh the list after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Requests'),
          ..._buildAppointmentList(_requests, 'Approve', 'approved'),

          _buildSectionHeader('Upcoming'),
          ..._buildAppointmentList(_upcoming, 'Complete', 'completed', 'Cancel', 'canceled'),

          _buildSectionHeader('Completed'),
          ..._buildAppointmentList(_completed),

          _buildSectionHeader('Canceled'),
          ..._buildAppointmentList(_canceled),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> _buildAppointmentList(
    List<Map<String, dynamic>> appointments,
    [String primaryButtonText = '',
    String primaryButtonStatus = '',
    String secondaryButtonText = '',
    String secondaryButtonStatus = '']
  ) {
    return appointments.map((appointment) {
      return RequestsCard(
        appointment: appointment,
        primaryButtonText: primaryButtonText,
        primaryButtonStatus: primaryButtonStatus,
        secondaryButtonText: secondaryButtonText,
        secondaryButtonStatus: secondaryButtonStatus,
        onStatusChange: _updateAppointmentStatus,
      );
    }).toList();
  }
}

class RequestsCard extends StatelessWidget {
  const RequestsCard({
    Key? key,
    required this.appointment,
    required this.primaryButtonText,
    required this.primaryButtonStatus,
    required this.secondaryButtonText,
    required this.secondaryButtonStatus,
    required this.onStatusChange,
  }) : super(key: key);

  final Map<String, dynamic> appointment;
  final String primaryButtonText;
  final String primaryButtonStatus;
  final String secondaryButtonText;
  final String secondaryButtonStatus;
  final Function(String id, String status) onStatusChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(appointment['patient_image_url']),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patient: ${appointment['patient_name']}', style: const TextStyle(fontSize: 16)),
                    Text('Category: ${appointment['category']}', style: const TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 15),
                const SizedBox(width: 5),
                Text('${appointment['date']}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 20),
                const Icon(Icons.access_alarm, color: Colors.grey, size: 15),
                const SizedBox(width: 5),
                Text('${appointment['time']}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            if (primaryButtonText.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () => onStatusChange(appointment['id'], primaryButtonStatus),
                child: Text(primaryButtonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor:Config.primaryColor),
              ),
            ],
            if (secondaryButtonText.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () => onStatusChange(appointment['id'], secondaryButtonStatus),
                child: Text(secondaryButtonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_point/utils/config.dart'; 
import '../shared/theme/widgets/cards/requests_card.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  final Map<String, dynamic> doctor;

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  late List<Map<String, dynamic>> _requests = [];
  late List<Map<String, dynamic>> _upcoming = [];
  late List<Map<String, dynamic>> _completed = [];
  late List<Map<String, dynamic>> _canceled = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String doctorName = widget.doctor['name'];

      // Fetch appointments for different statuses
      QuerySnapshot<Map<String, dynamic>> requestsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_name', isEqualTo: doctorName)
          .where('status', isEqualTo: 'requested')
          .get();

      QuerySnapshot<Map<String, dynamic>> upcomingSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_name', isEqualTo: doctorName)
          .where('status', isEqualTo: 'approved')
          .get();

      QuerySnapshot<Map<String, dynamic>> completedSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_name', isEqualTo: doctorName)
          .where('status', isEqualTo: 'completed')
          .get();

      QuerySnapshot<Map<String, dynamic>> canceledSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_name', isEqualTo: doctorName)
          .where('status', isEqualTo: 'canceled')
          .get();

      setState(() {
        _requests = requestsSnapshot.docs.map((doc) => doc.data()).toList();
        _upcoming = upcomingSnapshot.docs.map((doc) => doc.data()).toList();
        _completed = completedSnapshot.docs.map((doc) => doc.data()).toList();
        _canceled = canceledSnapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }

  Future<void> _updateAppointmentStatus(String id, String status) async {
    await FirebaseFirestore.instance.collection('appointments').doc(id).update({'status': status});
    _fetchAppointments(); // Refresh the list after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: DefaultTabController(
        length: 4, // Number of tabs
        child: Column(
          children: <Widget>[
            const TabBar(
              tabs: [
                Tab(text: 'Requests'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Canceled'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAppointmentList(_requests, 'Approve', 'approved'),
                  _buildAppointmentList(_upcoming, 'Complete', 'completed', 'Cancel', 'canceled'),
                  _buildAppointmentList(_completed),
                  _buildAppointmentList(_canceled),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList(
  List<Map<String, dynamic>> appointments,
  [String primaryButtonText = '',
  String primaryButtonStatus = '',
  String secondaryButtonText = '',
  String secondaryButtonStatus = '']
) {
  return ListView(
    children: appointments.map((appointment) {
      return RequestsCard(
         doctor: appointment['doctor'],
        patient: appointment['patient'],
        //appointment: appointment,
        //primaryButtonText: primaryButtonText,
       // primaryButtonStatus: primaryButtonStatus,
        //secondaryButtonText: secondaryButtonText,
        //secondaryButtonStatus: secondaryButtonStatus,
        //onStatusChange: _updateAppointmentStatus,
      );
}).toList(),
  );
}


/*class RequestsCard extends StatelessWidget {
  const RequestsCard({
    Key? key,
    required this.appointment,
    required this.primaryButtonText,
    required this.primaryButtonStatus,
    required this.secondaryButtonText,
    required this.secondaryButtonStatus,
    required this.onStatusChange,
  }) : super(key: key);

  final Map<String, dynamic> appointment;
  final String primaryButtonText;
  final String primaryButtonStatus;
  final String secondaryButtonText;
  final String secondaryButtonStatus;
  final Function(String id, String status) onStatusChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(appointment['patient_image_url']),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patient: ${appointment['patient_name']}', style: const TextStyle(fontSize: 16)),
                    Text('Category: ${appointment['category']}', style: const TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 15),
                const SizedBox(width: 5),
                Text('${appointment['date']}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 20),
                const Icon(Icons.access_alarm, color: Colors.grey, size: 15),
                const SizedBox(width: 5),
                Text('${appointment['time']}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            if (primaryButtonText.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () => onStatusChange(appointment['id'], primaryButtonStatus),
                child: Text(primaryButtonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Config.primaryColor,
                ),
              ),
            ],
            if (secondaryButtonText.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () => onStatusChange(appointment['id'], secondaryButtonStatus),
                child: Text(secondaryButtonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}*/

}