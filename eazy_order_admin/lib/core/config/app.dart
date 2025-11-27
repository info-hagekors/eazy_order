
import 'package:core/core.dart';
import 'package:eazy_order_admin/constants.dart';
import 'package:eazy_order_admin/core/services/firebase_notification_service.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:eazy_order_admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {

  late Future<FirebaseApp> _firebaseInitFuture;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _firebaseInitFuture = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    AppConsts(context).init();

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (_, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return FutureBuilder(
              future: _firebaseInitFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return MaterialApp.router(
                  title: 'Admin | Eazy Order',
                  debugShowCheckedModeBanner: false,
                  supportedLocales: [
                    Locale('en', ''),
                  ],
                  locale: Locale('en', ''), // Default Language
                  theme: ThemeData.dark().copyWith(
                    scaffoldBackgroundColor: AppColors.black12,
                    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
                    canvasColor: AppColors.accentColor,
                    primaryColor: AppColors.primaryColor
                  ),
                  routerConfig: goRouter,
                );
              }
            );
          },
        );
      },
    );
  }

  Future<void> initializeFCM() async {
    await FirebaseNotificationService.initialize();
  }
}

