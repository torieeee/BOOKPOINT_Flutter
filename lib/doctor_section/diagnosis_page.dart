import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';

import 'requests.dart';

class DiagnosisPage extends StatefulWidget {
  final String patientId;
  final String doctorId;
  final String bookingId;

  DiagnosisPage({
    Key? key,
    required this.patientId,
    required this.doctorId,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _symptomsController;
  late TextEditingController _testResultsController;
  late TextEditingController _treatmentController;
  late TextEditingController _treatmentCostController;
  late TextEditingController _feedbackController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<MedicineEntry> _medicines = [];
  List<String> _medicineList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _symptomsController = TextEditingController();
    _testResultsController = TextEditingController();
    _treatmentController = TextEditingController();
    _treatmentCostController = TextEditingController();
    _feedbackController = TextEditingController();
    _medicines.add(MedicineEntry()); // Start with one empty medicine entry
    _fetchMedicines();
    _fetchExistingDiagnosis(); // Add this line
  }

  Future<void> _fetchMedicines() async {
    try {
      QuerySnapshot medicineSnapshot =
          await _firestore.collection('Medicine').get();
      Set<String> uniqueDrugs = {}; // Using a Set to avoid duplicates
      for (var doc in medicineSnapshot.docs) {
        String? drug = doc['Drug'] as String?;
        if (drug != null && drug.isNotEmpty) {
          uniqueDrugs.add(drug);
        }
      }
      setState(() {
        _medicineList = uniqueDrugs.toList()..sort(); // Convert to sorted list
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching medicines: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addMedicineEntry() {
    setState(() {
      _medicines.add(MedicineEntry());
    });
  }

  void _removeMedicineEntry(int index) {
    setState(() {
      _medicines.removeAt(index);
    });
  }

  Future<void> _saveDiagnosis() async {
  if (_formKey.currentState!.validate()) {
    try {
      List<Map<String, dynamic>> prescriptions = _medicines
          .where((med) => med.medicine != null)
          .map((med) => {
                'medicine': med.medicine,
                'dosage': med.dosageController.text,
                'frequency': med.frequencyController.text,
              })
          .toList();

      Map<String, dynamic> diagnosisData = {
        'patient_id': widget.patientId,
        'doctor_id': widget.doctorId,
        'booking_id': widget.bookingId,
        'symptoms': _symptomsController.text,
        'testResults': _testResultsController.text,
        'treatment': _treatmentController.text,
        'treatmentCost': _treatmentCostController.text,
        'feedback': _feedbackController.text,
        'prescriptions': prescriptions,
        'timestamp': FieldValue.serverTimestamp(),
      };

      QuerySnapshot existingDiagnosis = await _firestore
          .collection('Diagnoses')
          .where('booking_id', isEqualTo: widget.bookingId)
          .limit(1)
          .get();

      if (existingDiagnosis.docs.isNotEmpty) {
        await existingDiagnosis.docs.first.reference.update(diagnosisData);
      } else {
        await _firestore.collection('Diagnoses').add(diagnosisData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diagnosis saved successfully')),
      );

      // Clear the form after saving
      _symptomsController.clear();
      _testResultsController.clear();
      _treatmentController.clear();
      _treatmentCostController.clear();
      _feedbackController.clear();
      setState(() {
        _medicines = [MedicineEntry()];
      });
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RequestPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Error saving diagnosis: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save diagnosis')),
      );
    }
  }
}

  Future<void> _completeDiagnosis() async {
    if (_formKey.currentState!.validate()) {
      try {
        List<Map<String, dynamic>> prescriptions = _medicines
            .where((med) => med.medicine != null)
            .map((med) => {
                  'medicine': med.medicine,
                  'dosage': med.dosageController.text,
                  'frequency': med.frequencyController.text,
                })
            .toList();

        Map<String, dynamic> diagnosisData = {
          'patient_id': widget.patientId,
          'doctor_id': widget.doctorId,
          'booking_id': widget.bookingId,
          'symptoms': _symptomsController.text,
          'testResults': _testResultsController.text,
          'treatment': _treatmentController.text, // Change this
          'treatmentCost': _treatmentCostController.text, // Change this
          'feedback': _feedbackController.text,
          'prescriptions': prescriptions,
          'timestamp': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('Diagnoses').add(diagnosisData);
        await approveRequest(widget.bookingId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diagnosis completed successfully')),
        );

        // Clear the form after saving
        _symptomsController.clear();
        _testResultsController.clear();
        _treatmentController.clear();
        _treatmentCostController.clear();
        _feedbackController.clear();
        setState(() {
          _medicines = [MedicineEntry()];
        });
        Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RequestPage()),
        (Route<dynamic> route) => false,
      );
      } catch (e) {
        print('Error completing diagnosis: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to complete diagnosis')),
        );
      }
    }
  }

  Future<void> approveRequest(String bookingId) async {
    try {
      // Update the Requests collection
      await FirebaseFirestore.instance
          .collection('Requests')
          .where('booking_id', isEqualTo: bookingId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'status': 'Complete'});
        }
      });

