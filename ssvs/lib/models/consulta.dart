import 'cupo.dart';
import 'historiaClinica.dart';
import 'tratamiento.dart';

class Consulta {
  final int? id;
  final String fechaConsulta;
  final String motivoConsulta;
  final String? diagnostico;
  final String? nota;
  final Cupo? cupo;
  final HistoriaClinica? historiaClinica;
  Tratamiento? tratamiento;

  Consulta({
    this.id,
    required this.fechaConsulta,
    required this.motivoConsulta,
    this.diagnostico,
    this.nota,
    this.cupo,
    this.historiaClinica,
    this.tratamiento,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) => Consulta(
        id: json['id'],
        fechaConsulta: json['fechaConsulta'],
        motivoConsulta: json['motivoConsulta'],
        diagnostico: json['diagnostico'],
        nota: json['nota'],
        cupo: json['cupo'] != null ? Cupo.fromJson(json['cupo']) : null,
        historiaClinica: json['historiaClinica'] != null
            ? HistoriaClinica.fromJson(json['historiaClinica'])
            : null,
        tratamiento: json['tratamiento'] != null
            ? Tratamiento.fromJson(json['tratamiento'])
            : null,
      );
}
