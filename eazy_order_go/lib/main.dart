import 'package:eazy_order_go/core/config/app.dart';
import 'package:eazy_order_go/core/config/controller_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(observers: [ControllerObserver()],child: const App(),));
}
