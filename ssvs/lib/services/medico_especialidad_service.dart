import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medico.dart';
import 'auth_service.dart';

class MedicoEspecialidadService {
  final String apiUrl = 'https://ssvs-backend-produccion-production.up.railway.app/api/medico-especialidad';
  final AuthService _authService = AuthService();

  Future<int?> obtenerMedicoEspecialidadId(int especialidadId, int medicoId) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/especialidad/$especialidadId/medico/$medicoId'),
            headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Retornar el id del medicoEspecialidad
      return data['id'];
    } else {
      throw Exception('Error al obtener MedicoEspecialidad');
    }
  }

  Future<List<Medico>> obtenerMedicosPorEspecialidad(int especialidadId) async {
    final token = await _authService.getToken();
    
    final response = await http.get(
      Uri.parse('$apiUrl/medico/especialidad/$especialidadId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Medico.fromJson(json)).toList(); // Mapea directamente a Medico
    } else {
      throw Exception('Error al cargar médicos');
    }
  }

}
