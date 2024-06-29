import 'package:book_point/components/button.dart';
import 'package:book_point/components/custom_appbar.dart';
import 'package:book_point/main.dart';
import 'package:book_point/models/booking_datetime_converted.dart';
import 'package:book_point/providers/dio_provider.dart';
import 'package:book_point/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  //declaration
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? token; //get token for insert booking date and time into database

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    String? docId;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      docId = args['doc_id'] as String?;
    }

    if (docId == null) {
      // Handle the case where doc_id is not provided
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Doctor ID not provided')),
      );
      // Navigator.pop(context); // Uncomment this if you want to go back automatically
    }
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Appointment',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Consultation Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          _isWeekend
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    alignment: Alignment.center,
                    child: const Text(
                      'Weekend is not available, please select another date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                            _timeSelected = true;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: _currentIndex == index
                                ? Config.primaryColor
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  _currentIndex == index ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1.5),
                ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: Button(
                width: double.infinity,
                title: 'Make Appointment',
                onPressed: () async {
                  if (docId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: Doctor ID is missing')),
                    );
                    return;
                  }

                  final getDate = DateConverted.getDate(_currentDay);
                  final getTime = DateConverted.getTime(_currentIndex!);

                  final DateTime appointmentDateTime = DateTime(
                    _currentDay.year,
                    _currentDay.month,
                    _currentDay.day,
                    _currentIndex! + 8, // Assuming the time starts from 9:00 AM
                    0, // Minutes
                  );

                  try {
                    DocumentReference docRef = await FirebaseFirestore.instance
                        .collection('appointments')
                        .add({
                      'date': Timestamp.fromDate(appointmentDateTime), 
                      'doc_id': docId,
                      'status': 'pending',
                    });

                    String bookingId = docRef.id;
                    await docRef.update({'booking_id': bookingId});
                    MyApp.navigatorKey.currentState!
                        .pushNamed('success_booking', arguments: bookingId);
                  } catch (e) {
                    print('Error creating booking: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating appointment: $e')),
                    );
                  }
                },
                disable: _timeSelected && _dateSelected ? false : true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //table calendar
  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2025, 12, 31), // Updated to a future date
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;

          //check if weekend is selected
          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      }),
    );
  }
}
