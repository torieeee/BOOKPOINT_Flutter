import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/doctor_details.dart';
import '../utils/config.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.isFav,
  }) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.doctor['profile_image'] != null) {
      final ref = FirebaseStorage.instance.ref(widget.doctor['profile_image']);
      try {
        final url = await ref.getDownloadURL();
        setState(() {
          imageUrl = url;
        });
      } catch (e) {
        print('Failed to load image: $e');
        // Handle error loading image, set default image
        setState(() {
          imageUrl = 'assets/default.jpg'; // Use local asset path
        });
      }
    } else {
      setState(() {
        imageUrl = 'assets/default.jpg'; // Use local asset path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.fill,
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Dr ${widget.doctor['doc_name']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.doctor['doc_type']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            Icons.star_border,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          const Spacer(flex: 1),
                          Text(widget.doctor['rating']?.toString() ?? '4.5'),
                          const Spacer(flex: 1),
                          const Text('Reviews'),
                          const Spacer(flex: 1),
                          Text('(${widget.doctor['reviews']?.toString() ?? '20'})'),
                          const Spacer(flex: 7),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          // Pass the details to detail page
          MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (_) => DoctorDetails(
                    doctor: widget.doctor,
                    isFav: widget.isFav,
                  )));
        },
      ),
    );
  }
}
