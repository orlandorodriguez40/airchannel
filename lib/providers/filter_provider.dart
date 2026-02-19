import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import 'dart:developer' as dev;

class FilterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  LocationItem? _selectedPais;
  LocationItem? _selectedEstado;
  LocationItem? _selectedCiudad;
  LocationItem? _selectedMunicipio;
  LocationItem? _selectedUrbanizacion;
  LocationItem? _selectedTipoPropiedad;
  LocationItem? _selectedOperacion;

  List<LocationItem> paises = [];
  List<LocationItem> estados = [];
  List<LocationItem> ciudades = [];
  List<LocationItem> municipios = [];
  List<LocationItem> urbanizaciones = [];
  List<LocationItem> tiposPropiedad = [];
  List<LocationItem> operaciones = [];

  // Getters
  LocationItem? get selectedPais => _selectedPais;
  LocationItem? get selectedEstado => _selectedEstado;
  LocationItem? get selectedCiudad => _selectedCiudad;
  LocationItem? get selectedMunicipio => _selectedMunicipio;
  LocationItem? get selectedUrbanizacion => _selectedUrbanizacion;
  LocationItem? get selectedTipoPropiedad => _selectedTipoPropiedad;
  LocationItem? get selectedOperacion => _selectedOperacion;

  Future<void> cargarConfiguracionInicial() async {
    try {
      final resultados = await Future.wait([
        _apiService.fetchData('paises'),
        _apiService.fetchData('tipo_propiedades'),
        _apiService.fetchData('operaciones'),
      ]);

      paises = resultados[0];
      tiposPropiedad = resultados[1];
      operaciones = resultados[2];
      notifyListeners();
    } catch (e) {
      dev.log("Error en carga inicial", error: e);
    }
  }

  Future<void> setPais(LocationItem? pais) async {
    _selectedPais = pais;
    _selectedEstado = _selectedCiudad = _selectedMunicipio =
        _selectedUrbanizacion = null;
    estados = ciudades = municipios = urbanizaciones = [];
    notifyListeners(); // Notificamos el reset

    if (pais != null) {
      try {
        estados = await _apiService.fetchData('estados/${pais.id}');
        notifyListeners();
      } catch (e) {
        dev.log("Error cargando estados", error: e);
      }
    }
  }

  Future<void> setEstado(LocationItem? estado) async {
    _selectedEstado = estado;
    _selectedCiudad = _selectedMunicipio = _selectedUrbanizacion = null;
    ciudades = municipios = urbanizaciones = [];
    notifyListeners();

    if (estado != null) {
      try {
        ciudades = await _apiService.fetchData('ciudades/${estado.id}');
        notifyListeners();
      } catch (e) {
        dev.log("Error cargando ciudades", error: e);
      }
    }
  }

  Future<void> setCiudad(LocationItem? ciudad) async {
    _selectedCiudad = ciudad;
    _selectedMunicipio = _selectedUrbanizacion = null;
    municipios = urbanizaciones = [];
    notifyListeners();

    if (ciudad != null) {
      try {
        municipios = await _apiService.fetchData('municipios/${ciudad.id}');
        notifyListeners();
      } catch (e) {
        dev.log("Error cargando municipios", error: e);
      }
    }
  }

  Future<void> setMunicipio(LocationItem? municipio) async {
    _selectedMunicipio = municipio;
    _selectedUrbanizacion = null;
    urbanizaciones = [];
    notifyListeners();

    if (municipio != null) {
      try {
        urbanizaciones = await _apiService.fetchData(
          'urbanizaciones/${municipio.id}',
        );
        notifyListeners();
      } catch (e) {
        dev.log("Error cargando urbanizaciones", error: e);
      }
    }
  }

  void setUrbanizacion(LocationItem? urb) {
    _selectedUrbanizacion = urb;
    notifyListeners();
  }

  void setTipoPropiedad(LocationItem? tipo) {
    _selectedTipoPropiedad = tipo;
    notifyListeners();
  }

  void setOperacion(LocationItem? op) {
    _selectedOperacion = op;
    notifyListeners();
  }
}
