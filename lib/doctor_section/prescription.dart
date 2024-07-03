/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/config.dart';
import '../components/button.dart';
import '../models/prescribe.dart';


class PrescriptionForm extends StatefulWidget {
  const PrescriptionForm({super.key});

  @override
  State<PrescriptionForm> createState() => _PrescriptionFormState();

  Future<void> createPrescriptionInFirestore(
    String userId,
     String name,
      String email,
       String doctor,
       String diagnosis,
       String prescription,
       ) async {
  try {
    await FirebaseFirestore.instance.collection('prescriptions').add({
      'name': name,
      'email': email,
      'Doctor': doctor,
      'diagnosis': diagnosis,
      'prescription': prescription,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print('Prescription created in Firestore');
  } catch (e) {
    print('Error creating prescription in Firestore: $e');
  }
}
}

class _PrescriptionFormState extends State<PrescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _doctorController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();
  bool _isPrescribe = false;

  //final List<String> _userTypes=['Doctor','Patient'];

   

  @override
  void dispose() {
    // _dbHelper.closeConnection(); // Close database connection
    _nameController.dispose();
    _emailController.dispose();
    _doctorController.dispose();
    _diagnosisController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  

   @override
  void initState() {
    super.initState();
    _fetchDoctorInfo();
  }
Future<void> _fetchDoctorInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doctorSnapshot =
          await FirebaseFirestore.instance.collection('doctors').doc(user.uid).get();
      if (doctorSnapshot.exists) {
        setState(() {
          _doctorController.text = doctorSnapshot['name'];
        });
      }
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:<Widget> [
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              labelText: 'Patient\'s Name',
               hintText: 'Username',
               alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outlined),
              prefixIconColor: Config.primaryColor,
               ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the patient\'s name';
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
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
              ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the patient\'s email';
              }
              return null;
            },
          ),

          Config.spaceSmall,
          TextFormField(
            controller: _diagnosisController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              labelText: 'Diagnosis',
              hintText: 'Enter diagnosis',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.note_outlined),
              prefixIconColor: Config.primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the diagnosis';
              }
              return null;
            },
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _prescriptionController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              labelText: 'Prescription',
              hintText: 'Enter prescription',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.local_pharmacy_outlined),
              prefixIconColor: Config.primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the prescription';
              }
              return null;
            },
          ),

          Config.spaceSmall,
          TextFormField(
            controller: _doctorController,
             readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Doctor',
              prefixIcon: const Icon(Icons.person_pin_outlined),
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
          Consumer<PrescriptionForm>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Send Prescription',
                disable: _isPrescribe,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isPrescribe = true;
                    });
                    final name = _nameController.text;
                    final email = _emailController.text;
                    final doctor = _doctorController.text;
                    final diagnosis = _diagnosisController.text;
                    final prescription = _prescriptionController.text;
                    await widget.createPrescriptionInFirestore(
                      FirebaseAuth.instance.currentUser!.uid,
                      name,
                      email,
                      doctor,
                      diagnosis,
                      prescription,
                    );
                    setState(() {
                      _isPrescribe = false;
                    });
                  }
                },
                
              );
            },
          ),
        ],
      ),
    );
  }
}*/

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import '../utils/config.dart';
import '../components/button.dart';
import '../models/prescribe.dart';



class PrescriptionForm extends StatefulWidget {
  const PrescriptionForm({super.key});

  @override
  State<PrescriptionForm> createState() => _PrescriptionFormState();
}

class _PrescriptionFormState extends State<PrescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _doctorController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _doctorController.dispose();
    _diagnosisController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final prescribe = Provider.of<Prescribe>(context, listen: false);
      _doctorController.text = prescribe.doctor['name'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final prescribe = Provider.of<Prescribe>(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              labelText: 'Patient\'s Name',
              hintText: 'Username',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outlined),
              prefixIconColor: Config.primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the patient\'s name';
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
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the patient\'s email';
              }
              return null;
            },
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _diagnosisController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              labelText: 'Diagnosis',
              hintText: 'Enter diagnosis',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.note_outlined),
              prefixIconColor: Config.primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the diagnosis';
              }
              return null;
            },
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _prescriptionController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              labelText: 'Prescription',
              hintText: 'Enter prescription',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.local_pharmacy_outlined),
              prefixIconColor: Config.primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the prescription';
              }
              return null;
            },
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _doctorController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Doctor',
              prefixIcon: Icon(Icons.person_pin_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          Button(
            width: double.infinity,
            title: 'Send Prescription',
            disable: prescribe.isPrescribed,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
               prescribe.setPrescribe(true);
                final name = _nameController.text;
                final email = _emailController.text;
                final diagnosis = _diagnosisController.text;
                final prescription = _prescriptionController.text;
                await prescribe.prescribe(
                  name,
                  email,
                  diagnosis,
                  prescription,
                );
                prescribe.setPrescribe(false);
              }
            },
          ),
        ],
      ),
    );
  }
}
