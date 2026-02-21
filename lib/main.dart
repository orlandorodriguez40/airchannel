import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importante para la persistencia
import 'providers/filter_provider.dart';
import 'screens/login_screen.dart';
import 'screens/filter_screen.dart';

void main() async {
  // 1. Aseguramos que los motores de Flutter estén listos para procesos asíncronos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Revisamos si existe una sesión guardada en el dispositivo
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FilterProvider())],
      // Pasamos el estado del login a la clase principal
      child: AirchannelApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class AirchannelApp extends StatelessWidget {
  final bool isLoggedIn;

  const AirchannelApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // Definimos el color dorado y el fondo oscuro consistentes con tu marca
    const Color goldColor = Color(0xFFEFCD61);
    const Color darkBackground = Color(0xFF050505);

    return MaterialApp(
      title: 'Airchannel Inmobiliaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark, // Define textos claros automáticamente
        colorScheme: ColorScheme.fromSeed(
          seedColor: goldColor,
          primary: goldColor,
          surface: darkBackground,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: darkBackground,

        appBarTheme: const AppBarTheme(
          backgroundColor: darkBackground,
          foregroundColor: goldColor,
          centerTitle: true,
          elevation: 0,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF111111),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF333333)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: goldColor),
            borderRadius: BorderRadius.circular(12),
          ),
          labelStyle: const TextStyle(color: goldColor),
        ),
      ),
      // 3. Lógica de inicio: si está logueado va a Filtros, si no, al Login
      home: isLoggedIn ? const FilterScreen() : const LoginScreen(),
    );
  }
}
