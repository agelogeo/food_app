part of 'detail_recipe_bloc.dart';

enum DetailRecipeStatus { active, deleted }

class DetailRecipeState extends Equatable {
  const DetailRecipeState({
    required this.recipe,
    this.status = DetailRecipeStatus.active,
  });

  final RecipeModel recipe;
  final DetailRecipeStatus status;

  DetailRecipeState copyWith({
    RecipeModel? recipe,
    DetailRecipeStatus? status,
  }) {
    return DetailRecipeState(
      recipe: recipe ?? this.recipe,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [recipe, status];
}
