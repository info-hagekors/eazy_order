
import 'package:flutter/material.dart';

class AppConsts {

  AppConsts(this.context);

  BuildContext context;
  static double _bottomPadding = 0;

  static final String _encryptionKey = 'f3a2c5d984e71b0c47fa92eb8a7c4d63';

  void init() {
    _bottomPadding = MediaQuery.of(context).viewPadding.bottom;
  }

  static double get bottomPadding => _bottomPadding;

  static String get encryptionKey => _encryptionKey;
}