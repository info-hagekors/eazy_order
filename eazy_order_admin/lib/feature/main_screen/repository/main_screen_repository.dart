
import 'package:core/core.dart';
import 'package:either_dart/either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class MainScreenRepository {

  final BusinessService _businessService;

  MainScreenRepository(this._businessService);

  Future<Either<String, BusinessModel>> getBusinessDetails(String businessId) async {
    final result = await _businessService.getBusinessById(businessId);
    return result;
  }
}

// Repository provider
final mainScreenRepositoryProvider = Provider((ref) => MainScreenRepository(
    ref.read(businessServiceProvider))
);
