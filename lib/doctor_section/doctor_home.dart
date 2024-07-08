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
import 'dart:ui';

import 'package:book_point/doctor_section/requests.dart';
import 'package:book_point/shared/theme/widgets/titles/section_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auth_model.dart';
import '../shared/theme/widgets/cards/requests_card.dart';
import '../utils/config.dart';
import '../components/doctor_card.dart';
//import 'requests.dart';

/*class DoctorHome extends StatelessWidget {
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
       /* actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              authModel.logout();
            },
          ),
        ],*/
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
}*/
class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorView();
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
              
            ),
          ),
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
      ),
    ),
    body: const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(children: [
        _MyRequests(),
        _MyPrescriptions(),
              ],),
    )
  );
}
}

class _MyRequests extends StatelessWidget{
  const _MyRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    

return Column(
  children:[
    SectionTitle(title: 'My Requests',
    action:'View All',
    onPressed: ()=>Navigator.of(context).pushNamed('/doctor/requests'),
    ),
    StreamBuilder<QuerySnapshot>(
      stream:FirebaseAuth.instance.currentUser != null
      ?FirebaseFirestore.instance
      .collection('appointments')
      .where('doc_id',
      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
       .orderBy('date',descending: true)
       .limit(3)
       .snapshots()
       :Stream.empty(),
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
              final requestData =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>;
              return RequestsCard(
                  doctor: requestData,
                  patient: requestData,
                  
              );
            } else {
              return const Center(child: Text('No appointment data available'));
            }

          },
            )
  ],
);
    
  }
}
  class _MyPrescriptions extends StatelessWidget{
     const _MyPrescriptions({super.key});
     
     @override
     Widget build(BuildContext context) {
       final authModel = Provider.of<AuthModel>(context);
       final ColorScheme colorScheme = Theme.of(context).colorScheme;
       final TextTheme textTheme = Theme.of(context).textTheme;

       return Column(
         children: [
           SectionTitle(title: 'My Prescriptions',
           action: 'View All',
           onPressed: ()=>Navigator.of(context).pushNamed('/doctor/prescriptions'),
           ),
           StreamBuilder<QuerySnapshot>(
             stream:FirebaseAuth.instance.currentUser != null
             ?FirebaseFirestore.instance
             .collection('prescriptions')
             .where('doc_id',
             isEqualTo: FirebaseAuth.instance.currentUser!.uid)
             .orderBy('date',descending: true)
             .limit(3)
             .snapshots()
             :Stream.empty(),
             builder: (context, snapshot) {
               if (FirebaseAuth.instance.currentUser == null) {
                 return Text('Please log in to view prescriptions');
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
                             'No prescription yet',
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
                 final prescriptionData =
                     snapshot.data!.docs.first.data() as Map<String, dynamic>;
                 return RequestsCard(
                     doctor: prescriptionData,
                     patient: prescriptionData,
                     
                 );
               } else {
                 return const Center(child: Text('No prescription data available'));
               }
             },
           )
         ],
       );
     }
  
     
  }

