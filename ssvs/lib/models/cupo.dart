import 'horario.dart';
import 'asegurado.dart';

class Cupo {
  final int? id;
  final int? numero;
  String? fechaReservado;
  final String? hora;
  String? estado;
  final Horario? horario;
  Asegurado? asegurado;

  Cupo({
    this.id,
    this.numero,
    this.fechaReservado,
    this.hora,
    this.estado,
    this.horario,
    this.asegurado,
  });

  factory Cupo.fromJson(Map<String, dynamic> json) => Cupo(
        id: json['id'],
        numero: json['numero'],
        fechaReservado: json['fechaReservado'],
        hora: json['hora'],
        estado: json['estado'],
        horario: json['horario'] != null ? Horario.fromJson(json['horario']) : null,
        asegurado: json['asegurado'] != null ? Asegurado.fromJson(json['asegurado']) : null,
      );
}
