/*import 'package:flutter/material.dart';
//import 'package:book_point/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Prescribe extends ChangeNotifier{
  String? prescriptionId;
  bool _isPrescribed=false;
  late User? _firebaseUser; // Firebase User object
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, dynamic> _patientData={};
  final Map<String, dynamic> _prescriptionData={};
  final Map<String, dynamic> _doctor={};

  Map<String, dynamic> get patientData => _patientData;
  Map<String, dynamic> get prescriptionData => _prescriptionData;
  Map<String, dynamic> get doctor => _doctor;

  Prescribe(){
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user==null){
        _firebaseUser = null;
        _isPrescribed=false;
        notifyListeners();
      }
      else{
        _firebaseUser=user;
        _isPrescribed=true;
        notifyListeners();
      }
      
    });
  }
bool get isPrescribed=>_isPrescribed;
 User? get firebaseUser => _firebaseUser;
 
 Future<User?> prescribe(
  String patientName, String doctor,String diagnosis,String prescription,String date) async{
    try{
      final DocumentReference _prescriptionRef = await _firestore.collection('prescriptions').add({
        'patientName':patientName,
        'doctor':doctor,
        'diagnosis':diagnosis,
        'prescription':prescription,
        'date':date,
        'doctorId':_firebaseUser!.uid,
      });
      prescriptionId=_prescriptionRef.id;
      return _firebaseUser;
  }catch(e){
    print("Error during prescription: $e");
    return null;
  }
  }
  Future<User?> CheckPrescription(String patientName)async{
    try{
      User?user=firebaseUser;
      if(user!=null){
        DocumentSnapshot prescriptionSnapshot=await FirebaseFirestore.instance.
        collection('prescriptions')
        .doc(patientName).
        get();
        if(prescriptionSnapshot.exists){
          prescriptionId=prescriptionSnapshot.id;
          _patientData['patientName']=prescriptionSnapshot['patientName'];
          _patientData['doctor']=prescriptionSnapshot['doctor'];
          _patientData['diagnosis']=prescriptionSnapshot['diagnosis'];
          _patientData['prescription']=prescriptionSnapshot['prescription'];
          _patientData['date']=prescriptionSnapshot['date'];
          _doctor['doctorId']=prescriptionSnapshot['doctorId'];
          return user;
      }
      }

      _isPrescribed=true;
      notifyListeners();
      //return userCredential.user;
    }catch(e){
      _isPrescribed=false;
      print("Error during prescription: $e");
      notifyListeners();
      //return null;
    }
    return null;
  }
 

}*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Prescribe extends ChangeNotifier {
  String? prescriptionId;
  bool _isPrescribed = false;
  late User? _firebaseUser; // Firebase User object
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, dynamic> _patientData = {};
  final Map<String, dynamic> _prescriptionData = {};
  final Map<String, dynamic> _doctor = {};

//bool setPrescribe=_isPrescribed;
  Map<String, dynamic> get patientData => _patientData;
  Map<String, dynamic> get prescriptionData => _prescriptionData;
  Map<String, dynamic> get doctor => _doctor;

  bool get isPrescribed => _isPrescribed;
  User? get firebaseUser => _firebaseUser;

  Prescribe() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _firebaseUser = null;
        _isPrescribed = false;
        notifyListeners();
      } else {
        _firebaseUser = user;
        _isPrescribed = true;
        _fetchDoctorInfo();
        notifyListeners();
      }
    });
  }

  Future<void> _fetchDoctorInfo() async {
    if (_firebaseUser != null) {
      DocumentSnapshot doctorSnapshot = await _firestore.collection('doctors').doc(_firebaseUser!.uid).get();
      if (doctorSnapshot.exists) {
        _doctor['doctorId'] = doctorSnapshot['doctorId'];
        _doctor['name'] = doctorSnapshot['name'];
      }
      notifyListeners();
    }
  }

  Future<void> prescribe(
      String patientName,
      String email,
      String diagnosis,
      String prescription) async {
    try {
      final DocumentReference _prescriptionRef = await _firestore.collection('prescriptions').add({
        'patientName': patientName,
        'email': email,
        'doctor': _doctor['name'],
        'diagnosis': diagnosis,
        'prescription': prescription,
        'doctorId': _firebaseUser!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      prescriptionId = _prescriptionRef.id;
      notifyListeners();
    } catch (e) {
      print("Error during prescription: $e");
    }
  }

  Future<void> checkPrescription(String patientName) async {
    try {
      DocumentSnapshot prescriptionSnapshot = await _firestore.collection('prescriptions').doc(patientName).get();
      if (prescriptionSnapshot.exists) {
        prescriptionId = prescriptionSnapshot.id;
        _patientData['patientName'] = prescriptionSnapshot['patientName'];
        _patientData['doctor'] = prescriptionSnapshot['doctor'];
        _patientData['diagnosis'] = prescriptionSnapshot['diagnosis'];
        _patientData['prescription'] = prescriptionSnapshot['prescription'];
        _patientData['date'] = prescriptionSnapshot['date'];
        _doctor['doctorId'] = prescriptionSnapshot['doctorId'];
        _isPrescribed = true;
      } else {
        _isPrescribed = false;
      }
      notifyListeners();
    } catch (e) {
      _isPrescribed = false;
      print("Error during prescription check: $e");
      notifyListeners();
    }
  }

 void setPrescribe(bool value) {
  _isPrescribed = value;
  notifyListeners();
}
}
