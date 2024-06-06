import 'package:book_point/screens/appointment_page.dart';
import 'package:book_point/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentPage = 0;
  final PageController _page = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value){
          setState(() {
            currentPage = value;
          });
        }),
        children: const <Widget>[
          HomeView(),
          AppointmentPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page){
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
            icon: Icon(FontAwesomeIcons.houseChimneyMedical),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidCalendarCheck),
            label: 'Appointments',
          ),
        ],
      ),
    );
  }
}