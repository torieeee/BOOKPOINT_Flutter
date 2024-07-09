import 'package:book_point/components/button.dart';
import 'package:book_point/models/auth_model.dart';
import 'package:book_point/providers/dio_provider.dart';
import 'package:book_point/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({Key? key, required this.doctor, required this.isFav})
      : super(key: key);
  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  Map<String, dynamic> doctor = {};
  bool isFav = false;

  @override
  void initState() {
    doctor = widget.doctor;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Doctor Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final userDoc = FirebaseFirestore.instance
                    .collection('Favorites')
                    .doc(user.uid);

                await FirebaseFirestore.instance
                    .runTransaction((transaction) async {
                  final snapshot = await transaction.get(userDoc);

                  if (!snapshot.exists) {
                    transaction.set(userDoc, {'Favorites': []});
                  }

                  List<dynamic> favorites = snapshot.data()?['Favorites'] ?? [];

                  if (favorites.contains(doctor['doc_id'])) {
                    favorites.remove(doctor['doc_id']);
                  } else {
                    favorites.add(doctor['doc_id']);
                  }

                  transaction.update(userDoc, {'Favorites': favorites});

                  // Update local state
                  setState(() {
                    isFav = !isFav;
                  });

                  // Update AuthModel
                  Provider.of<AuthModel>(context, listen: false)
                      .setFavList(Set.from(favorites));
                });
              }
            },
            icon: FaIcon(
              isFav ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AboutDoctor(
              doctorId: doctor['doc_id'],
            ),
            DetailBody(
              doctorId: doctor['doc_id'],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                width: double.infinity,
                title: 'Book Appointment',
                onPressed: () {
                  Navigator.of(context).pushNamed('booking_page',
                      arguments: {"doc_id": doctor['doc_id'],"doc_name": doctor['doc_name']});
                },
                disable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({Key? key, required this.doctorId}) : super(key: key);

  final String doctorId;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctor_bio')
          .doc(doctorId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final doctor = snapshot.data!.data() as Map<String, dynamic>;
        doctor['profile_image'] = 'profile_image/test.jpg';

        return Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: FirebaseStorage.instanceFor(
                        bucket: "gs://bookpoint-23f70.appspot.com")
                    .ref(doctor['profile_image'])
                    .getDownloadURL(),
                builder: (context, urlSnapshot) {
                  if (urlSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return CircleAvatar(
                    radius: 65.0,
                    backgroundImage: NetworkImage(urlSnapshot.data as String),
                    backgroundColor: Colors.white,
                  );
                },
              ),
              Config.spaceMedium,
              Text(
                "Dr ${doctor['doc_name']}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              SizedBox(
                width: Config.widthSize * 0.75,
                child: Text(
                  doctor['qualifications'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              Config.spaceSmall,
              SizedBox(
                width: Config.widthSize * 0.75,
                child: Text(
                  doctor['hospital'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.doctorId}) : super(key: key);
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctor_bio')
          .doc(doctorId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final doctor = snapshot.data!.data() as Map<String, dynamic>;

        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Config.spaceSmall,
              DoctorInfo(
                doctorId: doctor['doc_id'],
                patients: doctor['no_of_patients'],
                exp: doctor['years_of_experience'],
              ),
              Config.spaceMedium,
              const Text(
                'About Doctor',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Config.spaceSmall,
              Text(
                'Dr. ${doctor['doc_name']} is an experienced ${doctor['doc_type']} Specialist at ${doctor['hospital']}, graduated since ${doctor['graduation_year']}, and completed training at ${doctor['training_hospital']}.',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                softWrap: true,
                textAlign: TextAlign.justify,
              )
            ],
          ),
        );
      },
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({Key? key, required this.patients, required this.exp, required this.doctorId})
      : super(key: key);

  final int patients;
  final int exp;
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctor_bio')
            .doc(doctorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final doctor = snapshot.data!.data() as Map<String, dynamic>;
          return Row(
            children: <Widget>[
              InfoCard(
                label: 'Patients',
                value: doctor['no_of_patients'].toString(),
              ),
              const SizedBox(
                width: 15,
              ),
              InfoCard(
                label: 'Experience',
                value: doctor['years_of_experience'].toString(),
              ),
              const SizedBox(
                width: 15,
              ),
              InfoCard(
                label: 'Rating',
                value: doctor['years_of_experience'].toString(),
              ),
            ],
          );
        });
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
