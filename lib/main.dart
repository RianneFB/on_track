import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:on_track/bindings/view_binding.dart';
import 'package:on_track/controllers/view_controller.dart';
import 'package:on_track/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late List<ThemeData> _themes;
  final ViewController _viewController = Get.put(ViewController());

  @override
  void initState() {
    super.initState();
    _generateThemes();
  }

  void _generateThemes() {
    final themes = <ThemeData>[];
    for (final brightness in {Brightness.light, Brightness.dark}) {
      themes.add(
        ThemeData(
          brightness: brightness,
          colorSchemeSeed: const Color.fromARGB(255, 107, 28, 253),
          textTheme: GoogleFonts.geologicaTextTheme(
            const TextTheme(
              headlineLarge: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    }
    _themes = themes;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Obx(() {
      final brightness = _viewController.state.value;
      final themeMode = switch (brightness) {
        Brightness.light => ThemeMode.light,
        Brightness.dark => ThemeMode.dark,
      };
      return GetMaterialApp(
        title: "On Track",
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: _themes[0],
        darkTheme: _themes[1],
        initialRoute: '/home',
        initialBinding: ViewBinding(),
        getPages: appScreens,
      );
    });
  }
}
