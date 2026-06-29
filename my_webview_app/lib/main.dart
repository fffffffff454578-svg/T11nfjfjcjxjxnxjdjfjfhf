import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ফুল স্ক্রিন এবং স্ট্যাটাস বার সেটিংস
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: AbsherApp()));
}

class AbsherApp extends StatefulWidget {
  const AbsherApp({super.key});
  @override
  State<AbsherApp> createState() => _AbsherAppState();
}

class _AbsherAppState extends State<AbsherApp> {
  late InAppWebViewController webViewController;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await webViewController.canGoBack()) {
          webViewController.goBack();
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri("https://resplendent-concha-89806f.netlify.app/")),
          initialSettings: InAppWebViewSettings(
            isInspectable: true,
            useWideViewPort: true,
            loadWithOverviewMode: true,
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;

            // লগইন সাকসেস হ্যান্ডলার
            controller.addJavaScriptHandler(
              handlerName: 'loginSuccess',
              callback: (args) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', true);
                _checkFingerprint();
              },
            );

            // স্ট্যাটাস বার থিম হ্যান্ডলার
            controller.addJavaScriptHandler(
              handlerName: 'changeStatusBar',
              callback: (args) {
                bool isDark = args[0] ?? true;
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
                ));
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _checkFingerprint() async {
    try {
      bool canCheck = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (canCheck) {
        bool didAuthenticate = await auth.authenticate(
          localizedReason: 'ড্যাশবোর্ডে প্রবেশের জন্য ফিঙ্গারপ্রিন্ট দিন',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        if (didAuthenticate) {
          webViewController.loadUrl(
            urlRequest: URLRequest(url: WebUri("https://resplendent-concha-89806f.netlify.app/")),
          );
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}