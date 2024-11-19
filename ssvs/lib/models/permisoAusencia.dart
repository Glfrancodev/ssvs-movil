import 'medico.dart';

class PermisoAusencia {
  final int? id;
  final String fechaPermiso;
  final String descripcion;
  final String estado;
  final Medico? medico;

  PermisoAusencia({
    this.id,
    required this.fechaPermiso,
    required this.descripcion,
    required this.estado,
    this.medico,
  });

  factory PermisoAusencia.fromJson(Map<String, dynamic> json) => PermisoAusencia(
        id: json['id'],
        fechaPermiso: json['fechaPermiso'],
        descripcion: json['descripcion'],
        estado: json['estado'],
        medico: json['medico'] != null ? Medico.fromJson(json['medico']) : null,
      );
}
