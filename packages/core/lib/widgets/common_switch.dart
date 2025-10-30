
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonSwitch extends StatelessWidget {
  const CommonSwitch({super.key, required this.value,
    required this.onChanged,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.trackOutlineColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? trackOutlineColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      width: 50.w,
      child: FittedBox(
        fit: BoxFit.contain,
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: activeTrackColor,
          inactiveTrackColor: inactiveTrackColor,
          trackOutlineColor: WidgetStateProperty.all(trackOutlineColor),
        ),
      ),
    );
  }
}
