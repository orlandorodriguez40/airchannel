import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airchannel/utils/app_colors.dart';
import 'package:airchannel/screens/filter_screen.dart';
import 'package:airchannel/providers/filter_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FilterProvider())],
      // CAMBIO AQUÍ: Debe decir AirchannelApp, no MyApp
      child: const AirchannelApp(),
    ),
  );
}

// Esta clase DEBE llamarse igual que la que pusiste arriba en child:
class AirchannelApp extends StatelessWidget {
  const AirchannelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airchannel Inmobiliaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
      ),
      home: const FilterScreen(),
    );
  }
}
