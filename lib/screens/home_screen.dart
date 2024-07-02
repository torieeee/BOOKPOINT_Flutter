import 'dart:ui';
import 'package:book_point/screens/UserProfilePage.dart';
import 'package:book_point/screens/appointment_page.dart';
import 'package:book_point/shared/theme/widgets/cards/appointment_preview_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../shared/theme/widgets/avatars/circle_avatar_with_text_label.dart';
import '../shared/theme/widgets/bottom_nav_bars/main_nav_bar.dart';
import '../shared/theme/widgets/list_tiles/doctor_list_tile.dart';
import '../shared/theme/widgets/titles/section_title.dart';
import '../src/doctor.dart';
import '../src/doctor_category.dart';
import 'booking_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = {};
    Map<String, dynamic> doctor = {};
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 144, // Increased to accommodate the search bar
        backgroundColor: const Color(0xFFFFFFFF),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8.0),
            Text(
              'Welcome',
              style: GoogleFonts.sora(
                textStyle: textTheme.bodyMedium,
              ),
            ),
            Text(
              'Sean',
              style: GoogleFonts.sora(
                textStyle: textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 4.0),
                Text('Nairobi, Kenya',
                    style: GoogleFonts.sora(
                      textStyle: textTheme.bodySmall,
                    )),
                const SizedBox(height: 4.0),
                Icon(
                  Icons.expand_more,
                  color: colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Add space before the search bar
            TextFormField(
              style: GoogleFonts.spaceGrotesk(),
              decoration: InputDecoration(
                hintText: 'Search for doctors...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(Icons.filter_alt_outlined),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _DoctorCategories(),
            _MySchedule(),
            _NearbyDoctors(),
          ],
        ),
      ),
    );
  }
}

class _NearbyDoctors extends StatelessWidget {
  const _NearbyDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SectionTitle(
          title: 'Nearby Doctors',
          action: 'See all',
          onPressed: () {},
        ),
        SizedBox(height: 8.0),
        StreamBuilder<List<DoctorModel>>(
          stream: _readData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data found'));
            }

            final doctors = snapshot.data!;
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return Divider(
                  height: 24.0,
                  color: colorScheme.surfaceContainerHighest,
                );
              },
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return DoctorListTile(doctor: doctor);
              },
            );
          },
        ),
      ],
    );
  }
}

class _MySchedule extends StatelessWidget {
  const _MySchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SectionTitle(
          title: 'My appointment',
          action: 'See all',
          onPressed: () => Navigator.of(context).pushNamed('main'),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseAuth.instance.currentUser != null
              ? FirebaseFirestore.instance
                  .collection('appointments')
                  .where('patient_id',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .orderBy('date')
                  .limit(1)
                  .snapshots()
              : Stream.empty(),
          builder: (context, snapshot) {
            if (FirebaseAuth.instance.currentUser == null) {
              return Text('Please log in to view appointments');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              // Check if the error is due to missing index
              if (snapshot.error is FirebaseException &&
                  (snapshot.error as FirebaseException).code ==
                      'failed-precondition') {
                return Text('Error: ${snapshot.error}');
              }
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.tertiary,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'No appointment yet',
                          style: textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final appointmentData =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>;
              return AppointmentPreviewCard(appointment: appointmentData);
            } else {
              return Center(child: Text('No appointment data available'));
            }
          },
        ),
      ],
    );
  }
}

class _DoctorCategories extends StatelessWidget {
  const _DoctorCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: 'Categories',
          action: 'See all',
          onPressed: () {},
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: DoctorCategory.values
              .take(5)
              .map<Widget>(
                (category) => Expanded(
                  child: CircleAvatarWithTextLabel(
                    icon: category.icon,
                    label: category.name,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

void _createData(DoctorModel doctorModel) {
  final doctorCollection = FirebaseFirestore.instance.collection('doctors');
  String id = doctorCollection.doc().id;

  final newUser = DoctorModel(
    doc_name: doctorModel.doc_name,
    doc_type: doctorModel.doc_type,
    rating: doctorModel.rating,
    year_of_experience: doctorModel.year_of_experience,
    id: id,
  ).toJson();

  doctorCollection.doc(id).set(newUser);
}

class DoctorModel {
  final String? doc_id;
  final String? doc_name;
  final String? doc_type;
  final double? rating;
  final int? year_of_experience;
  final String? id;

  DoctorModel(
      {this.id,
      this.doc_id,
      this.doc_name,
      this.doc_type,
      this.rating,
      this.year_of_experience});

  static DoctorModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      if (data == null) {
        throw Exception('Document snapshot data is null');
      }
      return DoctorModel(
        id: snapshot.id,
        doc_id: data['doc_id'] as String?,
        doc_name: data['doc_name'] as String?,
        doc_type: data['doc_type'] as String?,
        rating: data['rating'] as double?,
        year_of_experience: data['year_of_experience'] as int?,
      );
    } catch (e) {
      throw Exception(
          'Error reading DoctorModel from snapshot: ${e.toString()}');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'doc_id': doc_id,
      'doc_name': doc_name,
      'doc_type': doc_type,
      'rating': rating,
      'year_of_experience': year_of_experience,
    };
  }
}

Stream<List<DoctorModel>> _readData() {
  final userCollection = FirebaseFirestore.instance.collection('Doctors');

  return userCollection.snapshots().handleError((error) {
    print('Error reading data from Firestore: ${error.toString()}');
  }).map((querySnapshot) {
    try {
      return querySnapshot.docs
          .map((e) => DoctorModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      print('Error processing querySnapshot: ${e.toString()}');
      return [];
    }
  });
}
