import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cupo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class CupoService {
  final String apiUrl = "https://ssvs-backend-produccion-production.up.railway.app/api/cupo";
  final String aseguradoApiUrl = "https://ssvs-backend-produccion-production.up.railway.app/api/asegurado";
  final AuthService _authService = AuthService();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Cupo>> obtenerCuposPorHorario(int horarioId) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/horario/$horarioId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cupo.fromJson(json)).toList(); // Asegúrate de que el mapeo funcione correctamente
    } else {
      throw Exception('Error al cargar cupos');
    }
  }

  Future<List<Cupo>> obtenerCuposPorAsegurado(int aseguradoId) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/asegurado/$aseguradoId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cupo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los cupos del asegurado');
    }
  }

  // Obtener Asegurado por correo
  Future<int> obtenerAseguradoIdPorCorreo(String correo) async {
    final url = Uri.parse('$aseguradoApiUrl/correo/$correo');
    final token = await _getToken();
    
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['id'];
    } else {
      throw Exception('Error al obtener asegurado por correo');
    }
  }

  Future<void> reservarCupo(int cupoId, Map<String, Object> data) async {
    final url = Uri.parse('$apiUrl/reservar/$cupoId');
    final token = await _getToken();

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al reservar el cupo');
    }
  }


  // Quitar una reserva
  Future<void> quitarCupo(int cupoId) async {
    final url = Uri.parse('$apiUrl/no/reservar/$cupoId');
    final token = await _getToken();

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'estado': 'Libre',
        'asegurado': null,
        'fechaReservado': null,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al quitar la reserva del cupo');
    }
  }

}
