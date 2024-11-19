import 'medico.dart';
import 'especialidad.dart';
import 'horario.dart';

class MedicoEspecialidad {
  final int? id;
  final Medico? medico;
  final Especialidad? especialidad;
  final List<Horario>? horarios;

  MedicoEspecialidad({this.id, this.medico, this.especialidad, this.horarios});

  factory MedicoEspecialidad.fromJson(Map<String, dynamic> json) => MedicoEspecialidad(
        id: json['id'],
        medico: json['medico'] != null ? Medico.fromJson(json['medico']) : null,
        especialidad: json['especialidad'] != null ? Especialidad.fromJson(json['especialidad']) : null,
        horarios: (json['horarios'] as List<dynamic>?)
            ?.map((e) => Horario.fromJson(e))
            .toList(),
      );
}
