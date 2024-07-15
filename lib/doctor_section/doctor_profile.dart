import 'package:book_point/doctor_section/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../utils/config.dart';
import 'doctor_update.dart';
import 'package:book_point/main.dart';

import 'update_doctor_profile.dart';

class DoctorUserPage extends StatefulWidget {
  @override
  _DoctorUserPageState createState() => _DoctorUserPageState();
}

class _DoctorUserPageState extends State<DoctorUserPage> {
  late String _userId;
  late String _name;
  late DateTime _dob;
  late String _gender;
  late String _email;
  late String _userType;
  late String _genderType;
  late DateTime _yoc;
  late String _category;
  late String _location;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> _userTypes = ['Patient', 'Doctor'];
  final List<String> _genderTypes = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void _initializeVariables() {
    //doctor user variables
    _userId = '';
    _name = '';
    _dob = DateTime.now();
    _gender = '';
    _email = '';
    _userType = '';
    _yoc = DateTime.now();
    _category = '';
    _location = '';
  }
//

  Future<void> fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        Map<String, dynamic> userData =
            await fetchUserDataFromFirestore(user.uid);

        setState(() {
          _userId = user.uid;
          _name = userData['username'];
          _dob = userData['DOB'];
          _gender = userData['gender'];
          _email = userData['email'];
          _userType = userData['userType'];
          _genderType = userData['gender'];
          _isLoading = false;
        });
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> fetchUserDataFromFirestore(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Users').doc(userId).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() ?? {};

      // Ensure all required fields are present
      userData['userId'] = userId;
      userData['username'] = userData['username'] ?? '';
      userData['DOB'] =
          (userData['DOB'] as Timestamp?)?.toDate() ?? DateTime.now();
      userData['gender'] = userData['gender'] ?? '';
      userData['email'] = userData['email'] ?? '';
      userData['userType'] = userData['userType'] ?? 'Patient';

      return userData;
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('User Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('User Profile'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Config.primaryColor,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 110),
                  const CircleAvatar(
                    radius: 65.0,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_calculateAge()} Years Old'
                    ' | Email: $_email',
                    style: const TextStyle(
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
                  margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: SizedBox(
                    width: 300,
                    height: 320,
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
                          ListTile(
                            leading: Icon(
                              Icons.person,
                              color: Colors.blueAccent[400],
                              size: 35,
                            ),
                            title: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "View Profile",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.history,
                              color: Colors.yellowAccent[400],
                              size: 35,
                            ),
                            title: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "History",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.edit,
                              color: Colors.lightGreen[400],
                              size: 35,
                            ),
                            title: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateProfilePage(
                                      userId: _userId,
                                      name: _name,
                                      dob: _dob,
                                      gender: _gender,
                                      email: _email,
                                      userType: _userType,
                                      genderType: _genderType,
                                    ),
                                  ),
                                ).then((_) {
                                  fetchUserData(); // Refresh data after returning from update page
                                });
                              },
                              child: const Text(
                                "Update Profile",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.door_back_door,
                              color: Colors.blueAccent[400],
                              size: 35,
                            ),
                            title: TextButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                MyApp.navigatorKey.currentState!.pushNamed('/');
                                //notifyListeners();
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
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
      ),
    );
  }

  String _calculateAge() {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - _dob.year;
    int month1 = currentDate.month;
    int month2 = _dob.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = _dob.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }

  String _calculateExperience() {
    DateTime now = DateTime.now();
    int experience = now.year - _yoc.year;
    if (now.month < _yoc.month ||
        (now.month == _yoc.month && now.day < _yoc.day)) {
      experience--;
    }
    return experience.toString();
  }
}
//calculate age
//calculate experience
//fetch user data


