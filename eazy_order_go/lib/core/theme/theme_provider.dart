import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod StateProvider for ThemeMode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
