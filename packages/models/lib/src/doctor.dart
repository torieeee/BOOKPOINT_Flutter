

import 'doctor_address.dart';
import 'doctor_category.dart';
import 'doctor_package.dart';
import 'doctor_working_hours.dart';

import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String id;
  final String name;
  final String bio;
  final String profileImageUrl;
  final DoctorCategory category;
  final DoctorAddress address;
  final List<DoctorPackage> packages;
  final List<DoctorWorkingHours> workingHours;
  final double rating;
  final int reviewCount;
  final int patientCount;

  const Doctor({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.workingHours,
    required this.category,
    required this.address,
    required this.packages,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.patientCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    bio,
    profileImageUrl,
    workingHours,
    category,
    address,
    packages,
    rating,
    reviewCount,
    patientCount,
  ];
static final sampleDoctors = [
  Doctor(
    id: '1',
    name: 'Dr. John Doe',
    bio: 'Dr. John Doe is a cardiologist in New York, New York and is affiliated with Akatsuki Hospital',
    profileImageUrl: 'https://unsplash.com/photos/a-man-in-a-red-shirt-standing-in-a-parking-garage-CJSDD3RH7u4',
    category: DoctorCategory.familyMedicine,
    address: DoctorAddress.sampleAddresses[0],
    packages: DoctorPackage.samplePackages,
    workingHours: DoctorWorkingHours.sampleDoctorWorkingHours,
    rating: 4.5,
    reviewCount: 100,
    patientCount: 1000,
  ),
  Doctor(
    id: '2',
    name: 'Dr. Jane Doe',
    bio: 'Dentist',
    profileImageUrl: 'https://unsplash.com/photos/a-woman-smelling-a-bunch-of-yellow-flowers-zg-L3DolfN8',
    category: DoctorCategory.familyMedicine,
    address: DoctorAddress.sampleAddresses[0],
    packages: DoctorPackage.samplePackages,
    workingHours: DoctorWorkingHours.sampleDoctorWorkingHours,
    rating: 4.5,
    reviewCount: 100,
    patientCount: 1000,
  ),
];

}