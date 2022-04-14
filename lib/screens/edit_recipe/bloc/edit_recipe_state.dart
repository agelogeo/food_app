part of 'edit_recipe_bloc.dart';

enum EditRecipeStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditRecipeStatus {
  bool get isLoadingOrSuccess => [
        EditRecipeStatus.loading,
        EditRecipeStatus.success,
      ].contains(this);
}

class EditRecipeState extends Equatable {
  const EditRecipeState({
    this.id = '',
    this.status = EditRecipeStatus.initial,
    this.initialRecipe,
    this.title = '',
    this.subtitle = '',
    this.imageFile,
    this.imageUrl,
    this.ingredients,
    this.steps,
  });

  final EditRecipeStatus status;
  final RecipeModel? initialRecipe;
  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final PickedFile? imageFile;
  final List<IngredientWithQuantityModel>? ingredients;
  final List<String>? steps;

  bool get isNewTodo => initialRecipe == null;

  EditRecipeState copyWith(
      {EditRecipeStatus? status,
      RecipeModel? initialRecipe,
      String? title,
      String? id,
      String? subtitle,
      String? imageUrl,
      PickedFile? imageFile,
      List<IngredientWithQuantityModel>? ingredients,
      List<String>? steps}) {
    return EditRecipeState(
      id: id ?? this.id,
      status: status ?? this.status,
      initialRecipe: initialRecipe ?? this.initialRecipe,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      subtitle: subtitle ?? this.subtitle,
      imageFile: imageFile ?? this.imageFile,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [
        id,
        status,
        initialRecipe,
        title,
        subtitle,
        ingredients,
        steps,
        imageFile,
        imageUrl
      ];
}
