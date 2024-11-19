import 'tratamiento.dart';

class Receta {
  final int? id;
  final String medicamento;
  final String frecuencia;
  final String fechaInicio;
  final String fechaFinal;
  final Tratamiento? tratamiento;

  Receta({
    this.id,
    required this.medicamento,
    required this.frecuencia,
    required this.fechaInicio,
    required this.fechaFinal,
    this.tratamiento,
  });

  factory Receta.fromJson(Map<String, dynamic> json) => Receta(
        id: json['id'],
        medicamento: json['medicamento'],
        frecuencia: json['frecuencia'],
        fechaInicio: json['fechaInicio'],
        fechaFinal: json['fechaFinal'],
        tratamiento: json['tratamiento'] != null
            ? Tratamiento.fromJson(json['tratamiento'])
            : null,
      );
}
