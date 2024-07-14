import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:book_point/utils/config.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final String name;
  final DateTime dob;
  final String gender;
  final String email;
  final String userType;
  final String genderType;

  ProfilePage({
    Key? key,
    required this.userId,
    required this.name,
    required this.dob,
    required this.gender,
    required this.email,
    required this.userType,
    required this.genderType,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late String _userType;
  late String _genderType;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> _userTypes = ['Patient', 'Doctor'];
  final List<String> _genderTypes = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _dobController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(widget.dob));
    _genderController = TextEditingController(text: widget.gender);
    _emailController = TextEditingController(text: widget.email);
    _userType =
        _userTypes.contains(widget.userType) ? widget.userType : _userTypes[0];
    _genderType = _genderTypes.contains(widget.genderType)
        ? widget.genderType
        : _genderTypes[0];

     // Add this print statement for debugging
    print("Initial _genderType: $_genderType");
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          DateTime dob = DateFormat('dd/MM/yyyy').parse(_dobController.text);

          Map<String, dynamic> userData = {
            'username': _nameController.text,
            'DOB': dob,
            'gender': _genderType,
            'email': _emailController.text,
            'userType': _userType,
          };

          await _firestore.collection('Users').doc(user.uid).update(userData);

          if (_userType == 'Doctor') {
            await _firestore
                .collection('Doctors')
                .doc(user.uid)
                .update(userData);
          } else if (_userType == 'Patient') {
            await _firestore
                .collection('Patients')
                .doc(user.uid)
                .update(userData);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
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
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
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
                  decoration: const InputDecoration(
                      labelText: 'Date of Birth (DD/MM/YYYY)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your date of birth';
                    }
                    try {
                      DateFormat('dd/MM/yyyy').parse(value);
                    } catch (e) {
                      return 'Please enter a valid date (DD/MM/YYYY)';
                    }
                    return null;
                  },
                ),
                Config.spaceSmall,
                DropdownButtonFormField<String>(
                  value: _genderType,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                  ),
                  items: _genderTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _genderType = newValue;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
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
                // DropdownButtonFormField<String>(
                //   value: _userType,
                //   decoration: const InputDecoration(
                //     labelText: 'User Type',
                //   ),
                //   items: _userTypes.map((String type) {
                //     return DropdownMenuItem<String>(
                //       value: type,
                //       child: Text(type),
                //     );
                //   }).toList(),
                //   onChanged: (newValue) {
                //     if (newValue != null) {
                //       setState(() {
                //         _userType = newValue;
                //       });
                //     }
                //   },
                // ),
                Config.spaceSmall,
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchUserData(String userId) async {
  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Ensure all required fields are present
      userData['userId'] = userId;
      userData['username'] = userData['username'] ?? '';
      userData['DOB'] = userData['DOB'] ?? DateTime.now();
      userData['gender'] = userData['gender'] ?? '';
      userData['email'] = userData['email'] ?? '';
      userData['userType'] = userData['userType'] ?? 'Patient';

      return userData;
    } else {
      throw Exception('User not found');
    }
  } catch (e) {
    print('Error fetching user data: $e');
    rethrow;
  }
}
