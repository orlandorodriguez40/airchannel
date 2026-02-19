import 'package:flutter/material.dart';
import '../models/propiedad_model.dart';
import '../widgets/property_card.dart';

class ResultsScreen extends StatelessWidget {
  // Aquí recibiremos los datos filtrados (puedes pasarlos por constructor o provider)
  final List<Propiedad> propiedades;

  const ResultsScreen({super.key, required this.propiedades});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Propiedades Encontradas")),
      body: propiedades.isEmpty
          ? const Center(
              child: Text("No se encontraron propiedades con esos filtros."),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: propiedades.length,
              itemBuilder: (context, index) {
                return PropertyCard(propiedad: propiedades[index]);
              },
            ),
    );
  }
}
