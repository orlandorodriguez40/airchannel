import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import 'dart:developer' as dev;

class FilterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // --- VARIABLES PRIVADAS ---
  LocationItem? _selectedPais;
  LocationItem? _selectedEstado;
  LocationItem? _selectedCiudad;
  LocationItem? _selectedMunicipio;
  LocationItem? _selectedUrbanizacion;

  // --- LISTAS DE DATOS ---
  List<LocationItem> paises = [];
  List<LocationItem> estados = [];
  List<LocationItem> ciudades = [];
  List<LocationItem> municipios = [];
  List<LocationItem> urbanizaciones = [];

  // --- GETTERS (Para que las pantallas lean los valores) ---
  LocationItem? get selectedPais => _selectedPais;
  LocationItem? get selectedEstado => _selectedEstado;
  LocationItem? get selectedCiudad => _selectedCiudad;
  LocationItem? get selectedMunicipio => _selectedMunicipio;
  LocationItem? get selectedUrbanizacion => _selectedUrbanizacion;

  // --- MÉTODOS PARA CAMBIAR LOS VALORES (SETTERS) ---

  Future<void> cargarPaises() async {
    try {
      paises = await _apiService.fetchData('paises');
      notifyListeners();
    } catch (e) {
      dev.log("Error cargando países", error: e);
    }
  }

  void setPais(LocationItem? pais) async {
    _selectedPais = pais;
    _selectedEstado = null; // Resetear hijos al cambiar el padre
    _selectedCiudad = null;
    estados = [];
    if (pais != null) {
      estados = await _apiService.fetchData('estados/${pais.id}');
    }
    notifyListeners();
  }

  void setEstado(LocationItem? estado) async {
    _selectedEstado = estado;
    _selectedCiudad = null;
    ciudades = [];
    if (estado != null) {
      ciudades = await _apiService.fetchData('ciudades/${estado.id}');
    }
    notifyListeners();
  }

  void setCiudad(LocationItem? ciudad) async {
    _selectedCiudad = ciudad;
    _selectedMunicipio = null;
    municipios = [];
    if (ciudad != null) {
      municipios = await _apiService.fetchData('municipios/${ciudad.id}');
    }
    notifyListeners();
  }

  // Repetiremos este patrón para Municipio y Urbanización...
}
