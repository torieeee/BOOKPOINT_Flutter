/*import 'package:flutter/material.dart';
import 'package:book_point/main.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_point/providers/dio_provider.dart';
import 'package:book_point/utils/config.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});
  final Map<String, dynamic> patient;
  final Color color;

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child:Column(
        children: <Widget>[
          Row(
            children: [
              const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Dr ${widget.patient['doctor_name']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      
                    ],
                  ),

          ],),
          
          Config.spaceSmall,
              //Schedule info here
              ScheduleCard(
                appointment: widget.patient['appointments'],
              ),
              Config.spaceSmall,
              //action button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return RatingDialog(
                                  initialRating: 1.0,
                                  title: const Text(
                                    'Rate your Experience with the patient',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  message: const Text(
                                    'Give a review',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  image: const FlutterLogo(
                                    size: 100,
                                  ),
                                  submitButtonText: 'Submit',
                                  commentHint: 'Your Reviews',
                                  onSubmitted: (response) async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    final token =
                                        prefs.getString('token') ?? '';

                                    final rating = await DioProvider()
                                        .storeReviews(
                                            response.comment,
                                            response.rating,
                                            widget.doctor['appointments']
                                                ['id'], //this is appointment id
                                            widget.doctor[
                                                'doc_id'], //this is doctor id
                                            token);

                                    //if successful, then refresh
                                    if (rating == 200 && rating != '') {
                                      MyApp.navigatorKey.currentState!
                                          .pushNamed('main');
                                    }
                                  });
                            });
                      },
                      child: const Text(
                        'Completed',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
        ],),
    );
  }
}*/