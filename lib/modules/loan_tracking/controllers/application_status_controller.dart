
import 'package:get/get.dart';

class ApplicationStatusController extends GetxController {
  final applicationNumber = 'CS12323';

  final currentStatus = 1.obs;

  final List<String> statuses = [
    'Application Submitted',
    'Application under Review',
    'E-KYC',
    'E-Nach',
    'E-Sign',
    'Disbursement',
  ];

  String get statusTitle {
    switch (currentStatus.value) {
      case 0:
        return 'Application Submitted';
      case 1:
        return 'Application Under Review';
      case 2:
        return 'E-KYC Pending';
      case 3:
        return 'E-Nach Pending';
      case 4:
        return 'E-Sign Pending';
      case 5:
        return 'Disbursement Pending';
      default:
        return 'Application Under Review';
    }
  }

  String get statusDescription {
    switch (currentStatus.value) {
      case 0:
        return 'Your loan application has been submitted successfully.';
      case 1:
        return "We're carefully reviewing your application to ensure everything is in order. Thank you for your patience.";
      case 2:
        return 'Complete your KYC verification to proceed with your loan.';
      case 3:
        return 'Complete the electronic mandate setup to continue.';
      case 4:
        return 'Review and electronically sign your loan agreement.';
      case 5:
        return 'Your loan is being prepared for disbursement.';
      default:
        return 'Your application is being processed.';
    }
  }
}
