
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/applications/report_controller.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/payment_method_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {

  @override
  void initState() {
    ref.read(reportControllerProvider.notifier).getTodaySReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 18.h,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's Report",
                  style: GoogleFonts.nunito(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 16.h,),
              Row(
                children: [
                  Expanded(child: _commonNumberBox('Total Sales', '${AppConsts.currencySymbol} ${state.reportModel.totalSales.toString()}')),
                  SizedBox(width: 16.w,),
                  Expanded(child: _commonNumberBox('Total Orders', state.reportModel.totalOrders.toString())),
                ],
              ),
              SizedBox(height: 16.h,),
              _commonChartBox('Payments', state.reportModel.paymentMethodSummary),
              SizedBox(height: 16.h,),
              _commonListBox('Top 3 Items', state.reportModel.top3Items),
              /*SizedBox(height: 16.h,),
              _commonListBox('Bottom 3 Items', state.reportModel.bottom3Items),*/
              SizedBox(height: 16.h,),
              _commonListBox('Top 3 Category', state.reportModel.top3Categories),
              SizedBox(height: 32.h,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commonNumberBox(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.background2
        )
      ),
      child: Column(
        children: [
          Container(
            height: 45.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
              color: AppColors.bgColor2,
            ),
            child: Text(
              title,
              style: GoogleFonts.nunito(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black
              ),
            ),
          ),
          Container(
            height: 1.h,
            color: AppColors.background2,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.imageBgColor.withAlpha(25),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
            child: Text(
              value,
              style: GoogleFonts.nunito(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _commonListBox(String title, List<Item> items) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              color: AppColors.background2
          )
      ),
      child: Column(
        children: [
          Container(
            height: 50.h,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
              color: AppColors.bgColor2,
            ),
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    title,
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Qty',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Amt',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1.h,
            color: AppColors.background2,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.imageBgColor.withAlpha(25),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
            ),
            child: items.isNotEmpty ? ListView.builder(
              itemCount: items.length > 2 ? 3 : items.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  height: 50.h,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r),
                    ),
                    border: Border(
                      bottom:  BorderSide(
                        color: AppColors.background2,
                        width: 0.74.h
                      )
                    )
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          item.name,
                          style: GoogleFonts.nunito(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.orders.toString(),
                          style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.revenue.toString(),
                          style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ) : Container(
              height: 150.h,
              alignment: Alignment.center,
              child: Text(
                'No Data',
                style: GoogleFonts.nunito(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _commonChartBox(String title, Map<String, dynamic> paymentMethodSummary) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              color: AppColors.background2
          )
      ),
      child: Column(
        children: [
          Container(
            height: 45.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
              color: AppColors.bgColor2,
            ),
            child: Text(
              title,
              style: GoogleFonts.nunito(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black
              ),
            ),
          ),
          Container(
            height: 1.h,
            color: AppColors.background2,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.imageBgColor.withAlpha(25),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: PaymentMethodChart(paymentMethodSummary: paymentMethodSummary,),
          ),
        ],
      ),
    );
  }
}