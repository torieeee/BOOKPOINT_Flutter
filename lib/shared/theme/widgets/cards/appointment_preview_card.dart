import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppointmentPreviewCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  const AppointmentPreviewCard({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              // Config.spaceSmall,
              ScheduleCard(appointment: this.appointment),
              // Config.spaceSmall,
            ],
          ),
        ),
        Container(
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.25),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8.0),
            ),
          ),
        ),
        Container(
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.appointment}) : super(key: key);
  final Map<String, dynamic> appointment;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Check if the appointment data contains a date
    if (appointment['date'] == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.tertiary,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Text('No appointment date available',
            style: TextStyle(color: Colors.white)),
      );
    }

    // Parse the date from the appointment data
    DateTime appointmentDate = (appointment['date'] as Timestamp).toDate();
    String formattedDate =
        DateFormat('EEEE, MMMM d, y').format(appointmentDate);
    String formattedTime = DateFormat('h:mm a').format(appointmentDate);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.tertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Doctor Name: ${appointment['doc_name']}",
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 15,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(
                Icons.access_alarm,
                color: Colors.white,
                size: 17,
              ),
              const SizedBox(width: 5),
              Text(
                formattedTime,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFAB2938),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
        ],
      ),
    );
  }
}
