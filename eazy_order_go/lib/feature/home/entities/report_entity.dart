
import 'package:core/core.dart';

class ReportEntity {
  final ReportModel reportModel;
  final bool isLoading;

  ReportEntity({
    required this.reportModel,
    this.isLoading = false,
  });

  ReportEntity copyWith({ ReportModel? reportModel, bool? isLoading }) {
    return ReportEntity(
      reportModel: reportModel ?? this.reportModel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}