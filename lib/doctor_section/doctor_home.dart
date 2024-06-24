import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
//import 'requests.dart';
//import '../components/doctor_card.dart';
import '../models/auth_model.dart';
import '../utils/config.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  late Map<String,dynamic> user;
  late Map<String,dynamic> request;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body:user.isEmpty
      ?const Center(
        child:CircularProgressIndicator() ,
        )
        : Padding(padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              
          children: [],),),),)
    );
  }
}