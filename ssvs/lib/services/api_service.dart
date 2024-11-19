import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/especialidad.dart';
import '../services/auth_service.dart'; // Importa el AuthService

class ApiService {
  final String apiUrl = 'https://ssvs-backend-produccion-production.up.railway.app/api/especialidad';
  final AuthService authService = AuthService(); // Instancia de AuthService

  Future<List<Especialidad>> obtenerEspecialidades() async {
    // Obtén el token del AuthService
    String? token = await authService.getToken();

    if (token == null) {
      throw Exception("No se encontró un token de autenticación.");
    }

    // Realiza la solicitud con el token en el encabezado
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // Incluye el token en el encabezado
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Especialidad.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar especialidades');
    }
  }
}
