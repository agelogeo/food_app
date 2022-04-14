import 'package:food_app/data/datasources/firebase_datasource.dart';
import 'package:food_app/data/models/recipe_model.dart';
import 'package:image_picker/image_picker.dart';

class Repository {
  final firebaseDataSource = FirebaseDataSource();

  Future<List<RecipeModel>> fetchAllRecipes() =>
      firebaseDataSource.fetchRecipeList();

  Future<void> removeRecipe(RecipeModel recipeModel) =>
      firebaseDataSource.removeRecipe(recipeModel);

  Future<void> addRecipe(RecipeModel recipeModel) =>
      firebaseDataSource.addRecipe(recipeModel);

  Future<String> uploadImage(PickedFile? pickedFile, String id) =>
      firebaseDataSource.uploadImage(pickedFile, id);
}
