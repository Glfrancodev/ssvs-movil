import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/archivo.dart';
import 'auth_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Para manejar permisos
import 'package:open_file/open_file.dart';

class ArchivoService {
  final String apiUrl = 'https://ssvs-backend-produccion-production.up.railway.app/api/archivos';
  final AuthService _authService = AuthService(); // Servicio para obtener el token

  Future<List<Archivo>> listarArchivosPorConsulta(int consultaId) async {
    final String url = '$apiUrl/consulta/$consultaId';
    final token = await _authService.getToken();
    print('Realizando solicitud GET a $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Respuesta del backend: ${response.statusCode}, ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Archivo.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener los archivos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al realizar la solicitud GET: $e');
      rethrow;
    }
  }

  Future<void> descargarArchivo(String nombreArchivo) async {
    final url = '$apiUrl/descargar/$nombreArchivo';
    final token = await _authService.getToken();
    try {
      print('Realizando solicitud GET para descargar: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Asegúrate de enviar un token válido.
        },
      );

      if (response.statusCode == 200) {
        print('Archivo descargado con éxito: $nombreArchivo');

        // Guardar el archivo en el dispositivo.
        final directory = await getApplicationDocumentsDirectory(); // Importar 'path_provider' package.
        final filePath = '${directory.path}/$nombreArchivo';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('Archivo guardado en: $filePath');
        abrirArchivo('/data/user/0/com.example.ssvs/app_flutter/radiografia torax.jpg');
      } else {
        throw Exception('Error al descargar el archivo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al descargar archivo: $e');
      throw e;
    }
  }

  void abrirArchivo(String filePath) async {
    final result = await OpenFile.open(filePath);
    print('Estado de apertura: ${result.message}');
  }

}
