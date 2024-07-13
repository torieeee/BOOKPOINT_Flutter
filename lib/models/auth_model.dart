import 'package:flutter/material.dart';
import 'package:book_point/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel extends ChangeNotifier {
  String? userId;
  bool _isLogin = false;
  late User? _firebaseUser; // Firebase User object
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Data related to user appointments and favorites
  Map<String, dynamic> _user = {};
  Map<String, dynamic> _appointment = {};
  final List<dynamic> _favList = [];
  final Set _favDoc = {};
  Set _fav = {};

  Map<String, dynamic> get user => _user;

  
  Map<String, dynamic> get appointment => _appointment;

  // Getter for favorite
  List<dynamic> get getFav => _favList.toList();

  AuthModel() {
    // Initialize Firebase Auth
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _isLogin = false;
        _firebaseUser = null;
        //_appointment;
        //_favDoc.clear();
        //_fav.clear();
      } else {
        _firebaseUser = user;
        _isLogin = true;
        _fetchUserData();
      }
      notifyListeners();
    });
  }

  bool get isLogin => _isLogin;
  User? get firebaseUser => _firebaseUser;
  

  //List<Map<String, dynamic>> get favDoc => _favDoc;
  Set get fav => _fav;

  get getFavDoc => null;

  Future<User?> login(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      if (user.emailVerified) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        
        if (userDoc.exists) {
          // Update the emailVerified status in Firestore
          await _firestore.collection('Users')
          .doc(user.uid)
          .update({
            'emailVerified': true,
          });
          

          String userType = userDoc['userType'];
          _isLogin=true;

          // Navigate based on user type
          if (userType == 'Doctor') {
            MyApp.navigatorKey.currentState!.
            pushNamed('doctor',arguments:{
              'doc_id': user.uid,
              'doc_name': _user['username'],

            });
          } else {
            MyApp.navigatorKey.currentState!
           .pushNamed('main',arguments:{
              'doc_id': user.uid,
              'doc_name': _user['username'],
           });
          }
        } else {
          MyApp.navigatorKey.currentState!
          .pushNamed('main');
        }
        
        _isLogin = true;
        notifyListeners();
        return user;
      } else {
        // Email is not verified
        print("Please verify your email before logging in.");
        await FirebaseAuth.instance.signOut(); // Sign out the unverified user
        return null;
      }
    }
  } catch (e) {
    _isLogin = false;
    notifyListeners();
    print("Error during login: $e");
    _firebaseUser = null;
  }
}

  Future<User?> register(String username, String email, String password, String userType) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      // Send verification email
      await user.sendEmailVerification();

      // Store additional user data in Firestore
      await _firestore.collection('Users').doc(user.uid).set({
        'username': username,
        'email': email,
        'userType': userType, // Add this field
      });
      print("User data stored in 'Users' collection.");
      if (userType == 'Doctor') {
          await _firestore.collection('Doctors').doc(user.uid).set({
            'doc_id': user.uid,
            'doc_name': username,
            'rating':4.9,
            'doc_type':userType,
            'createdAt': FieldValue.serverTimestamp(),
          });
          print("User data stored in 'Doctors' collection.");
        } else if (userType == 'Patient') {
          await _firestore.collection('Patients').doc(user.uid).set({
            'patient_id': user.uid,
            'patient_name': username,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });
          print("User data stored in 'Patients' collection.");
        }
      _firebaseUser = userCredential.user;
      userId = userCredential.user!.uid;
      notifyListeners();
      
      // Inform the user to check their email
      print("A verification email has been sent. Please verify your email before logging in.");
  
    }
  } catch (e) {
    print("Error during registration: $e");
    _firebaseUser = null;
  }
}

  Future<User?> logout() async {
    await FirebaseAuth.instance.signOut();
    _firebaseUser = null;
    _appointment;
    _favDoc.clear();
    _fav.clear();
    notifyListeners();
  }

  // Fetch user data from Firestore
  Future<User?> _fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore
          .collection('Users')
          .doc(_firebaseUser!.uid)
          .get();

      // Fetch appointment data
      if (userSnapshot.data() != null &&
          userSnapshot.data()!['appointment'] != null) {
        _appointment = userSnapshot.data()!['appointment'];
      } else {
        _appointment;
      }

      // Fetch favorite doctors
      _favDoc.clear();
      _fav.clear();
      if (userSnapshot.data() != null && userSnapshot.data()!['fav'] != null) {
        _fav = Set.from(userSnapshot.data()!['fav']);
        // Fetch details of favorite doSctors
        for (var docId in _fav) {
          DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _firestore
              .collection('Doctors')
              .doc(docId as String?)
              .get();
          if (docSnapshot.exists) {
            _favDoc.add(docSnapshot.data()!);
          }
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      _appointment;
      _favDoc.clear();
      _fav.clear();
    }
    notifyListeners();
    return null;
  }

  // Method to update favorite list and notify listeners
  void setFavList(Set list) {
    _fav = list;
    notifyListeners();
  }
}
