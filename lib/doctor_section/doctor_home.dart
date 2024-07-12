import 'dart:ui';
import 'package:book_point/shared/theme/widgets/titles/section_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../shared/theme/widgets/cards/requests_card.dart';

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
            'Welcome ',
            style: GoogleFonts.sora(
              textStyle: textTheme.bodyMedium!.copyWith(
                color: colorScheme.primary,
              ),
              
            ),
          ),
          Text(
            'Daktari ${FirebaseAuth.instance.currentUser!.displayName} ',
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
        SizedBox(height: 16.0,),
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    

return Column(
  children:[
    SectionTitle(title: 'My Requests',
    action:'View All',
    onPressed: ()=>Navigator.of(context).pushNamed('RequestsPage'),
    ),
    FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            // Fetch the doctor name from the user's document
            var userDoc = snapshot.data;
            String doctorName = userDoc!['name'];

            // Use the doctor name to fetch appointments
            return  StreamBuilder<QuerySnapshot>(
      stream:FirebaseAuth.instance.currentUser != null
      ?FirebaseFirestore.instance
      .collection('appointments')
      .where('doc_name',
      isEqualTo: doctorName)
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
            );
          }
    ),
  ],
);
    
  }
}
  class _MyPrescriptions extends StatelessWidget{
     const _MyPrescriptions({super.key});
     
     @override
     Widget build(BuildContext context) {
       final ColorScheme colorScheme = Theme.of(context).colorScheme;
       final TextTheme textTheme = Theme.of(context).textTheme;

       return Column(
         children: [
           SectionTitle(title: 'My Prescriptions',
           action: 'View All',
           onPressed: ()=>Navigator.of(context).pushNamed('/doctor/prescriptions'),
           ),

           FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            var userDoc = snapshot.data;
            String doctorName = userDoc!['name'];

          return StreamBuilder<QuerySnapshot>(
             stream:FirebaseAuth.instance.currentUser != null
             ?FirebaseFirestore.instance
             .collection('prescriptions')
             .where('doc_name',
             isEqualTo: doctorName)
             .orderBy('date',descending: true)
             .limit(1)
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
           );
          }
           ),
     
         ],
       );
     }
  
     
  }

