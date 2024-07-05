/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
//import 'requests.dart';
//import '../components/doctor_card.dart';
import '../models/auth_model.dart';
import '../utils/config.dart';


class DoctorHome extends StatelessWidget{
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  DoctorView();
  }
}
class DoctorView extends StatelessWidget{
const DoctorView({super.key});

@override
Widget build(BuildContext context) {
  final authModel = Provider.of<AuthModel>(context);
  Map<String, dynamic> doctor={};
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;

  return Scaffold(
    appBar: AppBar(
      toolbarHeight: 144,
        backgroundColor: const Color(0xFFFFFFFF),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width:8.0),
          Text(
            'Welcome',
            style: GoogleFonts.sora(
              textStyle: textTheme.bodyMedium!.copyWith(
                color: colorScheme.primary,
              ),
              //color: colorScheme.primary,
            ),
          ),
          Config.spaceSmall,
          Text(
            'Daktari',
            style: GoogleFonts.sora(
              textStyle: textTheme.bodyMedium!.copyWith(
                color: colorScheme.primary,
              ),
            )
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
        ],
      )
      actions: [
        IconButton(
          icon: Icon(FontAwesomeIcons.signOutAlt),
          onPressed: () {
            //authModel.signOut();
          },
        ),
      ],
    ),
    body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('doctors').doc(authModel.user.uid).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final doctor = snapshot.data!.data();
          return Column(
            children: [
              Config.spaceMedium,
              DoctorCard(doctor: doctor),
              Config.spaceMedium,
              Expanded(
                child: ListView(
                  children: [
                    ...doctor['requests'].map((request) {
                      return RequestsCard(doctor: doctor, patient: request);
                    }).toList(),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  );
}
}*/
import 'package:book_point/doctor_section/requests.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auth_model.dart';
import '../utils/config.dart';
import '../components/doctor_card.dart';
//import 'requests.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorView();
  }
}

class DoctorView extends StatelessWidget {
  const DoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 144,
        backgroundColor: const Color(0xFFFFFFFF),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8.0),
            Text(
              'Welcome',
              style: GoogleFonts.sora(
                textStyle: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
            Config.spaceSmall,
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(authModel.firebaseUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                  return Text(
                    'Daktari',
                    style: GoogleFonts.sora(
                      textStyle: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  );
                } else {
                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  return Text(
                    userData['username'] ?? 'Daktari',
                    style: GoogleFonts.sora(
                      textStyle: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  'Nairobi, Kenya',
                  style: GoogleFonts.sora(
                    textStyle: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 4.0),
                Icon(
                  Icons.expand_more,
                  color: colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              authModel.logout();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .doc(authModel.firebaseUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found'));
          }

          final doctorData = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              Config.spaceMedium,
              DoctorCard(doctor: doctorData, isFav: false,),
              Config.spaceMedium,
              Expanded(
                child: ListView(
                  children: (doctorData['requests'] as List)
                      .map((request) => RequestsPage(
                            doctor: doctorData,
                            //patient: request,
                          ))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
