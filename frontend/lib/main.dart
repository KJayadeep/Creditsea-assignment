import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'core/network/api_client.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApiClient.initialize();
  await Get.putAsync(() => StorageService().init());

  runApp(const CreditSeaApp());
}
