import 'package:book_point/screens/doctor_details.dart';
import 'package:book_point/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../screens/booking_page.dart';
import '../../../../src/doctor.dart';

class DoctorListTile extends StatelessWidget {
  const DoctorListTile({
    super.key,
    required this.doctor,
  });

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: colorScheme.surface,
        // backgroundImage: NetworkImage(doctor.profileImageUrl ?? ''),
      ),
      title: Text(
        doctor.doc_name ?? 'No Name',
        style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.0),
          Text(
            doctor.doc_type ?? 'No Type',
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Icon(Icons.star,
                  color: const Color.fromRGBO(255, 204, 128, 1), size: 16),
              const SizedBox(width: 4.0),
              Text(
                doctor.rating?.toString() ?? 'No Rating',
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.work, color: colorScheme.tertiary, size: 16),
              const SizedBox(width: 4),
              Text(
                doctor.year_of_experience != null
                    ? '${doctor.year_of_experience.toString()} years'
                    : 'N/A',
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: FilledButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetails(doctor: doctor.toMap(), isFav: false),
              settings: RouteSettings(
                arguments: {'doc_id': doctor.doc_id,'doc_name':doctor.doc_name},
              ),
            ),
          );
        },
        child: const Text('Book Now'),
      ),
    );
  }
}

Stream<List<DoctorModel>> _readData() {
  final userCollection = FirebaseFirestore.instance.collection('Doctors');

  return userCollection.snapshots().map((querySnapshot) =>
      querySnapshot.docs.map((e) => DoctorModel.fromSnapshot(e)).toList());
}

void _createData() {
  final userCollection = FirebaseFirestore.instance.collection("Doctors");
}


