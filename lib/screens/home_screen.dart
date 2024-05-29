
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import ''
import '../shared/theme/widgets/avatars/circle_avatar_with_text_label.dart';
import '../shared/theme/widgets/titles/section_title.dart';

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
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: const Icon(Icons.filter_alt_outlined),
                ),
              ),
            ),
            )
          ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
            children: [
              _DoctorCategories(),
              SizedBox(height: 16.0),
              _MySchedule(),
            ],
          ),
        ),
    );
  }
}

class _MySchedule extends StatelessWidget {
  const _MySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: 'My Sce',
          action: 'See all',
          onPressed: () {},
          ),
      ],
    );
  }
}

class _DoctorCategories extends StatelessWidget{
  const _DoctorCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: 'Categories',
          action: 'See all',
          onPressed: () {},
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: DoctorCategory.values
              .take(5)
              .map<Widget>(
                (category) => Expanded(
                  child: CircleAvatarWithTextLabel(
                  icon: category.icon,
                  label: category.name,
                ),
              ),
            )
          .toList(),
        ),
      ],
    );
  }
}