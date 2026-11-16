import 'dart:convert';
import 'dart:js_interop';

@JS('openRazorpayWebCheckout')
external void _openRazorpayWebCheckout(JSString optionsJson);

@JS('onRazorpayWebSuccess')
external set _onSuccess(JSFunction? callback);

@JS('onRazorpayWebFailure')
external set _onFailure(JSFunction? callback);

@JS('onRazorpayWebDismiss')
external set _onDismiss(JSFunction? callback);

void openRazorpayWebCheckout({
  required Map<String, dynamic> options,
  required Function(String orderId, String paymentId, String signature) onSuccess,
  required Function(String error) onFailure,
  required Function() onDismiss,
}) {
  _onSuccess = ((JSString orderId, JSString paymentId, JSString signature) {
    onSuccess(orderId.toDart, paymentId.toDart, signature.toDart);
  }).toJS;

  _onFailure = ((JSString error) {
    onFailure(error.toDart);
  }).toJS;

  _onDismiss = (() {
    onDismiss();
  }).toJS;

  final optionsJson = jsonEncode(options);
  _openRazorpayWebCheckout(optionsJson.toJS);
}
