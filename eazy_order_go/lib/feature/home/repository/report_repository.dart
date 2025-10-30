
import 'package:eazy_order_go/core/services/firestore_service.dart';
import 'package:core/core.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class ReportRepository {

  final FirestoreService _firestoreService;

  ReportRepository(this._firestoreService);

  Future<ReportModel> getTodaySReport() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final result = await _firestoreService.getTodaySReportSnapshot(
        FirestoreService.collectionReports, '2025-06-12'
        //FirestoreService.collectionReports, today
    );
    final reportData = ReportModel.fromJson(result);
    return reportData;
  }
}

// Auth Repository provider
final reportRepositoryProvider = Provider((ref) => ReportRepository(ref.read(firestoreServiceProvider)));
