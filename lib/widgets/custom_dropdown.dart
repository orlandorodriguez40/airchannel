import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../utils/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<LocationItem> items;
  final LocationItem? value;
  final Function(LocationItem?) onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            value: value,
            hint: Text("Seleccione $label"),
            items: items.map((item) {
              return DropdownMenuItem<LocationItem>(
                value: item,
                child: Text(item.nombre),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
