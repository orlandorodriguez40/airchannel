import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../utils/app_colors.dart';
import '../models/location_model.dart';
import '../models/propiedad_model.dart';
import 'results_screen.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carga inicial de datos desde las APIs de Pais, Tipo y Operación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FilterProvider>().cargarConfiguracionInicial();
    });
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterProv = context.watch<FilterProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Airchannel - Filtros'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. PAÍS
            _buildDropdown(
              "País",
              filterProv.paises,
              filterProv.selectedPais,
              (val) => filterProv.setPais(val),
            ),

            // 2. ESTADO
            _buildDropdown(
              "Estado",
              filterProv.estados,
              filterProv.selectedEstado,
              (val) => filterProv.setEstado(val),
            ),

            // 3. CIUDAD
            _buildDropdown(
              "Ciudad",
              filterProv.ciudades,
              filterProv.selectedCiudad,
              (val) => filterProv.setCiudad(val),
            ),

            // 4. MUNICIPIO
            _buildDropdown(
              "Municipio",
              filterProv.municipios,
              filterProv.selectedMunicipio,
              (val) => filterProv.setMunicipio(val),
            ),

            // 5. URBANIZACIÓN
            _buildDropdown(
              "Urbanización",
              filterProv.urbanizaciones,
              filterProv.selectedUrbanizacion,
              (val) => filterProv.setUrbanizacion(val),
            ),

            const Divider(height: 30),

            // 6. TIPO PROPIEDAD
            _buildDropdown(
              "Tipo Propiedad",
              filterProv.tiposPropiedad,
              filterProv.selectedTipoPropiedad,
              (val) => filterProv.setTipoPropiedad(val),
            ),

            // 7. OPERACIÓN
            _buildDropdown(
              "Operación",
              filterProv.operaciones,
              filterProv.selectedOperacion,
              (val) => filterProv.setOperacion(val),
            ),

            const Divider(height: 30),

            // 8 y 9. PRECIOS (Mínimo y Máximo)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Rango de Precio",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildPriceField("Precio Mínimo", _minPriceController),
                const SizedBox(width: 15),
                _buildPriceField("Precio Máximo", _maxPriceController),
              ],
            ),

            const SizedBox(height: 40),

            // BOTÓN MOSTRAR PROPIEDADES
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsScreen(
                        propiedades: [
                          Propiedad(
                            id: 1,
                            titulo: "Resultado de Búsqueda",
                            descripcion: "Filtros aplicados correctamente",
                            precio: _minPriceController.text,
                            imagenUrl:
                                "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
                            ciudad:
                                filterProv.selectedCiudad?.nombre ??
                                "Ubicación",
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text(
                  "MOSTRAR PROPIEDADES",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PARA DROPDOWNS ---
  Widget _buildDropdown(
    String label,
    List<LocationItem> items,
    LocationItem? currentVal,
    Function(LocationItem?) onChange,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<LocationItem>(
                isExpanded: true,
                value: currentVal,
                hint: Text("Seleccione $label"),
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item.nombre),
                      ),
                    )
                    .toList(),
                onChanged: onChange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET PARA CAMPOS DE PRECIO ---
  Widget _buildPriceField(String hint, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: const Icon(Icons.attach_money, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
