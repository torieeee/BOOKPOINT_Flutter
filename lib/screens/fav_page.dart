import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/doctor_card.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Doctor>> getFavoriteDoctors() {
  final user = _auth.currentUser;
  if (user != null) {
    return _firestore
        .collection('Favorites')
        .doc(user.uid)
        .snapshots()
        .asyncMap((docSnapshot) async {
      if (!docSnapshot.exists || !docSnapshot.data()!.containsKey('Favorites')) {
        print('No favorites found for user: ${user.uid}');
        return [];
      }

      List<dynamic> favoritesList = docSnapshot.data()!['Favorites'];
      print('Favorites list for user ${user.uid}: $favoritesList');

      List<Doctor> doctors = [];
      for (var favorite in favoritesList) {
        if (favorite is Map<String, dynamic> && favorite.containsKey('doc_id')) {
          String doctorId = favorite['doc_id'];
          try {
            DocumentSnapshot doctorDoc = await _firestore
                .collection('doctor_bio')
                .doc(doctorId)
                .get();
            if (doctorDoc.exists) {
              doctors.add(Doctor.fromMap(doctorDoc.data() as Map<String, dynamic>));
            } else {
              print('Doctor document does not exist: $doctorId');
            }
          } catch (e) {
            print('Error fetching doctor data: $e');
          }
        } else {
          print('Invalid favorite entry: $favorite');
        }
      }
      return doctors;
    });
  }
  return Stream.value([]);
}

Future<void> removeDoctorFromFavorites(String doctorId) async {
  final user = _auth.currentUser;
  if (user != null) {
    try {
      await _firestore.collection('Favorites').doc(user.uid).update({
        'Favorites': FieldValue.arrayRemove([{'doc_id': doctorId}])
      });
      print('Doctor removed from favorites: $doctorId');
    } catch (e) {
      print('Error removing doctor from favorites: $e');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20,),
        child: Column(
          children: [
            const Text(
              'My Favorite Doctors',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: StreamBuilder<List<Doctor>>(
                stream: getFavoriteDoctors(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No favorite doctors'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return DoctorCard(
                        doctor: snapshot.data![index].toMap(),
                        isFav: true,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Doctor {
  final String id;
  final String name;
  final String speciality;
  // Add other fields as necessary

  Doctor({required this.id, required this.name, required this.speciality});

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['doc_id'] ?? '',
      name: map['doc_name'] ?? '',
      speciality: map['doc_type'] ?? '',
      // Parse other fields
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doc_id': id,
      'doc_name': name,
      'doc_type': speciality,
      // Add other fields as necessary
    };
  }
}
