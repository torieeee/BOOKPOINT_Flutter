import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/config.dart';
import 'doctor_update.dart'; 
//import '../models/auth_model.dart';
import 'package:book_point/main.dart';// Import your update profile page here

class DoctorUserPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _DoctorUserPageState createState() => _DoctorUserPageState();
}

class _DoctorUserPageState extends State<DoctorUserPage> {
  late String _userId;
  late String _name;
  late DateTime _dob;
  late String _gender;
  late String _email;
  late String _userType;
  late DateTime _yoc;
  late String _category;
  late String _location;
  late User? _firebaseUser;
  Map<String, dynamic> _user = {}; 
  Map<String, dynamic> _appointment = {}; 
  final List <dynamic> _favList = []; 
 final Set _favDoc = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initializeVariables();
    fetchUserData();
  }
  void _initializeVariables() {
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


  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        setState(() {
          _userId = user.uid;
          _name = snapshot.data()?['name'] ?? '';
          _dob = (snapshot.data()?['DOB'] as Timestamp).toDate();
          _gender = snapshot.data()?['gender'] ?? '';
          _email = snapshot.data()?['email'] ?? '';
          _userType = snapshot.data()?['userType'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    backgroundImage: AssetImage('assets/profile1.jpg'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _name,
                    style:const  TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_calculateAge()} Years Old | $_gender',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_calculateExperience()} Years of experience | $_gender',
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
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                  child:  SizedBox(
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
                              child:const Text(
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
                                    builder: (context) => DoctorProfilePage(
                                      userId: _userId,
                                      name: _name,
                                      dob: _dob,
                                      gender: _gender,
                                      email: _email,
                                      userType: _userType,
                                      yoc: _yoc,
                                      category:_category,
                                      location: _location,
                                    ),
                                  ),
                                ).then((_) {
                                  fetchUserData(); // Refresh data after returning from update page
                                });
                              },
                              child: const  Text(
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
                              onPressed: () async{
                                
    await FirebaseAuth.instance.signOut();
    _firebaseUser = null;
    _appointment ;
    _favDoc.clear();
    //_fav.clear();
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
  DateTime now = DateTime.now();
  int age = now.year - _dob.year;
  if (now.month < _dob.month ||
      (now.month == _dob.month && now.day < _dob.day)) {
    age--;
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
