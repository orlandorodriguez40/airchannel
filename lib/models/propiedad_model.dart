class Propiedad {
  final int id;
  final String titulo;
  final String descripcion;
  final String precio;
  final String imagenUrl;
  final String ciudad;

  Propiedad({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
    required this.ciudad,
  });

  factory Propiedad.fromJson(Map<String, dynamic> json) {
    return Propiedad(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? '',
      precio: json['precio']?.toString() ?? 'Consultar',
      imagenUrl: json['imagen_url'] ?? 'https://via.placeholder.com/150',
      ciudad: json['ciudad_nombre'] ?? '',
    );
  }
}
