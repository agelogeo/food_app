import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:food_app/data/models/ingredient_w_quantity_model.dart';

class RecipeModel extends Equatable {
  String id;
  String title;
  String subtitle;
  String imageUrl;
  List<IngredientWithQuantityModel> ingredients = [];
  List<String> steps = [];

  RecipeModel(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.imageUrl,
      required this.ingredients,
      required this.steps});

  factory RecipeModel.fromMap(Map<String, dynamic> json) => RecipeModel(
        id: json['id'] ?? "",
        title: json['title'] ?? "",
        subtitle: json['subtitle'] ?? "",
        imageUrl: json['imageUrl'] ?? "",
        // ingredients: [],
        ingredients: List<IngredientWithQuantityModel>.from(json["ingredients"]
            .map((x) => IngredientWithQuantityModel.fromMap(
                x as Map<String, dynamic>))),
        steps: List<String>.from(json["steps"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'imageUrl': imageUrl,
        'ingredients': List<dynamic>.from(ingredients.map((x) => x.toMap())),
        'steps': List<dynamic>.from(steps.map((x) => x)),
      };

  factory RecipeModel.fromFirestore(DocumentSnapshot documentSnapshot) {
    var recipeModel =
        RecipeModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    return recipeModel;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [title, subtitle, ingredients, steps, imageUrl];
}
