
import 'package:eazy_order_go/feature/home/entities/report_entity.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/repository/report_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class ReportController extends _$ReportController {

  @override
  ReportEntity build() {
    ref.keepAlive();
    return ReportEntity(reportModel: ReportModel.fromJson({}));
  }

  void getTodaySReport() async {
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.copyWith(isLoading: true);
    final reportData = await ref.read(reportRepositoryProvider).getTodaySReport();
    state = state.copyWith(reportModel: reportData, isLoading: false);
  }
}
