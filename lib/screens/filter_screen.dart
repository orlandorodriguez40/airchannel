import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/filter_provider.dart';
import '../models/location_model.dart';
import '../models/propiedad_model.dart';
import 'results_screen.dart';
import 'login_screen.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  // Control de navegación inferior
  int _currentIndex = 1; // Empezamos en la pestaña de búsquedas (índice 1)

  final Color goldColor = const Color(0xFFEFCD61);
  final Color darkBg = const Color(0xFF050505);
  final Color cardColor = const Color(0xFF111111);

  @override
  void initState() {
    super.initState();
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

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterProv = context.watch<FilterProvider>();

    return Scaffold(
      backgroundColor: darkBg,
      // --- CABECERA (AppBar) ---
      appBar: AppBar(
        title: const Text(
          'AIRCHANNEL',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        backgroundColor: darkBg,
        foregroundColor: goldColor,
        elevation: 0,
        centerTitle: true,
      ),

      // --- MENÚ LATERAL (Drawer) ---
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A1A1A),
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: darkBg),
              child: Center(
                child: Image.asset(
                  'assets/logotipo_sin_fondo_opt.png',
                  height: 80,
                ),
              ),
            ),
            _buildDrawerItem(Icons.link, "Mis Enlaces", () {}),
            _buildDrawerItem(Icons.person_outline, "Perfil", () {}),
            const Spacer(),
            const Divider(color: Colors.white10),
            _buildDrawerItem(
              Icons.logout_rounded,
              "Salir",
              () => _logout(context),
              color: Colors.redAccent,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // --- CUERPO DINÁMICO ---
      body: _buildBody(_currentIndex, filterProv),

      // --- PIE DE PÁGINA (Bottom Navigation) ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: cardColor,
        selectedItemColor: goldColor,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Búsquedas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_outlined),
            label: 'Propiedades',
          ),
        ],
      ),
    );
  }

  // Lógica para mostrar contenido según el índice del pie
  Widget _buildBody(int index, FilterProvider filterProv) {
    switch (index) {
      case 0:
        return const Center(
          child: Text("Dashboard", style: TextStyle(color: Colors.white70)),
        );
      case 2:
        return const Center(
          child: Text(
            "Mis Propiedades",
            style: TextStyle(color: Colors.white70),
          ),
        );
      case 1:
      default:
        return _buildFilterForm(filterProv);
    }
  }

  // El formulario de filtros que ya tenías
  Widget _buildFilterForm(FilterProvider filterProv) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildDropdown(
            "País",
            filterProv.paises,
            filterProv.selectedPais,
            (val) => filterProv.setPais(val),
          ),
          _buildDropdown(
            "Estado",
            filterProv.estados,
            filterProv.selectedEstado,
            (val) => filterProv.setEstado(val),
          ),
          _buildDropdown(
            "Ciudad",
            filterProv.ciudades,
            filterProv.selectedCiudad,
            (val) => filterProv.setCiudad(val),
          ),
          _buildDropdown(
            "Municipio",
            filterProv.municipios,
            filterProv.selectedMunicipio,
            (val) => filterProv.setMunicipio(val),
          ),
          _buildDropdown(
            "Urbanización",
            filterProv.urbanizaciones,
            filterProv.selectedUrbanizacion,
            (val) => filterProv.setUrbanizacion(val),
          ),

          const Divider(height: 40, color: Colors.white10),

          _buildDropdown(
            "Tipo Propiedad",
            filterProv.tiposPropiedad,
            filterProv.selectedTipoPropiedad,
            (val) => filterProv.setTipoPropiedad(val),
          ),
          _buildDropdown(
            "Operación",
            filterProv.operaciones,
            filterProv.selectedOperacion,
            (val) => filterProv.setOperacion(val),
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Rango de Precio",
              style: TextStyle(fontWeight: FontWeight.bold, color: goldColor),
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

          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [goldColor, const Color(0xFFB89B45)],
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
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
                          titulo: "Búsqueda Personalizada",
                          descripcion:
                              "Resultados para ${filterProv.selectedCiudad?.nombre ?? 'su zona'}",
                          precio: _minPriceController.text.isEmpty
                              ? "Consultar"
                              : _minPriceController.text,
                          imagenUrl:
                              "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
                          ciudad:
                              filterProv.selectedCiudad?.nombre ?? "Ubicación",
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text(
                "MOSTRAR PROPIEDADES",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? goldColor),
      title: Text(title, style: TextStyle(color: color ?? Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildDropdown(
    String label,
    List<LocationItem> items,
    LocationItem? currentVal,
    Function(LocationItem?) onChange,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: goldColor.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: currentVal != null ? goldColor : Colors.white10,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<LocationItem>(
                isExpanded: true,
                dropdownColor: const Color(0xFF1A1A1A),
                value: currentVal,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                hint: const Text(
                  "Seleccione",
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
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

  Widget _buildPriceField(String hint, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          prefixIcon: Icon(Icons.attach_money, size: 20, color: goldColor),
          filled: true,
          fillColor: cardColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: goldColor),
          ),
        ),
      ),
    );
  }
}
