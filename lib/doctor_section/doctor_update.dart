import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/config.dart';
import 'package:intl/intl.dart'; 

class DoctorProfilePage extends StatefulWidget {

  final String userId;
  final String name;
  final DateTime dob;
  final String gender;
  final String email;
  final String userType;
  final DateTime yoc;
  final String location;
  final String category;

  DoctorProfilePage({
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
  }): super(key: key);
 // DoctorProfilePage({Key? key}) : super(key: key);

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _categoryController=TextEditingController();
  final _yocController=TextEditingController();
  final _locationController=TextEditingController();
  String _userType = 'Doctor'; // Default user type

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          DateTime dob= DateFormat('MM/dd/yyyy').parse(_dobController.text);
          DateTime yoc=DateFormat('MM/dd/yyyy').parse(_yocController.text);  // Parsing the date

          Map<String, dynamic> userData = {
            'name': _nameController.text,
            'DOB': _dobController.text,
            'gender': _genderController.text,
            'email': _emailController.text,
            'userType': _userType,
            'yoc':_yocController.text,
            'category':_categoryController.text,
            'location':_locationController.text,
          };

          await _firestore.collection('Users').doc(user.uid).set({
            'name': _nameController.text,
            'DOB': dob,
            'gender': _genderController.text,
            'email': _emailController.text,
            'userType': _userType,
          });

          if (_userType == 'Doctor') {
            await _firestore.collection('Doctors').doc(user.uid).set(userData);
          } else if (_userType == 'Patient') {
            await _firestore.collection('Patients').doc(user.uid).set({
            'name': _nameController.text,
            'DOB': dob,
            'gender': _genderController.text,
            'email': _emailController.text,
            'userType': _userType,
          });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully')),
          );
        }
      } catch (e) {
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              cursorColor: Config.primaryColor,
              decoration: const InputDecoration(
                hintText: 'Give your full name',
                labelText: 'Name',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.person_outlined),
                prefixIconColor: Config.primaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            Config.spaceSmall,
            TextFormField(
              controller: _dobController,
              keyboardType: TextInputType.datetime,
              cursorColor: Config.primaryColor,
              decoration: const InputDecoration(
                labelText: 'Date of birth',
                hintText: 'Enter your date of birth (MM/DD/YYYY)',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.calendar_month_outlined),
                prefixIconColor: Config.primaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your date of birth';
                }
                try {
                  DateFormat('MM/dd/yyyy').parse(value);
                } catch (e) {
                  return 'Please enter a valid date (MM/DD/YYYY)';
                }
                return null;
              },
            ),
            Config.spaceSmall,
            TextFormField(
              controller: _genderController,
              keyboardType: TextInputType.text,
              cursorColor: Config.primaryColor,
              decoration: const InputDecoration(
                labelText: 'Gender',
                hintText: 'Gender',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.person_2_outlined),
                prefixIconColor: Config.primaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your gender';
                }
                if (!['Male', 'Female', 'Other'].contains(value)) {
                  return 'Please enter a valid gender (Male, Female, Other)';
                }
                return null;
              },
            ),
            Config.spaceSmall,
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Config.primaryColor,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Email',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.email_outlined),
                prefixIconColor: Config.primaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            Config.spaceSmall,
            DropdownButtonFormField<String>(
              value: _userType,
              decoration: const InputDecoration(
                labelText: 'User Type',
              ),
              items: ['Patient', 'Doctor'].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _userType = newValue!;
                });
              },
            ),
            Config.spaceSmall,
            TextFormField(
              controller: _categoryController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Config.primaryColor,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'Field of work',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.email_outlined),
                prefixIconColor: Config.primaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your category';
                }
                
                return null;
              },
            ),
            Config.spaceSmall,
            TextFormField(
              controller: _yocController,
              keyboardType: TextInputType.datetime,
              cursorColor: Config.primaryColor,
              decoration: const InputDecoration(
                labelText: 'Year of certification',
                hintText: 'Year of graduation',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.calendar_month_outlined),
                prefixIconColor: Config.primaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your date of certification';
                }
                try {
                  DateFormat('MM/dd/yyyy').parse(value);
                } catch (e) {
                  return 'Please enter a valid date (MM/DD/YYYY)';
                }
                return null;
              },
            ),
            //Config.spaceSmall,
            TextFormField(
              controller: _locationController,
              keyboardType: TextInputType.text,
              cursorColor: Config.primaryColor,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Clinic location',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.map_outlined),
                prefixIconColor: Config.primaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your location';
                }
                
                return null;
              },
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
