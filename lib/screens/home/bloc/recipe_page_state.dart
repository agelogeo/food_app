import 'package:equatable/equatable.dart';
import 'package:food_app/data/models/recipe_model.dart';

class RecipePageState extends Equatable {
  const RecipePageState({required this.recipesList});

  final List<RecipeModel> recipesList;

  RecipePageState copyWith({List<RecipeModel>? recipesList}) {
    return RecipePageState(recipesList: recipesList ?? this.recipesList);
  }

  factory RecipePageState.initial() {
    return const RecipePageState(recipesList: []);
  }

  @override
  List<Object?> get props => [recipesList];
}
