import 'package:equatable/equatable.dart';

class IngredientWithQuantityModel extends Equatable {
  String name;
  num quantity;
  String unit;

  IngredientWithQuantityModel(
      {required this.name, required this.quantity, required this.unit});

  factory IngredientWithQuantityModel.fromMap(Map<String, dynamic> json) =>
      IngredientWithQuantityModel(
          name: json['name'] ?? "",
          quantity: (json['quantity'] as num),
          unit: json['unit'] ?? "");

  Map<String, dynamic> toMap() => {
        'name': name,
        'unit': unit,
        'quantity': quantity,
      };

  @override
  List<Object> get props => [name, quantity, unit];
}
