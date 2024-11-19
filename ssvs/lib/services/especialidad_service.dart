import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/especialidad.dart';
import 'auth_service.dart'; // Para obtener el token

class EspecialidadService {
  final String apiUrl = "https://ssvs-backend-produccion-production.up.railway.app/api/especialidad";
  final AuthService _authService = AuthService();

  Future<List<Especialidad>> obtenerEspecialidades() async {
    // Obtener el token desde AuthService
    final String? token = await _authService.getToken();

    // Verificar si el token es nulo
    if (token == null) {
      throw Exception('No se encontró el token. No puedes acceder a las especialidades.');
    }

    // Realizar la solicitud HTTP con encabezados
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Manejo de la respuesta
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Especialidad.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar especialidades: ${response.statusCode} ${response.body}');
    }
  }
}
