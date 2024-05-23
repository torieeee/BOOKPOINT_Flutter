import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFFFFFFFF),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8.0),
            Text(
              'Welcome',
              style: GoogleFonts.sora(
                textStyle: textTheme.bodyMedium,
              ), 
            ),
            Text(
              'Sean',
              style: GoogleFonts.sora(
              textStyle: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize:20 ),
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  'Nairobi, Kenya',
                  style: GoogleFonts.sora(
                  textStyle: textTheme.bodySmall,
                  )
                ),
                const SizedBox(height: 4.0),
                Icon(
                  Icons.expand_more,
                  color: colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            ),
            const SizedBox(width: 8.0),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: GoogleFonts.spaceGrotesk(),
              decoration: InputDecoration(
                hintText: 'Search for doctors...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Container(
                  margin:EdgeInsets.all(4.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Icon(Icons.filter_alt_outlined),
                ),
              ),
            ),
            )
          ),
      ),
    );
  }
}
