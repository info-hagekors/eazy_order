import 'package:core/core.dart';
import 'package:eazy_order_go/core/services/firebase_notification_service.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme_provider.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    initializeFCM();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppConsts(context).init();
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp.router(
          title: 'Eazy Order Seller',
          debugShowCheckedModeBanner: false,
          supportedLocales: const [Locale('en', '')],
          locale: const Locale('en', ''),
          routerConfig: goRouter,

          // ✅ Add theme modes here
          themeMode: themeMode,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
            brightness: Brightness.light,
            primaryColor: AppColors.primaryColor,
            scaffoldBackgroundColor: AppColors.imageBgColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primaryColor,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Future<void> initializeFCM() async {
    await FirebaseNotificationService.initialize();
  }
}
