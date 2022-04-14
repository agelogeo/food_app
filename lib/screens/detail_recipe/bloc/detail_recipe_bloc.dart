import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_app/data/models/recipe_model.dart';
import 'package:food_app/data/repositories/repository.dart';

part 'detail_recipe_event.dart';
part 'detail_recipe_state.dart';

class DetailRecipeBloc extends Bloc<DetailRecipeEvent, DetailRecipeState> {
  DetailRecipeBloc({
    required Repository repository,
    required RecipeModel recipe,
  })  : _recipeRepository = repository,
        super(
          DetailRecipeState(recipe: recipe),
        ) {
    on<InitialDetailEvent>((event, emit) {
      emit(state.copyWith(recipe: event.recipeModel));
    });

    on<DeleteRecipeEvent>((event, emit) async {
      await repository.removeRecipe(event.recipe);
      emit(state.copyWith(status: DetailRecipeStatus.deleted));
    });
  }

  final Repository _recipeRepository;
}
