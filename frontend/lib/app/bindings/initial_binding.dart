import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/loan_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<LoanRepository>(() => LoanRepository(), fenix: true);
  }
}
