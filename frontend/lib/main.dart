import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/network/api_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ApiClient.initialize();

  runApp(const CreditSeaApp());
}