      // Update the appointments collection
      await FirebaseFirestore.instance
          .collection('appointments')
          .where('booking_id', isEqualTo: bookingId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'status': 'Complete'});
        }
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request Completed successfully')),
      );
    } catch (e) {
      print('Error completing request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to completing request')),
      );
    }
  }

  Future<void> _fetchExistingDiagnosis() async {
    try {
      QuerySnapshot diagnosisSnapshot = await _firestore
          .collection('Diagnoses')
          .where('booking_id', isEqualTo: widget.bookingId)
          .limit(1)
          .get();

      if (diagnosisSnapshot.docs.isNotEmpty) {
        var diagnosisData =
            diagnosisSnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          _symptomsController.text = diagnosisData['symptoms'] ?? '';
          _testResultsController.text = diagnosisData['testResults'] ?? '';
          _treatmentController.text = diagnosisData['treatment'] ?? '';
          _treatmentCostController.text =
              diagnosisData['treatmentCost']?.toString() ?? '';
          _feedbackController.text = diagnosisData['feedback'] ?? '';

          _medicines.clear();
          List<dynamic> prescriptions = diagnosisData['prescriptions'] ?? [];
          for (var prescription in prescriptions) {
            MedicineEntry entry = MedicineEntry();
            entry.medicine = prescription['medicine'];
            entry.dosageController.text = prescription['dosage'];
            entry.frequencyController.text = prescription['frequency'];
            _medicines.add(entry);
          }
          if (_medicines.isEmpty) {
            _medicines.add(MedicineEntry());
          }
        });
      }
    } catch (e) {
      print('Error fetching existing diagnosis: $e');
    }
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    _testResultsController.dispose();
    _treatmentController.dispose();
    _treatmentCostController.dispose();
    _feedbackController.dispose();
    for (var med in _medicines) {
      med.dosageController.dispose();
      med.frequencyController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Patient Diagnosis')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Diagnosis'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _symptomsController,
                  decoration: const InputDecoration(labelText: 'Symptoms'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the symptoms';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _testResultsController,
                  decoration: const InputDecoration(labelText: 'Test Results'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the test results';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _treatmentController,
                  decoration:
                      const InputDecoration(labelText: 'Treatment Given'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter treatment given';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _treatmentCostController,
                  decoration:
                      const InputDecoration(labelText: 'Treatment cost'),
                  keyboardType:
                      TextInputType.number, // This will show a numeric keyboard
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // This will only allow digits
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter treatment cost';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(labelText: 'Feedback'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Text('Prescriptions',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ..._medicines.asMap().entries.map((entry) {
                  int idx = entry.key;
                  MedicineEntry med = entry.value;
                  return Column(
                    children: [
                      DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search for a medicine",
                            ),
                          ),
                        ),
                        items: _medicineList,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Medicine",
                            hintText: "Select a medicine",
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            med.medicine = newValue;
                          });
                        },
                        selectedItem: med.medicine,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a medicine';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: med.dosageController,
                        decoration: const InputDecoration(labelText: 'Dosage'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the dosage';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: med.frequencyController,
                        decoration:
                            const InputDecoration(labelText: 'Frequency'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the frequency';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (idx != 0)
                            TextButton(
                              onPressed: () => _removeMedicineEntry(idx),
                              child: Text('Remove'),
                            ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: _addMedicineEntry,
                  child: Text('Add Another Medicine'),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveDiagnosis,
                  child: const Text('Save Diagnosis'),
                ),
                ElevatedButton(
                  onPressed: _completeDiagnosis,
                  child: const Text('Complete Diagnosis'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineEntry {
  String? medicine;
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
}
