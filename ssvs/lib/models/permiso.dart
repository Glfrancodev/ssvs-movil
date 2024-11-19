class Permiso {
  final int? id;
  final String nombre;
  final String descripcion;

  Permiso({this.id, required this.nombre, required this.descripcion});

  factory Permiso.fromJson(Map<String, dynamic> json) => Permiso(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
      );
}
