import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import 'dart:developer' as dev; // Importamos el framework de logging

class ApiService {
  static const String baseUrl = "https://airchannel.a-stats.com/api";

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
      // Usamos dev.log en lugar de print
      dev.log(
        "Error en fetchData ($endpoint): $e",
        name: "ApiService",
        error: e,
      );
      return [];
    }
  }
}
