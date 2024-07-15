import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../shared/theme/widgets/list_tiles/doctor_list_tile.dart';
import 'home_screen.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;

  const SearchPage({Key? key, this.initialQuery}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<DoctorModel> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery != null) {
      _performSearch(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    FirebaseFirestore.instance
        .collection('Doctors')
        .where('doc_name', isGreaterThanOrEqualTo: query)
        .where('doc_name', isLessThan: query + 'z')
        .get()
        .then((querySnapshot) {
      setState(() {
        _searchResults = querySnapshot.docs
            .map((doc) => DoctorModel.fromSnapshot(doc))
            .toList();
      });
    });

    // Search for doctor types
    FirebaseFirestore.instance
        .collection('Doctors')
        .where('doc_type', isGreaterThanOrEqualTo: query)
        .where('doc_type', isLessThan: query + 'z')
        .get()
        .then((querySnapshot) {
      setState(() {
        _searchResults.addAll(querySnapshot.docs
            .map((doc) => DoctorModel.fromSnapshot(doc))
            .toList());
      });
    });

    // Search for hospitals (assuming there's a 'hospital' field in the Doctor document)
    FirebaseFirestore.instance
        .collection('Doctors')
        .where('hospital', isGreaterThanOrEqualTo: query)
        .where('hospital', isLessThan: query + 'z')
        .get()
        .then((querySnapshot) {
      setState(() {
        _searchResults.addAll(querySnapshot.docs
            .map((doc) => DoctorModel.fromSnapshot(doc))
            .toList());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for doctors, specialties, or hospitals',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _performSearch(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                _performSearch(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return DoctorListTile(doctor: _searchResults[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}