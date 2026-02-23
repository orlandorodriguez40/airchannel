import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'filter_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _login() async {
    // Validación de campos vacíos
    if (_userController.text.trim().isEmpty ||
        _passController.text.trim().isEmpty) {
      _showError("Por favor, llene todos los campos");
      return;
    }

    setState(() => _isLoading = true);

    // Llamada a la API real
    final result = await _apiService.login(
      _userController.text.trim(),
      _passController.text.trim(),
    );

    // Verificamos si el widget sigue en pantalla antes de actualizar el estado
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result != null) {
      // Guardar sesión persistente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Verificamos de nuevo antes de navegar (async gap)
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FilterScreen()),
      );
    } else {
      _showError("¡Datos erróneos! Revise.");
    }
  }

  void _showError(String mensaje) {
    // Verificamos mounted antes de mostrar un SnackBar tras un proceso async
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, textAlign: TextAlign.center),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF050505), Color(0xFF1A1A1A)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            // Center ayuda a que el contenido esté bien posicionado
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Logotipo
                  Image.asset('assets/logotipo_sin_fondo_opt.png', height: 120),
                  const SizedBox(height: 50),

                  // Campo Usuario
                  _buildTextField(
                    controller: _userController,
                    label: "Nombre de Usuario", // Antes decía "Usuario / Email"
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),

                  // Campo Password
                  _buildTextField(
                    controller: _passController,
                    label: "Password",
                    icon: Icons.lock,
                    isObscure: true,
                  ),
                  const SizedBox(height: 40),

                  // Botón con degradado Dorado
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEFCD61), Color(0xFFB89B45)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "INGRESAR",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isObscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFEFCD61)),
        prefixIcon: Icon(icon, color: const Color(0xFFEFCD61)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFEFCD61)),
        ),
        filled: true,
        fillColor: const Color(0xFF111111),
      ),
    );
  }
}
//fin