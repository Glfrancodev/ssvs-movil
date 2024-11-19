class Rol {
  final int? id;
  final String nombre;

  Rol({this.id, required this.nombre});

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        id: json['id'],
        nombre: json['nombre'],
      );
}
