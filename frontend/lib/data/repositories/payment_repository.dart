
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class PaymentRepository {
  final Dio _dio = ApiClient.dio;

  // Create Razorpay order through backend
  Future<Response> createPaymentOrder({
    required String loanId,
  }) async {
    return await _dio.post(
      '/payments/create-order',
      data: {
        'loanId': loanId,
      },
    );
  }

  // Verify Razorpay payment through backend
  Future<Response> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    return await _dio.post(
      '/payments/verify',
      data: {
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      },
    );
  }
}
