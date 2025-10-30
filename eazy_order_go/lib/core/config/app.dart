import 'package:core/core.dart';
import 'package:eazy_order_go/core/services/firebase_notification_service.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp.router(
          title: 'Eazy Order Seller',
          debugShowCheckedModeBanner: false,
          supportedLocales: [
            Locale('en', ''),
          ],
          /*localizationsDelegates: [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],*/
          locale: Locale('en', ''), // Default Language
          theme: ThemeData(primaryColor: AppColors.primaryColor),
          routerConfig: goRouter,
        );
      },
    );
  }

  Future<void> initializeFCM() async {
    await FirebaseNotificationService.initialize();
  }
}

