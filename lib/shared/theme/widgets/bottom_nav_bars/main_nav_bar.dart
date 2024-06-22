import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({Key? key}) : super(key: key);

  @override
  _MainNavBarState createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SalomonBottomBar(
      selectedItemColor: colorScheme. primary,
      unselectedItemColor: colorScheme.onSurface.withOpacity(0.5) ,
      onTap: (index) {
        switch (index) {
          case 0:
            print(index);
            break;
          case 1:
            print(index);
            break;
        default:
        }
      },
      items: [
         SalomonBottomBarItem(
          icon:  Icon(Icons.home),
          title:  Text("Discover"),
          selectedColor: colorScheme.primary,
        ),
        SalomonBottomBarItem(
          icon: Icon(Icons.explore_outlined),
          title: Text("Explore"),
          selectedColor: colorScheme.primary,
        ),
        SalomonBottomBarItem(
          icon: Icon(Icons.chat_outlined),
          title: Text("Booking"),
          selectedColor: colorScheme.primary,
        ),
        SalomonBottomBarItem(
          icon: Icon(Icons.chat),
          title: Text("Chat"),
          selectedColor: colorScheme.primary,
        ),
      ],
    );
  }
}
