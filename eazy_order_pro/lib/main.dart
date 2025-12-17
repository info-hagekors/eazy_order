
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app.dart';
import 'core/config/controller_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final uri = Uri.base;
  final businessId = uri.queryParameters['id'] ?? '';
  AppConsts.setBusinessId = businessId;
  runApp(ProviderScope(observers: [ControllerObserver()],child: const App(),));
}
