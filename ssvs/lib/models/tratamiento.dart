import 'consulta.dart';
import 'receta.dart';

class Tratamiento {
  final int? id;
  final String fecha;
  final Consulta? consulta;
  final List<Receta>? recetas;

  Tratamiento({
    this.id,
    required this.fecha,
    this.consulta,
    this.recetas,
  });

  factory Tratamiento.fromJson(Map<String, dynamic> json) => Tratamiento(
        id: json['id'],
        fecha: json['fecha'],
        consulta: json['consulta'] != null ? Consulta.fromJson(json['consulta']) : null,
        recetas: (json['recetas'] as List<dynamic>?)
            ?.map((e) => Receta.fromJson(e))
            .toList(),
      );
}
