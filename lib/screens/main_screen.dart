import 'package:flutter/material.dart';
import 'package:Flutter_Project_Sori/screens/add.dart';
import 'package:Flutter_Project_Sori/screens/home.dart';
import 'package:Flutter_Project_Sori/screens/label.dart';
import 'package:Flutter_Project_Sori/screens/profile.dart';
import 'package:Flutter_Project_Sori/services/firebase_messing.dart';
import 'notifications.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;
  int _page = 0;

  final List<IconData> icons = [
    Icons.home,
    Icons.label,
    Icons.add,
    Icons.notifications,
    Icons.person,
  ];

  final List<Widget> pages = const [
    Home(),
    Label(),
    Add(),
    Notifications(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() => _page = page);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: BottomAppBar(
        color: colorScheme.primary,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildTabIcon(0, colorScheme, textTheme),
            buildTabIcon(1, colorScheme, textTheme),
            const SizedBox(width: 40), // Chừa chỗ cho FAB
            buildTabIcon(3, colorScheme, textTheme),
            buildTabIcon(4, colorScheme, textTheme),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(), // 👈 ép tròn
        onPressed: () => _pageController.jumpToPage(2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildTabIcon(int index, ColorScheme colorScheme, TextTheme textTheme) {
    final bool isSelected = _page == index;

    return IconButton(
      icon: Icon(icons[index], size: 24.0),
      color: isSelected
          ? colorScheme.background
          : textTheme.bodySmall?.color?.withOpacity(0.7),
      onPressed: () => _pageController.jumpToPage(index),
    );
  }
}
