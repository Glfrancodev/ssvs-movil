import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/tratamiento.dart';
import 'auth_service.dart';

class TratamientoService {
  final String apiUrl = 'https://ssvs-backend-produccion-production.up.railway.app/api/tratamiento';
  final AuthService authService = AuthService();

  Future<Tratamiento?> obtenerTratamientoPorConsultaId(int consultaId) async {
    final token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/consulta/$consultaId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Tratamiento.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      print('No se encontró un tratamiento para la consulta ID: $consultaId');
      return null;
    } else {
      throw Exception('Error al obtener tratamiento: ${response.statusCode}');
    }
  }
}
