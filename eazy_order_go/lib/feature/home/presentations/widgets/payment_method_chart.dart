
import 'package:core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodChart extends StatefulWidget {
  const PaymentMethodChart({super.key, required this.paymentMethodSummary});

  final Map<String, dynamic> paymentMethodSummary;

  @override
  State<StatefulWidget> createState() => PaymentMethodChartState();
}

class PaymentMethodChartState extends State<PaymentMethodChart> {
  int touchedIndex = -1;

  Map<String, dynamic> get summary => widget.paymentMethodSummary;

  @override
  Widget build(BuildContext context) {
    final colorMap = {
      'online': AppColors.confirm,
      'cash': AppColors.placed,
      // Add more if needed
    };
    final total = summary.values.fold(0.0, (a, b) => a + b);
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 80,
                      //sections: showingSections(),
                      sections: buildPaymentSummarySections(summary, touchedIndex),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        total.toInt().toString(),
                        style: GoogleFonts.nunito(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black
                        ),
                      ),
                      Text(
                        'Total',
                        style: GoogleFonts.nunito(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 12.w, ),
        Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
              children: summary.keys.map((method) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Indicator(
                    color: colorMap[method.toLowerCase()] ?? Colors.grey,
                    text: method[0].toUpperCase() + method.substring(1), // Capitalize
                    isSquare: false,
                  ),
                );
              }).toList(),
          ),
          SizedBox(width: 12.w, ),
        ],
      ),
    );
  }

  List<PieChartSectionData> buildPaymentSummarySections(Map<String, dynamic> paymentSummary, int touchedIndex) {
    final total = paymentSummary.values.fold(0.0, (a, b) => a + b);
    final shadows = [const Shadow(color: Colors.black, blurRadius: 2)];

    final colorMap = {
      'online': AppColors.confirm,
      'cash': AppColors.placed,
      // add more mappings as needed
    };

    int index = 0;
    return paymentSummary.entries.map((entry) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 14.0 : 10.0;
      final radius = isTouched ? 50.0 : 30.0;

      final percentage = total == 0 ? 0 : ((entry.value / total) * 100).toStringAsFixed(0);

      final section = PieChartSectionData(
        color: colorMap[entry.key.toLowerCase()] ?? Colors.grey,
        value: double.parse((entry.value ?? 0).toString()),
        title: '${entry.value} ($percentage%)',
        radius: radius,
        titleStyle: GoogleFonts.nunito(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
          shadows: shadows,
        ),
      );
      index++;
      return section;
    }).toList();
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: GoogleFonts.nunito(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: textColor
          ),
        )
      ],
    );
  }
}