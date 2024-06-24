import 'package:book_point/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../src/doctor.dart';

class DoctorListTile extends StatelessWidget {
  const DoctorListTile({
    super.key,
    required this.doctor,
  });

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder<List<DoctorModel>>(
      stream: _readData(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }if(snapshot.data!.isEmpty){
          return Center(child: Text('No data found'),);
        }
        final users = snapshot.data;
        return Column(
          children: users!.map((user){
            return ListTile(
              onTap: () {},
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 30.0,
                backgroundColor: colorScheme.surface,
                backgroundImage: NetworkImage(doctor.profileImageUrl),
              ),
              title: Text(
                user.doc_name!,
                style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0),
                  Text(
                    user.doc_type!,
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Row(
                    children: [
                      Icon(Icons.star, color: const Color.fromRGBO(255, 204, 128, 1), size: 16),
                      const SizedBox(width: 4.0),
                      Text(
                        user.rating.toString(),
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.work, color: colorScheme.tertiary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        user.years_of_experience!,
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                      ),
                      ),
                    ]
                  ),
                ],
              ),
              trailing: FilledButton(
                onPressed: () {},
                child: const Text('Book Now'),
                ),
            );
          }).toList(),
        );
      }
    );
  }
}
Stream<List<DoctorModel>> _readData() {
  final userCollection = FirebaseFirestore.instance.collection('users');

  return userCollection.snapshots().map((querySnapshot)
  =>querySnapshot.docs.map((e) 
  => DoctorModel.fromSnapshot(e),).toList());   

}