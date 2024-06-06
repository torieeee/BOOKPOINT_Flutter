import 'package:models/models.dart';

class DoctorPackage{
  final String id;
  final String doctorId;
  final String packageName;
  final String description;
  final Duration duration;
  final double price;
  final ConsultationMode consultationMode;


const DoctorPackage({
  required this.id,
  required this.doctorId,
  required this.packageName,
  required this.description,
  required this.duration,
  required this.price,
  required this.consultationMode,
  }
);

static const samplePackages = [
  DoctorPackage(
    id: '1',
    doctorId: '1',
    packageName: 'Basic',
    description: 'Basic consultation package',
    duration: Duration(hours: 1),
    price: 50.0,
    consultationMode: ConsultationMode.video, 
  )
  ];
}