import 'medicoEspecialidad.dart';
import 'cupo.dart';

class Horario {
  final int? id;
  final String fecha;
  final String horaInicio;
  final String horaFinal;
  final int cantidadCupos;
  final MedicoEspecialidad? medicoEspecialidad;
  final List<Cupo>? cupos;

  Horario({
    this.id,
    required this.fecha,
    required this.horaInicio,
    required this.horaFinal,
    required this.cantidadCupos,
    this.medicoEspecialidad,
    this.cupos,
  });

  factory Horario.fromJson(Map<String, dynamic> json) => Horario(
        id: json['id'],
        fecha: json['fecha'],
        horaInicio: json['horaInicio'],
        horaFinal: json['horaFinal'],
        cantidadCupos: json['cantidadCupos'],
        medicoEspecialidad: json['medicoEspecialidad'] != null
            ? MedicoEspecialidad.fromJson(json['medicoEspecialidad'])
            : null,
        cupos: (json['cupos'] as List<dynamic>?)
            ?.map((e) => Cupo.fromJson(e))
            .toList(),
      );
}
