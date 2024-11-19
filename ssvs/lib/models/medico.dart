import 'usuario.dart';

class Medico {
  final int? id;
  final String item;
  final Usuario? usuario;

  Medico({this.id, required this.item, this.usuario});

  factory Medico.fromJson(Map<String, dynamic> json) => Medico(
        id: json['id'],
        item: json['item'],
        usuario: json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null,
      );
}
