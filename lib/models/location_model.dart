class LocationItem {
  final int id;
  final String nombre;

  LocationItem({required this.id, required this.nombre});

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      id: json['id'] ?? 0,
      // Añadimos 'tipo_propiedad' a la lista de búsqueda
      nombre:
          json['urbanizacion'] ??
          json['municipio'] ??
          json['ciudad'] ??
          json['estado'] ??
          json['pais'] ??
          json['tipo_propiedad'] ?? // <--- AGREGAMOS ESTA LÍNEA
          json['tipo'] ??
          json['operacion'] ??
          json['nombre'] ??
          'Sin nombre',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
