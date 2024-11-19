import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/consulta.dart';
import 'auth_service.dart';

class ConsultaService {
  final String apiUrl = 'https://ssvs-backend-produccion-production.up.railway.app/api/consulta';
  final AuthService _authService = AuthService();

  Future<List<Consulta>> obtenerConsultasPorHistoriaClinica(int historiaClinicaId) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/historia/$historiaClinicaId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Consulta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar consultas de la historia clínica');
    }
  }
}
