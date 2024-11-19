import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receta.dart';
import 'auth_service.dart';

class RecetaService {
  final String apiUrl = 'https://ssvs-backend-produccion-production.up.railway.app/api/receta';
  final AuthService authService = AuthService();

  Future<List<Receta>> obtenerRecetasPorTratamientoId(int tratamientoId) async {
    final token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/tratamiento/$tratamientoId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Respuesta del backend: ${response.body}');
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Receta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar recetas: ${response.statusCode}');
    }
  }

}
