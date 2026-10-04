import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/subscription_entity.dart';

abstract class ISubscriptionApiDataSource {
  Future<SubscriptionEntity> getSubscription();
}

class SubscriptionApiDataSource implements ISubscriptionApiDataSource {
  final DioClient _dioClient;

  SubscriptionApiDataSource(this._dioClient);

  @override
  Future<SubscriptionEntity> getSubscription() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.subscription,
    );
    final data = response.data ?? <String, dynamic>{};
    return SubscriptionEntity.fromJson(data);
  }
}

final subscriptionApiDataSourceProvider = Provider<ISubscriptionApiDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SubscriptionApiDataSource(dioClient);
});
