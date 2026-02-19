import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';

class ApiService {
  final String baseUrl = "https://airchannel.a-stats.com/api";

  Future<List<LocationItem>> fetchData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => LocationItem.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
