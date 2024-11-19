import 'medicoEspecialidad.dart';

class Especialidad {
  final int? id;
  final String nombre;
  final String descripcion;
  final List<MedicoEspecialidad>? medicoEspecialidades;

  Especialidad({
    this.id,
    required this.nombre,
    required this.descripcion,
    this.medicoEspecialidades,
  });

  factory Especialidad.fromJson(Map<String, dynamic> json) => Especialidad(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        medicoEspecialidades: (json['medicoEspecialidades'] as List<dynamic>?)
            ?.map((e) => MedicoEspecialidad.fromJson(e))
            .toList(),
      );
}
