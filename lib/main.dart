import 'package:distribution/Provider/AuthProvider/LoginProvider.dart';
import 'package:distribution/Provider/ProductProvider/ProducProvider.dart';
import 'package:distribution/Screen/DashBoardScreen.dart';
import 'package:distribution/Screen/splashview/splashLogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Provider/CustomerProvider/CustomerProvider.dart';
import 'Provider/OrderTakingProvider/OrderTakingProvider.dart';
import 'Provider/SaleManProvider/SaleManProvider.dart';
import 'Provider/SalessProvider/SalessProvider.dart';

void main()async {


  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize SharedPreferences safely
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(token: token));

}
class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderTakingProvider()),
        ChangeNotifierProvider(create: (_) => SaleManProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Distribution System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B86E5)),
        ),
        // ✅ If token found → go to dashboard, otherwise splash
        home: token != null ? const SplashLogo() : const SplashLogo(),
      ),
    );
  }
}


