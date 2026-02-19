import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/filter_provider.dart';
import 'utils/app_colors.dart';
import 'screens/filter_screen.dart';

void main() {
  // Aseguramos que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // MultiProvider envuelve toda la App para que el "cerebro" (Provider)
    // esté disponible en cualquier pantalla.
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FilterProvider())],
      child: const AirchannelApp(),
    ),
  );
}

class AirchannelApp extends StatelessWidget {
  const AirchannelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airchannel Inmobiliaria',
      debugShowCheckedModeBanner: false, // Quitamos la etiqueta "Debug"
      theme: ThemeData(
        useMaterial3: true,
        // Usamos tus colores corporativos definidos en AppColors
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          secondary: AppColors.lightBlue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        scaffoldBackgroundColor: AppColors.background,
      ),
      // Definimos la pantalla de Filtros como la página de inicio
      home: const FilterScreen(),
    );
  }
}
