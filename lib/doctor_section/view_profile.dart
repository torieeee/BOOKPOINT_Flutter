import 'package:flutter/material.dart';

class ViewDoctorProfile extends StatelessWidget {
  final String userId;
  final String name;
  final DateTime dob;
  final String gender;
  final String email;
  final String userType;
  final DateTime yoc;
  final String category;
  final String location;

  const ViewDoctorProfile({
    Key? key,
    required this.userId,
    required this.name,
    required this.dob,
    required this.gender,
    required this.email,
    required this.userType,
    required this.yoc,
    required this.category,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: const TextStyle(fontSize: 18)),
            Text('DOB: ${dob.toLocal()}'.split(' ')[0], style: const TextStyle(fontSize: 18)),
            Text('Gender: $gender', style: const TextStyle(fontSize: 18)),
            Text('Email: $email', style: const TextStyle(fontSize: 18)),
            Text('User Type: $userType', style: const TextStyle(fontSize: 18)),
            Text('Years of Experience: ${_calculateExperience()}', style: const TextStyle(fontSize: 18)),
            Text('Category: $category', style: const TextStyle(fontSize: 18)),
            Text('Location: $location', style: const TextStyle(fontSize: 18)),
            Text('Age: ${_calculateAge()}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  String _calculateAge() {
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age.toString();
  }

  String _calculateExperience() {
    DateTime now = DateTime.now();
    int experience = now.year - yoc.year;
    if (now.month < yoc.month || (now.month == yoc.month && now.day < yoc.day)) {
      experience--;
    }
    return experience.toString();
  }
}
