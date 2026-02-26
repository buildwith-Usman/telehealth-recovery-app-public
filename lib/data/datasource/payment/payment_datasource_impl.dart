import 'package:recovery_consultation_app/data/datasource/payment/payment_datasource.dart';

import '../../api/api_client/api_client_type.dart';

class PaymentDatasourceImpl implements PaymentDatasource {
  PaymentDatasourceImpl({
    required this.apiClient,
  });

  final APIClientType apiClient;
}
