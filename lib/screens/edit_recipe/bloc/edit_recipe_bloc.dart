import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/utils/constants.dart';
import 'package:food_app/data/models/ingredient_w_quantity_model.dart';
import 'package:food_app/data/models/recipe_model.dart';
import 'package:food_app/data/repositories/repository.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_recipe_event.dart';
part 'edit_recipe_state.dart';

class EditRecipeBloc extends Bloc<EditRecipeEvent, EditRecipeState> {
  EditRecipeBloc({
    required Repository recipeRepository,
    required RecipeModel? initialRecipe,
  })  : _recipeRepository = recipeRepository,
        super(
          EditRecipeState(
              id: initialRecipe?.id ?? UniqueKey().toString(),
              initialRecipe: initialRecipe,
              title: initialRecipe?.title ?? '',
              subtitle: initialRecipe?.subtitle ?? '',
              imageUrl: initialRecipe?.imageUrl,
              ingredients: initialRecipe?.ingredients,
              steps: initialRecipe?.steps),
        ) {
    on<EditRecipeTitleChanged>((event, emit) {
      emit(state.copyWith(title: event.title));
    });

    on<AddNewStep>((event, emit) {
      List<String> newList = List.of(state.steps?.toList() ?? []);
      newList.add("");
      emit(state.copyWith(steps: newList));
    });

    on<AddNewIngredient>((event, emit) {
      List<IngredientWithQuantityModel> newList =
          List.of(state.ingredients?.toList() ?? []);
      newList.add(IngredientWithQuantityModel(name: "", quantity: 1, unit: ""));
      emit(state.copyWith(ingredients: newList));
    });

    on<RemoveStepAtIndex>((event, emit) {
      List<String> newList = List.of(state.steps?.toList() ?? []);
      newList.removeAt(event.index);
      emit(state.copyWith(steps: newList));
    });

    on<RemoveIngredientAtIndex>((event, emit) {
      List<IngredientWithQuantityModel> newList =
          List.of(state.ingredients?.toList() ?? []);
      newList.removeAt(event.index);
      emit(state.copyWith(ingredients: newList));
    });

    on<EditRecipeSubtitleChanged>((event, emit) {
      emit(state.copyWith(subtitle: event.subtitle));
    });

    on<InitialEvent>((event, emit) {
      emit(state.copyWith(initialRecipe: event.recipeModel));
    });

    on<EditRecipeImagePicker>((event, emit) async {
      var image = await ImagePicker().getImage(
          source: event.imageSource,
          imageQuality: 50,
          maxHeight: 1920,
          maxWidth: 1080,
          preferredCameraDevice: CameraDevice.rear);
      if (image != null) {
        debugPrint("IMAGE IS OKAY");
      }
      emit(state.copyWith(imageFile: image));
    });

    on<EditRecipeIngredientUnitChanged>((event, emit) {
      List<IngredientWithQuantityModel> newList =
          List.of(state.ingredients?.toList() ?? []);
      newList[event.index].unit =
          event.unitIndex == 0 ? "Piece" : units[event.unitIndex].symbol!;
      emit(state.copyWith(ingredients: newList));
    });

    on<EditRecipeIngredientQuantityChanged>((event, emit) {
      List<IngredientWithQuantityModel> newList =
          List.of(state.ingredients?.toList() ?? []);
      newList[event.index].quantity = event.quantity;
      emit(state.copyWith(ingredients: newList));
    });

    on<EditRecipeIngredientNameChanged>((event, emit) {
      List<IngredientWithQuantityModel> newList =
          List.of(state.ingredients?.toList() ?? []);
      newList[event.index].name = event.name;
      emit(state.copyWith(ingredients: newList));
    });

    on<EditRecipeStepChanged>((event, emit) {
      List<String> newList = List.of(state.steps?.toList() ?? []);
      newList[event.index] = event.name;
      emit(state.copyWith(steps: newList));
    });

    on<EditRecipeSubmitted>((event, emit) async {
      String? imageUrl;
      if (state.imageFile != null) {
        imageUrl =
            await recipeRepository.uploadImage(state.imageFile, state.id);
      }
      recipeRepository.addRecipe(RecipeModel(
          id: state.id,
          title: state.title,
          subtitle: state.subtitle,
          imageUrl: imageUrl ?? state.imageUrl ?? "",
          ingredients: state.ingredients ?? [],
          steps: state.steps ?? []));
      emit(state.copyWith(status: EditRecipeStatus.success));
    });
  }
  final Repository _recipeRepository;
}
