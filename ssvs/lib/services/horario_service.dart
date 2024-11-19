import 'package:http/http.dart' as http;
import 'package:ssvs/services/auth_service.dart';
import 'dart:convert';
import '../models/horario.dart';

class HorarioService {
  final String apiUrl = "https://ssvs-backend-produccion-production.up.railway.app/api/horario";
  final AuthService _authService = AuthService();
    Future<List<Horario>> obtenerHorariosPorMedicoEspecialidad(int medicoEspecialidadId) async {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('$apiUrl/medico-especialidad/$medicoEspecialidadId'),
              headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Horario.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar horarios');
      }
    }
}
