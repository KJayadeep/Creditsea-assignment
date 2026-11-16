import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/services/storage_service.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../services/razorpay_web_service.dart';
import '../views/payment_success_view.dart';

class PaymentController extends GetxController {
  final PaymentRepository _paymentRepository = PaymentRepository();

  Razorpay? _razorpay;
  final loan = <String, dynamic>{}.obs;

  final isLoading = false.obs;
  final isVerifying = false.obs;
  final paymentStatus = ''.obs;

  double get totalPayable =>
      (loan['totalPayable'] as num?)?.toDouble() ?? 0.0;

  String get loanId =>
      (loan['_id'] ?? loan['id'])?.toString() ?? '';

  @override
  void onInit() {
    super.onInit();
    loadLoanArguments(Get.arguments);

    if (!kIsWeb) {
      _razorpay = Razorpay();

      _razorpay!.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        _handlePaymentSuccess,
      );

      _razorpay!.on(
        Razorpay.EVENT_PAYMENT_ERROR,
        _handlePaymentError,
      );

      _razorpay!.on(
        Razorpay.EVENT_EXTERNAL_WALLET,
        _handleExternalWallet,
      );
    }
  }

  void loadLoanArguments(dynamic arguments) {
    if (arguments is Map) {
      loan.assignAll(Map<String, dynamic>.from(arguments));
      debugPrint('[PaymentController] Loaded loan: $loanId, total: $totalPayable');
    }
  }

  // Start payment process
  Future<void> payLoanAmount() async {
    if (isLoading.value || isVerifying.value) return;

    debugPrint('[Payment] Pay tapped for loanId: "$loanId", totalPayable: $totalPayable');

    if (loanId.isEmpty || totalPayable <= 0) {
      Get.snackbar(
        'Error',
        'Invalid loan details for repayment',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _paymentRepository.createPaymentOrder(
        loanId: loanId,
      );

      final data = response.data;
      final order = data['order'];
      final keyId = data['keyId']?.toString() ?? '';

      final options = {
        'key': keyId,
        'amount': order['amount'],
        'currency': order['currency'] ?? 'INR',
        'order_id': order['id'],
        'name': 'CreditSea',
        'description': 'Loan Repayment #${loan['applicationNumber'] ?? ''}',
        'prefill': {
          'contact': loan['phone']?.toString() ?? '',
          'email': loan['email']?.toString() ?? '',
        },
        'theme': {
          'color': '#087AFF',
        },
      };

      isLoading.value = false;

      if (kIsWeb) {
        debugPrint('[Payment] Opening Razorpay Checkout on Web...');
        openRazorpayWebCheckout(
          options: options,
          onSuccess: (orderId, paymentId, signature) {
            debugPrint('[Payment] Web payment success callback received: $paymentId');
            _verifyPayment(
              orderId: orderId,
              paymentId: paymentId,
              signature: signature,
            );
          },
          onFailure: (error) {
            isLoading.value = false;
            isVerifying.value = false;
            debugPrint('[Payment] Web payment failed: $error');
            Get.snackbar(
              'Payment Failed',
              error,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          onDismiss: () {
            isLoading.value = false;
            isVerifying.value = false;
            debugPrint('[Payment] Web payment checkout dismissed');
            Get.snackbar(
              'Payment Cancelled',
              'Payment checkout was cancelled',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        );
      } else {
        debugPrint('[Payment] Opening Razorpay Native Checkout on Mobile...');
        _razorpay?.open(options);
      }
    } on DioException catch (error) {
      isLoading.value = false;

      final data = error.response?.data;
      final message = data is Map
          ? data['message']?.toString() ?? 'Unable to create payment order'
          : 'Unable to create payment order';

      debugPrint('[Payment] Create order API error: $message');

      Get.snackbar(
        'Payment Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      isLoading.value = false;
      debugPrint('[Payment] Initiate payment error: $error');

      Get.snackbar(
        'Error',
        'Unable to initiate payment: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Razorpay success callback (Mobile)
  Future<void> _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    final orderId = response.orderId;
    final paymentId = response.paymentId;
    final signature = response.signature;

    if (orderId == null || paymentId == null || signature == null) {
      Get.snackbar(
        'Verification Error',
        'Payment details are incomplete',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await _verifyPayment(
      orderId: orderId,
      paymentId: paymentId,
      signature: signature,
    );
  }

  // Verify payment with backend
  Future<void> _verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    isVerifying.value = true;

    try {
      final response = await _paymentRepository.verifyPayment(
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
      );

      if (response.data['success'] == true) {
        paymentStatus.value = 'Paid';

        // Update local loan map status to Repaid
        loan['status'] = 'Repaid';

        final appNum = loan['applicationNumber']?.toString() ?? '';
        if (appNum.isNotEmpty && Get.isRegistered<StorageService>()) {
          try {
            final storage = Get.find<StorageService>();
            await storage.saveLoanProgress(appNum, 6);
          } catch (_) {}
        }

        // Refresh dashboard loans if dashboard is in memory
        if (Get.isRegistered<DashboardController>()) {
          try {
            Get.find<DashboardController>().fetchLoans();
          } catch (_) {}
        }

        final payment = Map<String, dynamic>.from(
          response.data['payment'],
        );

        Get.off(
          () => PaymentSuccessView(),
          arguments: payment,
          transition: Transition.rightToLeft,
        );
      } else {
        Get.snackbar(
          'Verification Notice',
          response.data['message']?.toString() ?? 'Payment verification failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (error) {
      final data = error.response?.data;
      final message = data is Map
          ? data['message']?.toString() ?? 'Payment verification failed'
          : 'Payment verification failed';

      Get.snackbar(
        'Verification Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      debugPrint('[Payment] Verify payment error: $error');
      Get.snackbar(
        'Error',
        'Unable to verify payment. Please check your transaction.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isVerifying.value = false;
    }
  }

  // Payment failure callback (Mobile)
  void _handlePaymentError(PaymentFailureResponse response) {
    isLoading.value = false;
    isVerifying.value = false;

    Get.snackbar(
      'Payment Failed',
      response.message ?? 'Payment was cancelled or unsuccessful',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // External wallet callback (Mobile)
  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar(
      'External Wallet',
      'Selected wallet: ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    if (!kIsWeb) {
      _razorpay?.clear();
    }
    super.onClose();
  }
}
