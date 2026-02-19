import 'package:flutter/material.dart';
import '../models/propiedad_model.dart';

class ResultsScreen extends StatelessWidget {
  final List<Propiedad> propiedades;

  const ResultsScreen({super.key, required this.propiedades});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: ListView.builder(
        itemCount: propiedades.length,
        itemBuilder: (context, index) {
          final p = propiedades[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(p.imagenUrl, width: 80, fit: BoxFit.cover),
              title: Text(p.titulo),
              subtitle: Text("${p.ciudad} - \$${p.precio}"),
              onTap: () {
                // Aquí podrías ir al detalle de la propiedad
              },
            ),
          );
        },
      ),
    );
  }
}
