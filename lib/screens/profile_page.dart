/*import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../main.dart";
//import "../providers/dio_provider.dart";
import "../utils/config.dart";

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: Config.primaryColor,
            child: const  Column(
              children: const <Widget>[
                SizedBox(
                  height: 110,
                ),
                CircleAvatar(
                  radius: 65.0,
                  backgroundImage: AssetImage('assets/profile1.jpg'),
                  backgroundColor: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Amanda Tan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '23 Years Old | Female',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.grey[200],
            child: Center(
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                child: Container(
                  width: 300,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.blueAccent[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Profile",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Config.spaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.history,
                              color: Colors.yellowAccent[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "History",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Config.spaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: Colors.lightGreen[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              onPressed: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('token') ?? '';

                                if (token.isNotEmpty && token != '') {
                                  //logout here
                                  final response =
                                      await DioProvider().logout(token);

                                  if (response == 200) {
                                    //if successfully delete access token
                                    //then delete token saved at Shared Preference as well
                                    await prefs.remove('token');
                                    setState(() {
                                      //redirect to login page
                                      MyApp.navigatorKey.currentState!
                                          .pushReplacementNamed('/');
                                    });
                                  }
                                }
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/config.dart';
import 'package:intl/intl.dart'; 

class ProfilePage extends StatefulWidget {

  final String userId;
  final String name;
  final DateTime dob;
  final String gender;
  final String email;
  final String userType;

  ProfilePage({
     Key? key,
    required this.userId,
    required this.name,
    required this.dob,
    required this.gender,
    required this.email,
    required this.userType,
  }): super(key: key);
 // ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  String _userType = 'Patient'; // Default user type

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          DateTime dob = DateFormat('MM/dd/yyyy').parse(_dobController.text); // Parsing the date

          Map<String, dynamic> userData = {
            'name': _nameController.text,
            'DOB': dob,
            'gender': _genderController.text,
            'email': _emailController.text,
            'userType': _userType,
          };

          await _firestore.collection('Users').doc(user.uid).set(userData);

          if (_userType == 'Doctor') {
            await _firestore.collection('Doctors').doc(user.uid).set(userData);
          } else if (_userType == 'Patient') {
            await _firestore.collection('Patients').doc(user.uid).set(userData);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile saved successfully')),
          );
        }
      } catch (e) {
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile')),
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
            const SizedBox(height: 20),
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
