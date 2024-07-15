import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/config.dart';

class InvoicePage extends StatefulWidget {
  final String bookingId;

  const InvoicePage({Key? key, required this.bookingId}) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  String businessTill = '';
  bool isLoading = true;
  int treatmentCost = 0;
  List<Map<String, dynamic>> medicineList = [];
  int totalCost = 0;

  @override
  void initState() {
    super.initState();
    _fetchInvoiceDetails();
  }

  Future<void> _fetchInvoiceDetails() async {
    try {
      // Fetch diagnosis details
      QuerySnapshot diagnosisQuery = await FirebaseFirestore.instance
          .collection('Diagnoses')
          .where('booking_id', isEqualTo: widget.bookingId)
          .limit(1)
          .get();

      if (diagnosisQuery.docs.isNotEmpty) {
        DocumentSnapshot diagnosisDoc = diagnosisQuery.docs.first;
        Map<String, dynamic> diagnosisData =
            diagnosisDoc.data() as Map<String, dynamic>;
        treatmentCost = diagnosisData['treatmentCost'] ?? 0;
        String doctorId = diagnosisData['doctor_id'] ?? '';

        DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
            .collection('Doctors')
            .doc(doctorId)
            .get();

        if (doctorDoc.exists) {
          Map<String, dynamic> doctorData =
              doctorDoc.data() as Map<String, dynamic>;
          businessTill = doctorData['business_till'] ?? '';
        } else {
          throw Exception('Doctor not found');
        }

        List<dynamic> prescriptions = diagnosisData['prescriptions'] ?? [];

        for (var prescription in prescriptions) {
          if (prescription is Map<String, dynamic> &&
              prescription.containsKey('medicine')) {
            String medicineName = prescription['medicine'];
            QuerySnapshot medicineQuery = await FirebaseFirestore.instance
                .collection('Medicine')
                .where('Drug', isEqualTo: medicineName)
                .limit(1)
                .get();

            if (medicineQuery.docs.isNotEmpty) {
              Map<String, dynamic> medicineData =
                  medicineQuery.docs.first.data() as Map<String, dynamic>;
              medicineList.add({
                'Drug': medicineName,
                'Price': medicineData['Price'] ?? 0,
              });
            }
          }
        }

        // Calculate total cost
        totalCost = treatmentCost +
            medicineList.fold(
                0, (sum, medicine) => sum + (medicine['Price'] as int));

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Diagnosis not found');
      }
    } catch (e) {
      print('Error fetching invoice details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load invoice details. Please try again.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        backgroundColor: Config.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking ID: ${widget.bookingId}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('Treatment Cost:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('\$${treatmentCost.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text('Prescribed Medicines:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ...medicineList.map((medicine) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(medicine['Drug'],
                                style: const TextStyle(fontSize: 16)),
                            Text('\$${medicine['Price'].toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      )),
                  const Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Cost:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('\$${totalCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Business Payment Till Number:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${businessTill}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement payment processing here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'If payment has been made wait for it to be processed')),
                        );
                      },
                      child: const Text('Proccessing after payment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF919191),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
