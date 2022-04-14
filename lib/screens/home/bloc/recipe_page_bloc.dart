import 'package:bloc/bloc.dart';
import 'package:food_app/data/repositories/repository.dart';
import 'package:food_app/screens/home/bloc/recipe_page_event.dart';
import 'package:food_app/screens/home/bloc/recipe_page_state.dart';

class RecipePageBloc extends Bloc<RecipePageEvent, RecipePageState> {
  RecipePageBloc({
    required RecipePageState state,
    required Repository repository,
  }) : super(RecipePageState.initial()) {
    on<RecipePageEvent>((event, emit) => emit(state));

    on<FetchDataEvent>((event, emit) async {
      final recipes = await repository.fetchAllRecipes();
      emit(state.copyWith(recipesList: recipes));
    });
  }
}
