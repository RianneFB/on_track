import 'package:get/get.dart';
import 'package:on_track/bindings/data_binding.dart';
import 'package:on_track/bindings/view_binding.dart';
import 'package:on_track/screens/signup.dart';
import 'package:on_track/screens/splash.dart';
import 'package:on_track/screens/start_app.dart';

final List<GetPage> appScreens = [
  GetPage(name: '/splash', page: () => SplashScreen()),
  GetPage(name: '/auth', page: () => SignUpForm(), bindings: [DataBinding()]),
  GetPage(
    name: '/home',
    page: () => StartApp(),
    bindings: [ViewBinding(), DataBinding()],
  ),
];
