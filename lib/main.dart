import 'package:distribution/Screen/DashBoardScreen.dart';
import 'package:distribution/Screen/splashview/splashLogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/OrderTakingProvider/OrderTakingProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderTakingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Distribution System ',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5B86E5)),
      ),
      home: const SplashLogo(),
    );
  }
}


