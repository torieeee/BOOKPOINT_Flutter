import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DiagnosisPage extends StatefulWidget {
  final String patientId;
  final String doctorId;

  DiagnosisPage({
    Key? key,
    required this.patientId,
    required this.doctorId,
  }) : super(key: key);

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _symptomsController;
  late TextEditingController _testResultsController;
  late TextEditingController _feedbackController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<MedicineEntry> _medicines = [];

  // Predefined list of medicines
  final List<String> _medicineList = [
    'Aspirin',
    'Ibuprofen',
    'Paracetamol',
    'Amoxicillin',
    'Omeprazole',
    'Lisinopril',
    'Levothyroxine',
    'Metformin',
    'Amlodipine',
    'Metoprolol',
    // Add more medicines as needed
  ];

  @override
  void initState() {
    super.initState();
    _symptomsController = TextEditingController();
    _testResultsController = TextEditingController();
    _feedbackController = TextEditingController();
    _medicines.add(MedicineEntry()); // Start with one empty medicine entry
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
          'patientId': widget.patientId,
          'doctorId': widget.doctorId,
          'symptoms': _symptomsController.text,
          'testResults': _testResultsController.text,
          'feedback': _feedbackController.text,
          'prescriptions': prescriptions,
          'timestamp': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('Diagnoses').add(diagnosisData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diagnosis saved successfully')),
        );

        // Clear the form after saving
        _symptomsController.clear();
        _testResultsController.clear();
        _feedbackController.clear();
        setState(() {
          _medicines = [MedicineEntry()];
        });
      } catch (e) {
        print('Error saving diagnosis: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save diagnosis')),
        );
      }
    }
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    _testResultsController.dispose();
    _feedbackController.dispose();
    for (var med in _medicines) {
      med.dosageController.dispose();
      med.frequencyController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Diagnosis'),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 30),
                const Text('Prescriptions',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ..._medicines.asMap().entries.map((entry) {
                  int idx = entry.key;
                  MedicineEntry med = entry.value;
                  return Column(
                    children: [
                      DropdownSearch<String>(
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search for a medicine",
                            ),
                          ),
                        ),
                        items: _medicineList,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
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
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (idx != 0)
                            TextButton(
                              onPressed: () => _removeMedicineEntry(idx),
                              child: const Text('Remove'),
                            ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: _addMedicineEntry,
                  child: const Text('Add Another Medicine'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveDiagnosis,
                  child: const Text('Save Diagnosis'),
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
