
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class LoanRepository {
  final Dio _dio = ApiClient.dio;

  Future<Response> createLoan({
    required double principalAmount,
    required int tenure,
    required String purpose,
  }) async {
    return await _dio.post(
      '/loans',
      data: {
        'principalAmount': principalAmount,
        'tenure': tenure,
        'purpose': purpose,
      },
    );
  }

Future<Response> calculateOffer({
  required double principalAmount,
  required int tenure,
  required String purpose,
}) async {
  return await _dio.post(
    '/loans/calculate',
    data: {
      'principalAmount': principalAmount,
      'tenure': tenure,
      'purpose': purpose,
    },
  );
}

Future<Response> acceptOffer({
  required double principalAmount,
  required int tenure,
  required String purpose,
}) async {
  return await _dio.post(
    '/loans/accept',
    data: {
      'principalAmount': principalAmount,
      'tenure': tenure,
      'purpose': purpose,
    },
  );
}
Future<Response> getMyLoans() async {
  return await _dio.get('/loans/my-loans');
}

Future<Response> updateLoanStatus({
  required String loanId,
  required String status,
}) async {
  return await _dio.patch(
    '/loans/$loanId/status',
    data: {'status': status},
  );
}

}
