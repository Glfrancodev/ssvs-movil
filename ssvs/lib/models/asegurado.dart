import 'usuario.dart';
import 'cupo.dart';
import 'historiaClinica.dart';

class Asegurado {
  final int? id;
  final String? tipoSangre;
  final String? sexo;
  final String? fechaNacimiento;
  final Usuario? usuario;
  final List<Cupo>? cupos;
  final HistoriaClinica? historiaClinica;

  Asegurado({
    this.id,
    this.tipoSangre,
    this.sexo,
    this.fechaNacimiento,
    this.usuario,
    this.cupos,
    this.historiaClinica,
  });

  factory Asegurado.fromJson(Map<String, dynamic> json) => Asegurado(
        id: json['id'],
        tipoSangre: json['tipoSangre'],
        sexo: json['sexo'],
        fechaNacimiento: json['fechaNacimiento'],
        usuario: json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null,
        cupos: (json['cupos'] as List<dynamic>?)
            ?.map((e) => Cupo.fromJson(e as Map<String, dynamic>))
            .toList(),
        historiaClinica: json['historiaClinica'] != null
            ? HistoriaClinica.fromJson(json['historiaClinica'])
            : null,
      );
}
