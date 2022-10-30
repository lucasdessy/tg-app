import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/media/medias_cubit.dart';
import 'package:sales_platform_app/application/user/user_cubit.dart';
import 'package:sales_platform_app/presentation/home/home_page.dart';
import 'package:sales_platform_app/presentation/media/medias_page.dart';
import 'package:sales_platform_app/presentation/profile/profile_page.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';
import 'package:sales_platform_app/presentation/shared/widgets/profile_header.dart';
import 'package:sales_platform_app/presentation/training/trainings_page.dart';

import '../../application/home/home_cubit.dart';
import '../../application/training/trainings_cubit.dart';
import '../../application/user/profile_medias_cubit.dart';
import '../../injection.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({Key? key}) : super(key: key);

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int currentIndex = 0;

  @override
  void initState() {
    _pages = [
      HomePage(
        onTap: toggleIndex,
      ),
      const TrainingsPage(),
      const MediasPage(),
      const ProfilePage(),
    ];
    super.initState();
  }

  void toggleIndex(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
  }

  late final List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<MediasCubit>()..getMedias(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => getIt<TrainingsCubit>()..getTrainings(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => getIt<UserCubit>()..getUser(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => getIt<ProfileMediasCubit>()..loadPictures(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => getIt<HomeCubit>(),
          ),
        ],
        child: Stack(
          children: [
            _pages[currentIndex],
            if (currentIndex != 3)
              ProfileHeader(
                onTap: () => toggleIndex(3),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: toggleIndex,
        fixedColor: SharedConfigs.colors.secondary,
        unselectedItemColor:
            SharedConfigs.whitenColor(SharedConfigs.colors.secondary),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1 ? Icons.school : Icons.school_outlined,
            ),
            label: 'Treinamento',
          ),
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 2
                ? Icons.local_movies
                : Icons.local_movies_outlined),
            label: 'Midias',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3 ? Icons.person : Icons.person_outline,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
