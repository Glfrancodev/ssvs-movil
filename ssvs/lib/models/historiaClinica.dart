import 'asegurado.dart';
import 'consulta.dart';

class HistoriaClinica {
  final int? id;
  final Asegurado? asegurado;
  final List<Consulta>? consultas;

  HistoriaClinica({this.id, this.asegurado, this.consultas});

  factory HistoriaClinica.fromJson(Map<String, dynamic> json) => HistoriaClinica(
        id: json['id'],
        asegurado: json['asegurado'] != null ? Asegurado.fromJson(json['asegurado']) : null,
        consultas: (json['consultas'] as List<dynamic>?)
            ?.map((e) => Consulta.fromJson(e))
            .toList(),
      );
}
