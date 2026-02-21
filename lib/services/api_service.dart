import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import 'dart:developer' as dev; // Importamos el framework de logging

class ApiService {
  static const String baseUrl = "https://airchannel.a-stats.com/api";

  // Busca el método login dentro de ApiService y modifícalo así:
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username, // Cambiado de 'email' a 'username'
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        dev.log(
          "Error de login: ${response.statusCode}",
          name: "ApiService.login",
        );
        return null;
      }
    } catch (e) {
      dev.log("Excepción en login: $e", name: "ApiService.login", error: e);
      return null;
    }
  }

  // --- MÉTODO FETCHDATA (EXISTENTE) ---
  Future<List<LocationItem>> fetchData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);

        if (decodedData['datos'] != null) {
          final List<dynamic> listaJson = decodedData['datos'];
          return listaJson.map((item) => LocationItem.fromJson(item)).toList();
        }
        return [];
      } else {
        dev.log(
          "Error de servidor: ${response.statusCode}",
          name: "ApiService",
        );
        return [];
      }
    } catch (e) {
      dev.log(
        "Error en fetchData ($endpoint): $e",
        name: "ApiService",
        error: e,
      );
      return [];
    }
  }
}
