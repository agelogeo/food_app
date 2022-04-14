part of 'edit_recipe_bloc.dart';

abstract class EditRecipeEvent extends Equatable {
  const EditRecipeEvent();

  @override
  List<Object> get props => [];
}

class EditRecipeImagePicker extends EditRecipeEvent {
  const EditRecipeImagePicker(this.imageSource);

  final ImageSource imageSource;

  @override
  List<Object> get props => [imageSource];
}

class AddNewIngredient extends EditRecipeEvent {
  const AddNewIngredient();

  @override
  List<Object> get props => [];
}

class AddNewStep extends EditRecipeEvent {
  const AddNewStep();

  @override
  List<Object> get props => [];
}

class RemoveIngredientAtIndex extends EditRecipeEvent {
  const RemoveIngredientAtIndex(this.index);

  final int index;
  @override
  List<Object> get props => [index];
}

class RemoveStepAtIndex extends EditRecipeEvent {
  const RemoveStepAtIndex(this.index);

  final int index;
  @override
  List<Object> get props => [index];
}

class EditRecipeIngredientNameChanged extends EditRecipeEvent {
  const EditRecipeIngredientNameChanged(this.name, this.index);

  final String name;
  final int index;

  @override
  List<Object> get props => [name, index];
}

class EditRecipeIngredientQuantityChanged extends EditRecipeEvent {
  const EditRecipeIngredientQuantityChanged(this.quantity, this.index);

  final double quantity;
  final int index;

  @override
  List<Object> get props => [quantity, index];
}

class EditRecipeIngredientUnitChanged extends EditRecipeEvent {
  const EditRecipeIngredientUnitChanged(this.index, this.unitIndex);

  final int index;
  final int unitIndex;

  @override
  List<Object> get props => [index, unitIndex];
}

class EditRecipeStepChanged extends EditRecipeEvent {
  const EditRecipeStepChanged(this.name, this.index);

  final String name;
  final int index;

  @override
  List<Object> get props => [name, index];
}

class EditRecipeTitleChanged extends EditRecipeEvent {
  const EditRecipeTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class InitialEvent extends EditRecipeEvent {
  const InitialEvent(this.recipeModel);

  final RecipeModel recipeModel;

  @override
  List<Object> get props => [];
}

class EditRecipeSubtitleChanged extends EditRecipeEvent {
  const EditRecipeSubtitleChanged(this.subtitle);

  final String subtitle;

  @override
  List<Object> get props => [subtitle];
}

class EditRecipeSubmitted extends EditRecipeEvent {
  const EditRecipeSubmitted();
}
