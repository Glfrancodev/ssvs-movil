class Archivo {
  final String nombre;
  final String tipo;

  Archivo({
    required this.nombre,
    required this.tipo,
  });

  factory Archivo.fromJson(Map<String, dynamic> json) {
    return Archivo(
      nombre: json['nombre'] ?? '', // Manejar el caso en que 'nombre' sea null
      tipo: json['tipo'] ?? '',     // Manejar el caso en que 'tipo' sea null
    );
  }
}
