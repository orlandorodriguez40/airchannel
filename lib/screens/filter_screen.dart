import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import '../utils/app_colors.dart';
import '../services/api_service.dart';
import '../models/location_model.dart';
import '../models/propiedad_model.dart'; // Nuevo
import 'results_screen.dart'; // Nuevo

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final ApiService _apiService = ApiService();

  // --- CONTROLADORES PARA PRECIOS ---
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  // --- VARIABLES DE SELECCIÓN ---
  LocationItem? selectedPais;
  LocationItem? selectedEstado;
  LocationItem? selectedCiudad;
  LocationItem? selectedMunicipio;
  LocationItem? selectedUrbanizacion;
  LocationItem? selectedTipo;
  LocationItem? selectedOperacion;

  // --- LISTAS PARA LLENAR LOS DROPDOWNS ---
  List<LocationItem> paises = [];
  List<LocationItem> estados = [];
  List<LocationItem> ciudades = [];
  List<LocationItem> municipios = [];
  List<LocationItem> urbanizaciones = [];
  List<LocationItem> tiposPropiedad = [];
  List<LocationItem> operaciones = [];

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  void _cargarDatosIniciales() async {
    try {
      final results = await Future.wait([
        _apiService.fetchData('paises'),
        _apiService.fetchData('tipo_propiedades'),
        _apiService.fetchData('operaciones'),
      ]);

      setState(() {
        paises = results[0];
        tiposPropiedad = results[1];
        operaciones = results[2];
      });
    } catch (e) {
      dev.log(
        "Error cargando datos iniciales",
        error: e,
        name: "Airchannel.Filtros",
      );
    }
  }

  // --- FUNCIONES DE CARGA EN CASCADA ---
  void _cargarEstados(int id) async {
    var data = await _apiService.fetchData('estados/$id');
    setState(() {
      estados = data;
      selectedEstado = null;
      selectedCiudad = null;
    });
  }

  void _cargarCiudades(int id) async {
    var data = await _apiService.fetchData('ciudades/$id');
    setState(() {
      ciudades = data;
      selectedCiudad = null;
      selectedMunicipio = null;
    });
  }

  void _cargarMunicipios(int id) async {
    var data = await _apiService.fetchData('municipios/$id');
    setState(() {
      municipios = data;
      selectedMunicipio = null;
      selectedUrbanizacion = null;
    });
  }

  void _cargarUrbanizaciones(int id) async {
    var data = await _apiService.fetchData('urbanizaciones/$id');
    setState(() {
      urbanizaciones = data;
      selectedUrbanizacion = null;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Airchannel - Filtros',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Encuentra tu inmueble",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 20),

            _buildDropdown("País", paises, selectedPais, (val) {
              setState(() => selectedPais = val);
              if (val != null) _cargarEstados(val.id);
            }),

            _buildDropdown("Estado", estados, selectedEstado, (val) {
              setState(() => selectedEstado = val);
              if (val != null) _cargarCiudades(val.id);
            }),

            _buildDropdown("Ciudad", ciudades, selectedCiudad, (val) {
              setState(() => selectedCiudad = val);
              if (val != null) _cargarMunicipios(val.id);
            }),

            _buildDropdown("Municipio", municipios, selectedMunicipio, (val) {
              setState(() => selectedMunicipio = val);
              if (val != null) _cargarUrbanizaciones(val.id);
            }),

            _buildDropdown(
              "Urbanización",
              urbanizaciones,
              selectedUrbanizacion,
              (val) {
                setState(() => selectedUrbanizacion = val);
              },
            ),

            const Divider(height: 40),

            _buildDropdown("Tipo de Propiedad", tiposPropiedad, selectedTipo, (
              val,
            ) {
              setState(() => selectedTipo = val);
            }),

            _buildDropdown("Operación", operaciones, selectedOperacion, (val) {
              setState(() => selectedOperacion = val);
            }),

            const SizedBox(height: 20),

            const Text(
              "Rango de Precio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildPriceField("Mínimo", _minPriceController),
                const SizedBox(width: 15),
                _buildPriceField("Máximo", _maxPriceController),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  dev.log(
                    "Navegando a resultados...",
                    name: "Airchannel.Filtros",
                  );

                  // Simulación de datos para probar la pantalla de resultados
                  // En el futuro, aquí llamarás a tu API de búsqueda real
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsScreen(
                        propiedades: [
                          Propiedad(
                            id: 1,
                            titulo: "Propiedad de Ejemplo",
                            descripcion: "Esta es una vista previa",
                            precio: _minPriceController.text.isEmpty
                                ? "0"
                                : _minPriceController.text,
                            imagenUrl:
                                "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
                            ciudad:
                                selectedCiudad?.nombre ??
                                "Ubicación seleccionada",
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<LocationItem> items,
    LocationItem? currentVal,
    void Function(LocationItem?) onChange,
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
              color: AppColors.lightBlue,
            ),
          ),
          DropdownButton<LocationItem>(
            isExpanded: true,
            value: currentVal,
            hint: Text("Seleccione $label"),
            items: items.map((item) {
              return DropdownMenuItem<LocationItem>(
                value: item,
                child: Text(item.nombre),
              );
            }).toList(),
            onChanged: onChange,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField(String hint, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(
            Icons.attach_money,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
