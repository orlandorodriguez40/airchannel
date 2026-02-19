class LocationItem {
  final int id;
  final String nombre;

  LocationItem({required this.id, required this.nombre});

  // Esto convierte el JSON de tu API de Laravel a un objeto de Flutter
  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? json['descripcion'] ?? '',
    );
  }
}
