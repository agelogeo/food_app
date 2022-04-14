part of 'detail_recipe_bloc.dart';

abstract class DetailRecipeEvent extends Equatable {
  const DetailRecipeEvent();

  @override
  List<Object> get props => [];
}

class InitialDetailEvent extends DetailRecipeEvent {
  const InitialDetailEvent(this.recipeModel);

  final RecipeModel recipeModel;

  @override
  List<Object> get props => [];
}

class FetchDataEvent extends DetailRecipeEvent {
  @override
  List<Object> get props => [];
}

class DeleteRecipeEvent extends DetailRecipeEvent {
  final RecipeModel recipe;

  const DeleteRecipeEvent(this.recipe);
  @override
  List<Object> get props => [recipe];
}
