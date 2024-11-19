import 'rol.dart';

class Usuario {
  final int? id;
  final String ci;
  final String correo;
  final String contrasena;
  final String nombre;
  final String apellido;
  final bool estaActivo;
  final Rol? rol;

  Usuario({
    this.id,
    required this.ci,
    required this.correo,
    required this.contrasena,
    required this.nombre,
    required this.apellido,
    required this.estaActivo,
    this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'],
        ci: json['ci'],
        correo: json['correo'],
        contrasena: json['contrasena'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        estaActivo: json['estaActivo'],
        rol: json['rol'] != null ? Rol.fromJson(json['rol']) : null,
      );
}
