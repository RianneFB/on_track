import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_track/controllers/data_controller.dart';
import 'package:on_track/controllers/view_controller.dart';
import 'package:on_track/models/user.dart';
import 'package:on_track/screens/onboarding.dart';
import 'package:on_track/screens/profile.dart';
import 'package:on_track/screens/splash.dart';
import 'package:on_track/screens/todo.dart';

class StartApp extends StatefulWidget {
  const StartApp({super.key, this.afterAppLaunch = false});

  final bool afterAppLaunch;

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  final ViewController _viewController = Get.put(ViewController());
  final DataController _dataController = Get.put(DataController());
  int _selectedIndex = 0;
  final Widget _loadingScreen = const Scaffold(
    body: Center(child: CircularProgressIndicator.adaptive()),
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _dataController.deserializeTODO();
    _dataController.getUser();
  }

  Widget _getScreen(AppUser? user) {
    if (user == null) {
      if (_dataController.user != null) {
        return _loadingScreen;
      } else {
        return const OnboardingScreen();
      }
    } else {
      return Scaffold(
        body:
            _selectedIndex == 0
                ? TodoScreen(
                  viewController: _viewController,
                  dataController: _dataController,
                )
                : ProfileScreen(dataController: _dataController),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todos'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _dataController.loaded.value ? home() : const SplashScreen();
    });
  }

  Widget home() {
    _dataController.getUser();
    return _getScreen(_dataController.user);
  }
}
