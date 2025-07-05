import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'pages/onboarding_page/onboarding_screen.dart';
import 'pages/dashboard_page/dashboard_page.dart';
import 'pages/login_page/login_page.dart';
import 'pages/signup_page/signup_page.dart';
import 'pages/profil_page/profil_page.dart';
import 'pages/qr_scanner_page/qr_scanner_page.dart';
import 'pages/receive_money_page/receive_money_page.dart';
import 'pages/send_money_page/send_money_page.dart';
import 'pages/transaction_history_page.dart';
import 'providers/theme_provider.dart';

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;

  if (status.isDenied || status.isRestricted) {
    if (await Permission.notification.request().isGranted) {
      // Permission accordée
    } else if (status.isPermanentlyDenied) {
      print("🚫 Notifications définitivement refusées");
      openAppSettings();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializer le stockage local
  await GetStorage.init();

  // Demander la permission de notification
  await requestNotificationPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return GetMaterialApp(
            title: 'AfriCoin',
            debugShowCheckedModeBanner: false,
            themeMode: themeNotifier.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const OnboardingScreen(),
            getPages: [
              GetPage(name: '/dashboard', page: () => DashboardPage()),
              GetPage(name: '/login', page: () => const LoginPage()),
              GetPage(name: '/signup', page: () => const SignupPage()),
              GetPage(name: '/profile', page: () => ProfileScreen()),
              GetPage(name: '/qr-scanner', page: () => QRScannerScreen()),
              GetPage(name: '/receive-money', page: () => ReceiveMoneyScreen()),
              GetPage(name: '/send-money', page: () => SendMoneyScreen()),
              GetPage(
                name: '/transaction-history',
                page: () => TransactionHistoryScreen(),
              ),
            ],
          );
        },
      ),
    );
  }
}
