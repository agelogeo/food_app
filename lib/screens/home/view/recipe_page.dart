import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/utils/constants.dart';
import 'package:food_app/data/models/recipe_model.dart';
import 'package:food_app/data/repositories/repository.dart';
import 'package:food_app/screens/detail_recipe/view/detail_recipe_page.dart';
import 'package:food_app/screens/edit_recipe/view/edit_recipe_page.dart';
import 'package:food_app/screens/home/bloc/recipe_page_bloc.dart';
import 'package:food_app/screens/home/bloc/recipe_page_event.dart';
import 'package:food_app/screens/home/bloc/recipe_page_state.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipePageBloc(
          repository: context.read<Repository>(),
          state: RecipePageState.initial())
        ..add(FetchDataEvent()),
      child: const RecipeView(),
    );
  }
}

class RecipeView extends StatelessWidget {
  const RecipeView({Key? key}) : super(key: key);

  Future<void> onEdit(
    BuildContext context,
    RecipeModel? model,
  ) async {
    await Navigator.of(context)
        .push(EditRecipePage.route(initialRecipe: model))
        .then((value) {
      context.read<RecipePageBloc>().add(FetchDataEvent());
    });
  }

  Future<void> onViewDetail(
    BuildContext context,
    RecipeModel model,
  ) async {
    await Navigator.of(context)
        .push(DetailRecipePage.route(recipe: model))
        .then((value) {
      context.read<RecipePageBloc>().add(FetchDataEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () =>
                  context.read<RecipePageBloc>().add(FetchDataEvent()),
              icon: const Icon(Icons.refresh_outlined))
        ],
      ),
      body: BlocBuilder<RecipePageBloc, RecipePageState>(
        builder: (ctx, state) {
          if (state.recipesList.isEmpty) {
            return Center(
              child: Image.asset(emptyListImage),
            );
          }
          const itemBoxHeight = 300.0;
          const whiteContainerWidth = 320.0;

          return ListView.builder(
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () => onViewDetail(context, state.recipesList[i]),
                //onTap: () => onEdit(context, state.recipesList[i]),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  width: double.infinity,
                  height: itemBoxHeight,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                        bottom: 20,
                        child: Container(
                          height: 130,
                          width: whiteContainerWidth,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 1.0),
                                blurRadius: 6.0,
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 36.0, left: 10, right: 10, bottom: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  state.recipesList[i].title,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2),
                                ),
                                Text(
                                  state.recipesList[i].subtitle,
                                  maxLines: 2,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0,
                            )
                          ],
                        ),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FadeInImage(
                                image:
                                    NetworkImage(state.recipesList[i].imageUrl),
                                placeholder: const AssetImage(logoPlaceholder),
                                height: 160,
                                imageErrorBuilder: (context, _, __) {
                                  return Image.asset(
                                    logoPlaceholder,
                                    height: 160,
                                    width: 320,
                                    fit: BoxFit.cover,
                                  );
                                },
                                width: 320,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 60,
                        right: 60,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 2.0),
                                blurRadius: 6.0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  state.recipesList[i].ingredients.length
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(
                                  Icons.category_outlined,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                                const Spacer(),
                                Text(
                                  state.recipesList[i].steps.length.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(
                                  Icons.assignment_outlined,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: state.recipesList.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addRecipe_floatingActionButton'),
        onPressed: () => onEdit(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
