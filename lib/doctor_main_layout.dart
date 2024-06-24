// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// import 'doctor_section/doctor_home.dart';

// class DoctorMainLayout extends StatefulWidget {
//   const DoctorMainLayout({super.key});

//   @override
//   State<DoctorMainLayout> createState() => _DoctorMainLayoutState();
// }

// class _DoctorMainLayoutState extends State<DoctorMainLayout> {
//   int currentPage=0;
//   final PageController _page=PageController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:PageView(
//         controller: _page,
//         onPageChanged: ((value){
//           setState((){
//             currentPage=value;
//           });
//         }),
//         children: <Widget>[
//           const DoctorHome(),
//           RequestPage(),
//           DoctorProfile(),

//         ],
//       )
//       bottomNavigationBar: DoctorNavBar(
//         currentIndex:currentPage,
//         onTap:(page){
//           setState((){
//             currentPage=page;
//             _page.animateToPage(
//               page,
//                duration: const Duration(milliseconds:500),
//                 curve: Curves.easeInOut,
//                 );
//           });
//         },
//         items:const <DoctorNavBarItem>[
//           BottomNavigation
//         ]
//       ),
//     );
//   }
// }