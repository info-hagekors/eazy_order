import 'package:eazy_order_go/core/services/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class HomeRepository {

  final FirestoreService _firestoreService;

  HomeRepository(this._firestoreService);
}

// Auth Repository provider
final homeRepositoryProvider = Provider((ref) => HomeRepository(ref.read(firestoreServiceProvider)));
