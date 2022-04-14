import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_app/data/models/recipe_model.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseDataSource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference recipes =
      FirebaseFirestore.instance.collection('recipes');

  Future<List<RecipeModel>> fetchRecipeList() async {
    QuerySnapshot querySnapshot = await recipes.get();

    final allData = querySnapshot.docs
        .map((doc) => RecipeModel.fromFirestore(doc))
        .toList();

    return allData;
  }

  Future<void> removeRecipe(RecipeModel recipeModel) {
    return recipes
        .doc(recipeModel.id)
        .delete()
        .then((value) => print("Recipe Deleted"))
        .catchError((error) => print("Failed to delete Recipe: $error"));
  }

  Future<void> addRecipe(RecipeModel recipeModel) {
    print(recipeModel.ingredients.map((e) => e.toMap()));
    return recipes
        .doc(recipeModel.id)
        .set(recipeModel.toMap())
        .then((value) => print("Recipe Added"))
        .catchError((error) => print("Failed to add Recipe: $error"));
  }

  Future<String> uploadImage(PickedFile? pickedFile, String id) async {
    if (pickedFile == null) return "";

    try {
      final imagesRef = storage.ref().child("images/$id.jpg");
      await imagesRef.putFile(File(pickedFile.path));
      return await imagesRef.getDownloadURL();
    } catch (e) {
      print('error occured');
      return "Error";
    }
  }
}
