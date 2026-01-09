
import 'package:core/core.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils
{
  static void success(String message) {
    Fluttertoast.showToast(
      msg: message,
      webShowClose: true,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: AppColors.verifyGreen
    );
  }

  static void error(String message) {
    Fluttertoast.showToast(
        msg: message,
        webShowClose: true,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 8,
        backgroundColor: AppColors.error,
        webBgColor: 'linear-gradient(to right, #D32F2F, #EF5350)',
        webPosition: 'center'
        //gravity: ToastGravity.TOP_RIGHT
    );
  }
}