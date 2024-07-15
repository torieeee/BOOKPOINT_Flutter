import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/doctor_card.dart';


class SearchPage extends StatefulWidget {
  final String? initialQuery;

  const SearchPage({Key? key, this.initialQuery}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _performSearch(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Doctors')
          .where('doc_type', isEqualTo: query)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no exact match for doc_type, perform a more general search
        final generalQuerySnapshot = await FirebaseFirestore.instance
            .collection('Doctors')
            .where('doc_name', isGreaterThanOrEqualTo: query.toLowerCase())
            .where('doc_name', isLessThan: query.toLowerCase() + 'z')
            .get();

        final doctorTypeSnapshot = await FirebaseFirestore.instance
            .collection('Doctors')
            .where('doc_type', isGreaterThanOrEqualTo: query.toLowerCase())
            .where('doc_type', isLessThan: query.toLowerCase() + 'z')
            .get();

        final hospitalSnapshot = await FirebaseFirestore.instance
            .collection('Doctors')
            .where('hospital', isGreaterThanOrEqualTo: query.toLowerCase())
            .where('hospital', isLessThan: query.toLowerCase() + 'z')
            .get();

        setState(() {
          _searchResults = [
            ...generalQuerySnapshot.docs.map((doc) => doc.data()),
            ...doctorTypeSnapshot.docs.map((doc) => doc.data()),
            ...hospitalSnapshot.docs.map((doc) => doc.data()),
          ];
        });
      } else {
        setState(() {
          _searchResults = querySnapshot.docs.map((doc) => doc.data()).toList();
        });
      }

      _isLoading = false;
    } catch (e) {
      print('Error performing search: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(child: Text('No results found'))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return DoctorCard(
                            doctor: _searchResults[index],
                            isFav: false,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}