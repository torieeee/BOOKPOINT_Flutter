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
  String _errorMessage = '';

  
  

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
    _errorMessage = '';
    _searchResults = [];
  });

  try {
    print('Performing search with query: $query'); // Debug print

    // Fetch all doctors
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Doctors')
        .get();

    print('Total doctors fetched: ${querySnapshot.docs.length}'); // Debug print

    // Filter doctors locally
    _searchResults = querySnapshot.docs
        .map((doc) => doc.data())
        .where((data) {
          final docName = (data['doc_name'] ?? '').toString().toLowerCase();
          final docType = (data['doc_type'] ?? '').toString().toLowerCase();
          final hospital = (data['hospital'] ?? '').toString().toLowerCase();
          final lowercaseQuery = query.toLowerCase();

          return docName.contains(lowercaseQuery) ||
              docType.contains(lowercaseQuery) ||
              hospital.contains(lowercaseQuery);
        })
        .toList();

    setState(() {
      _isLoading = false;
    });

    print('Filtered search results: ${_searchResults.length}'); // Debug print
    _searchResults.forEach((result) {
      print('Doctor: ${result['doc_name']}, Type: ${result['doc_type']}, Hospital: ${result['hospital']}');
    });

  } catch (e) {
    print('Error performing search: $e');
    setState(() {
      _isLoading = false;
      _errorMessage = 'An error occurred while searching. Please try again.';
    });
  }
}
  @override
  Widget build(BuildContext context) {
    print('Building SearchPage. Results count: ${_searchResults.length}');
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