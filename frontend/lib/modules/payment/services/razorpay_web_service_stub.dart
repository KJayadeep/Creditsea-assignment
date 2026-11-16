void openRazorpayWebCheckout({
  required Map<String, dynamic> options,
  required Function(String orderId, String paymentId, String signature) onSuccess,
  required Function(String error) onFailure,
  required Function() onDismiss,
}) {
  // No-op on native platforms (handled by native Razorpay SDK)
}
