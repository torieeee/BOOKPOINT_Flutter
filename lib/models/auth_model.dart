//import 'dart:convert';
/*import 'package:flutter/material.dart';
import '../providers/database_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {};

  //Map<String, dynamic> user = {}; //update user details when login
  Map<String, dynamic> appointment ={}; //update upcoming appointment when login
  List<Map<String, dynamic>> favDoc = []; //get latest favorite doctor
  List<dynamic> _fav = []; //get all fav doctor id in list
  late DatabaseHelper _dbHelper;
   late User? _firebaseUser;
   FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth  _firebaseAuth=FirebaseAuth.instance;

  AuthModel(){
    _dbHelper=DatabaseHelper(
      host: 'localhost',
     port: 3306,
      user: 'root',
       password: '',
        databaseName: 'book_point'
        );
        _dbHelper.openConnection();

  }
  @override
  void dispose(){
    _dbHelper.closeConnection();
    super.dispose();
  }

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

//this is to update latest favorite list and notify all widgets
  void setFavList(List<dynamic> list) {
    _fav = list;
    notifyListeners();
  }

//and this is to return latest favorite doctor list
  List<Map<String, dynamic>> get getFavDoc {
    favDoc.clear(); //clear all previous record before get latest list

    //list out doctor list according to favorite list
    for (var num in _fav) {
      for (var doc in user ['doctor']) {
        if (num == doc['doc_id']) {
          favDoc.add(doc);
        }
      }
    }
    return favDoc;
  }

  /*Future <void> login(String email,String password) async{
    try{
      UserCredential userCredential= await _firebaseAuth.signInWithEmailAndPassword(
        email:email,
        password:password,
      );
      user =userCredential.user as Map<String, dynamic>;
      _isLogin=true;
      notifyListeners();
    }catch(e){
      _isLogin=false;
      //print("Error during login: $e");

    }
  }*/
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        user = {
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'displayName': userCredential.user!.displayName,
          

          // Add any other relevant user information
        };
        _isLogin = true;
      } else {
        user = {};
        _isLogin = false;
      }

      notifyListeners();
    } catch (e) {
      _isLogin = false;
      // Handle error (e.g., log it or show a message to the user)
    }
  }

  /*Future <void> register(String username, String email, String password) async{
    try{
      UserCredential userCredential=await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user as Map<String, dynamic>;
      await user.updateProfile(displayName: username);
      _isLogin = true;
      notifyListeners();
    }catch (e) {
      _isLogin = false;
      print("Error during registration: $e");
    }
  }*/

  Future<void> register(String username, String email, String password) async {
  try {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (userCredential.user != null) {
      await userCredential.user!.updateProfile(displayName: username);
      user = {
        //'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'displayName': userCredential.user!.displayName,
        'password':userCredential.user!.updatePassword(password),
        // Add any other relevant user information
      };
      _isLogin = true;
    } else {
      user = {};
      _isLogin = false;
    }
    
    notifyListeners();
  } catch (e) {
    _isLogin = false;
    print("Error during registration: $e");
  }
}


  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _isLogin = false;
    user = {};
    notifyListeners();
  }
}

//when login success, update the status
  /*void loginSuccess(
      Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo) {
    _isLogin = true;

    //update all these data when login
    user = userData;
    appointment = appointmentInfo;
    if (user['details']['fav'] != null) {
      _fav = json.decode(user['details']['fav']);
    }

    notifyListeners();
  }*/
  /*Future<void>loginSuccess(String email, String password) async{
    try{
      final  isAuthenticated=await _dbHelper.authService(email, password);
       if(isAuthenticated){
        final userData= await _dbHelper.getUserData(email);
        final appointmentInfo={};

        _isLogin=true;
        user=userData;
        appointment=appointmentInfo;
        if (user['details']['fav']!=null){
          _fav=json.decode(user['details']['fav']);
        }
        notifyListeners();

       }
    }catch(e){
      print('Error during login:$e');
    }

  }*/
*/
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

  // Getter for appointment data
  Map<String, dynamic> get appointment => _appointment;

  // Getter for favorite list data
  List<dynamic> get getFav => _favList.toList();

  AuthModel() {
    // Initialize Firebase Auth
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _isLogin = false;
        _firebaseUser = null;
        _appointment;
        _favDoc.clear();
        _fav.clear();
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
  //Map<String, dynamic>? get appointment => _appointment;
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
          await _firestore.collection('Users').doc(user.uid).update({
            'emailVerified': true,
          });

          String userType = userDoc['userType'];

          // Navigate based on user type
          if (userType == 'Doctor') {
            MyApp.navigatorKey.currentState!.pushNamed('doctor');
          } else {
            MyApp.navigatorKey.currentState!.pushNamed('main');
          }
        } else {
          MyApp.navigatorKey.currentState!.pushNamed('main');
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
          await _firestore.collection('Users').doc(_firebaseUser!.uid).get();

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
