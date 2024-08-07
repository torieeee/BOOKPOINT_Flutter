import 'package:book_point/doctor_section/doctor_home.dart';
import 'package:book_point/doctor_section/doctor_profile.dart';
import 'package:book_point/doctor_section/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorMainLayout extends StatefulWidget {
  const DoctorMainLayout({super.key});

  @override
  State<DoctorMainLayout> createState() => _DoctorMainLayoutState();
 }

class _DoctorMainLayoutState extends State<DoctorMainLayout> {
  int currentPage=0;
  final PageController _page=PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:PageView(
        controller: _page,
        onPageChanged: ((value){
          setState((){
            currentPage=value;
          });
        }),
        children: <Widget>[
          const DoctorHome(),
        const RequestPage(),
          DoctorUserPage(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _page.animateToPage(
              page,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidUser),
            label: 'Profile',
          ),
        ]
      ),
    );
  }
}