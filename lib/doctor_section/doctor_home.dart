import 'dart:ui';
import 'package:book_point/shared/theme/widgets/titles/section_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../shared/theme/widgets/cards/request_preview_card.dart';
import '../shared/theme/widgets/cards/requests_card.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 144,
          backgroundColor: const Color(0xFFFFFFFF),
          title: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseAuth.instance.currentUser != null
                ? FirebaseFirestore.instance
                    .collection('Doctors')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots()
                : null,
            builder: (context, snapshot) {
              if (FirebaseAuth.instance.currentUser == null) {
                return Text('Please log in to view your profile');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              String userName = 'Guest';
              if (snapshot.hasData && snapshot.data!.exists) {
                userName = snapshot.data!.get('doc_name') ?? 'Guest';
              }

              if (userName.isEmpty) {
                return CircularProgressIndicator();
              }

              return Column(
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
                    userName,
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
                  const SizedBox(height: 16.0),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _MyRequests(),
              SizedBox(
                height: 16.0,
              ),
              AnalyticsSection(),
              // _MyPrescriptions(),
            ],
          ),
        ));
  }
}

class _MyRequests extends StatelessWidget {
  const _MyRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SectionTitle(
          title: 'My requests',
          action: 'See all',
          onPressed: () => Navigator.of(context).pushNamed('/doctor/requests'),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseAuth.instance.currentUser != null
              ? FirebaseFirestore.instance
                  .collection('Requests')
                  .where('doc_id',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .orderBy('date')
                  .limit(1)
                  .snapshots()
              : Stream.empty(),
          builder: (context, snapshot) {
            if (FirebaseAuth.instance.currentUser == null) {
              return Text('Please log in to view requests');
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
                          'No requests yet',
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
              return RequestPreviewCard(request: requestData);
            } else {
              return Center(child: Text('No request data available'));
            }
          },
        ),
      ],
    );
  }
}

class _MyPrescriptions extends StatelessWidget {
  const _MyPrescriptions({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SectionTitle(
          title: 'My Prescriptions',
          action: 'View All',
          onPressed: () =>
              Navigator.of(context).pushNamed('/doctor/prescriptions'),
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
                stream: FirebaseAuth.instance.currentUser != null
                    ? FirebaseFirestore.instance
                        .collection('prescriptions')
                        .where('doc_name', isEqualTo: doctorName)
                        .orderBy('date', descending: true)
                        .limit(1)
                        .snapshots()
                    : Stream.empty(),
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
                    final prescriptionData = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;
                    return RequestsCard(
                      doctor: prescriptionData,
                      patient: prescriptionData,
                    );
                  } else {
                    return const Center(
                        child: Text('No prescription data available'));
                  }
                },
              );
            }),
      ],
    );
  }
}
class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('requests').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<QueryDocumentSnapshot> requests = snapshot.data!.docs;

        // Process data for charts
        Map<String, int> dailyRequests = processDailyRequests(requests);
        Map<String, int> statusDistribution = processStatusDistribution(requests);
        List<int> weeklyRequests = processWeeklyRequests(requests);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // SizedBox(height: 20),
            // Text(
            //   'Daily Requests',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 10),
            // Container(
            //   height: 200,
            //   child: LineChart(
            //     LineChartData(
            //       gridData: FlGridData(show: true),
            //       titlesData: FlTitlesData(
            //         bottomTitles: AxisTitles(
            //           sideTitles: SideTitles(
            //             showTitles: true,
            //             getTitlesWidget: (value, meta) {
            //               List<String> dates = dailyRequests.keys.toList();
            //               if (value.toInt() >= 0 && value.toInt() < dates.length) {
            //                 return Text(dates[value.toInt()].substring(5)); // Show only MM-dd
            //               }
            //               return Text('');
            //             },
            //           ),
            //         ),
            //         leftTitles: AxisTitles(
            //           sideTitles: SideTitles(showTitles: true),
            //         ),
            //       ),
            //       borderData: FlBorderData(show: true),
            //       lineBarsData: [
            //         LineChartBarData(
            //           spots: dailyRequests.entries
            //               .map((e) => FlSpot(dailyRequests.keys.toList().indexOf(e.key).toDouble(), e.value.toDouble()))
            //               .toList(),
            //           isCurved: true,
            //           color: Colors.blue,
            //           barWidth: 4,
            //           isStrokeCapRound: true,
            //           dotData: FlDotData(show: true),
            //           belowBarData: BarAreaData(show: false),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
            Text(
              'Request Status Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: statusDistribution.entries.map((e) => 
                    PieChartSectionData(
                      color: getColorForStatus(e.key),
                      value: e.value.toDouble(),
                      title: '${e.key}\n${(e.value / requests.length * 100).toStringAsFixed(1)}%',
                      radius: 100,
                      titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  ).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Weekly Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: weeklyRequests.reduce((a, b) => a > b ? a : b).toDouble(),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Text(days[value.toInt()]);
                          }
                          return Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (index) => 
                    BarChartGroupData(
                      x: index,
                      barRods: [BarChartRodData(toY: weeklyRequests[index].toDouble(), color: Colors.blue)],
                    )
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, int> processDailyRequests(List<QueryDocumentSnapshot> requests) {
    Map<String, int> dailyRequests = {};
    for (var request in requests) {
      DateTime date = (request['date'] as Timestamp).toDate();
      String dateString = DateFormat('dd-MM-yyyy').format(date);
      dailyRequests[dateString] = (dailyRequests[dateString] ?? 0) + 1;
    }
    return Map.fromEntries(dailyRequests.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  Map<String, int> processStatusDistribution(List<QueryDocumentSnapshot> requests) {
    Map<String, int> statusDistribution = {};
    for (var request in requests) {
      String status = request['status'] ?? 'Unknown';
      statusDistribution[status] = (statusDistribution[status] ?? 0) + 1;
    }
    return statusDistribution;
  }

  List<int> processWeeklyRequests(List<QueryDocumentSnapshot> requests) {
    List<int> weeklyRequests = List.filled(7, 0);
    for (var request in requests) {
      DateTime date = (request['date'] as Timestamp).toDate();
      int dayOfWeek = date.weekday - 1; // 0 for Monday, 6 for Sunday
      weeklyRequests[dayOfWeek]++;
    }
    print(weeklyRequests); 
    return weeklyRequests;
  }

  Color getColorForStatus(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}