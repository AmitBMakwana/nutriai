import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/subscription_entity.dart';
import '../datasources/subscription_api_datasource.dart';

abstract class ISubscriptionRepository {
  Future<SubscriptionEntity> getSubscription();
}

class SubscriptionRepository implements ISubscriptionRepository {
  final ISubscriptionApiDataSource _dataSource;

  SubscriptionRepository(this._dataSource);

  @override
  Future<SubscriptionEntity> getSubscription() => _dataSource.getSubscription();
}

final subscriptionRepositoryProvider = Provider<ISubscriptionRepository>((ref) {
  final dataSource = ref.watch(subscriptionApiDataSourceProvider);
  return SubscriptionRepository(dataSource);
});
