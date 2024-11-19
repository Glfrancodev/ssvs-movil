import 'rol.dart';
import 'permiso.dart';

class RolPermiso {
  final int? id;
  final Rol rol;
  final Permiso permiso;

  RolPermiso({this.id, required this.rol, required this.permiso});

  factory RolPermiso.fromJson(Map<String, dynamic> json) => RolPermiso(
        id: json['id'],
        rol: Rol.fromJson(json['rol']),
        permiso: Permiso.fromJson(json['permiso']),
      );
}
