import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  final String apiUrl = 'https://ssvs-backend-produccion-production.up.railway.app/authenticate';

  Future<String?> login(String correo, String contrasena) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'correo': correo,
        'contrasena': contrasena,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['jwt']; // Obtiene el JWT del backend

      // Decodificar el token para verificar el rol
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String role = payload['role'];
      print(role);

      if (role == 'Asegurado') {
        // Guarda el token y el correo en SharedPreferences
        await _saveToken(token);
        await _saveCorreo(correo); // Guarda el correo ingresado

        return token;
      } else {
        // Si el rol no es "Asegurado", rechaza el inicio de sesión
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Map<String, String>> obtenerAseguradoPorCorreo(String correo) async {
    try {
      // Obtén el token guardado
      final token = await getToken();

      // Realiza la solicitud GET con el encabezado de autorización
      final response = await http.get(
        Uri.parse('https://ssvs-backend-produccion-production.up.railway.app/api/asegurado/correo/$correo'),
        headers: {
          'Authorization': 'Bearer $token', // Incluye el token
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final nombre = data['usuario']['nombre'];
        final apellido = data['usuario']['apellido'];
        return {'nombre': nombre, 'apellido': apellido};
      } else {
        throw Exception('Error al obtener datos del asegurado: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return {'nombre': 'Desconocido', 'apellido': ''};
    }
  }


  // Método para guardar el token en SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Método para guardar el correo en SharedPreferences
  Future<void> _saveCorreo(String correo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('correo', correo);
  }

  // Método para obtener el correo desde SharedPreferences
  Future<String?> getCorreo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('correo');
  }


  Future<void> logout() async {
    await clearToken();
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}
