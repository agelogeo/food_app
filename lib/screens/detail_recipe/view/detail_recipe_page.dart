import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/utils/constants.dart';
import 'package:food_app/data/models/ingredient_w_quantity_model.dart';
import 'package:food_app/data/models/recipe_model.dart';
import 'package:food_app/data/repositories/repository.dart';
import 'package:food_app/screens/detail_recipe/bloc/detail_recipe_bloc.dart';
import 'package:food_app/screens/edit_recipe/view/edit_recipe_page.dart';

class DetailRecipePage extends StatelessWidget {
  const DetailRecipePage({Key? key, required this.recipe}) : super(key: key);

  final RecipeModel recipe;

  static PageRoute route({required RecipeModel recipe}) {
    return MaterialPageRoute(
        builder: (context) => DetailRecipePage(
              recipe: recipe,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailRecipeBloc(
          repository: context.read<Repository>(), recipe: recipe),
      child: const DetailRecipeView(),
    );
  }
}

class DetailRecipeView extends StatelessWidget {
  const DetailRecipeView({Key? key}) : super(key: key);

  Future<void> onEdit(
    BuildContext context,
    RecipeModel? model,
  ) async {
    Navigator.of(context)
        .pushReplacement(EditRecipePage.route(initialRecipe: model));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<DetailRecipeBloc, DetailRecipeState>(
          builder: (context, state) {
        if (state.status == DetailRecipeStatus.deleted) {
          Navigator.of(context).pop();
        }
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  title: Text(
                    state.recipe.title,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              offset: Offset(1.5, 1.5),
                              blurRadius: 1)
                        ]),
                  ),
                  pinned: true,
                  expandedHeight: 300,
                  flexibleSpace: CustomFlexibleSpaceBar(recipe: state.recipe),
                  actions: [
                    IconButton(
                        onPressed: () => context
                            .read<DetailRecipeBloc>()
                            .add(DeleteRecipeEvent(state.recipe)),
                        icon: const Icon(Icons.delete)),
                    IconButton(
                        onPressed: () => onEdit(context, state.recipe),
                        icon: const Icon(Icons.edit))
                  ],
                ),
              ),
            ),
          ],
          body: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  state.recipe.subtitle,
                  style: const TextStyle(color: Colors.black54),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const ShowDivider(),
              IngredientsRow(ingredients: state.recipe.ingredients),
              const ShowDivider(),
              StepsRow(steps: state.recipe.steps),
            ],
          ),
        );
      }),
    );
  }
}

class IngredientsRow extends StatelessWidget {
  IngredientsRow({
    Key? key,
    required this.ingredients,
  }) : super(key: key);

  List<IngredientWithQuantityModel> ingredients;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 5),
          const Text(
            'Ingredients',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      "${ingredients[index].quantity} ${ingredients[index].unit} ${ingredients[index].name}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              );
            },
            itemCount: ingredients.length,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class StepsRow extends StatelessWidget {
  StepsRow({
    Key? key,
    required this.steps,
  }) : super(key: key);

  List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 5),
          const Text(
            'Steps',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      steps[index],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              );
            },
            itemCount: steps.length,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class ShowDivider extends StatelessWidget {
  const ShowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(thickness: 1, endIndent: 20, indent: 20);
  }
}

class CustomFlexibleSpaceBar extends StatelessWidget {
  const CustomFlexibleSpaceBar({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      background: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: Stack(
            children: [
              FadeInImage(
                image: NetworkImage(recipe.imageUrl),
                placeholder: const AssetImage(logoPlaceholder),
                imageErrorBuilder: (context, _, __) {
                  return Image.asset(
                    logoPlaceholder,
                    fit: BoxFit.cover,
                  );
                },
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black45),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 1.0, top: 3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          recipe.title,
                          maxLines: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            fit: StackFit.expand,
          )

          // Container(
          //   padding: EdgeInsets.only(bottom: 0),
          //   child: Hero(
          //     tag: selectedMeal.imageUrl,
          //     child: Stack(
          //       fit: StackFit.expand,
          //       children: <Widget>[
          //         FadeInImage(
          //           placeholder: AssetImage('assets/images/food_placeholder.png'),
          //           fit: BoxFit.cover,
          //           image: NetworkImage(selectedMeal.imageUrl),
          //         ),
          //         Positioned(
          //             bottom: 0,
          //             right: 0,
          //             left: 0,
          //             height: 50,
          //             child: Container(
          //               decoration: BoxDecoration(color: Colors.black54),
          //               child: GestureDetector(
          //                 onTap: () => print('GO TO PROFILE SCREN'),
          //                 child: Row(
          //                   children: <Widget>[
          //                     SizedBox(
          //                       width: 5,
          //                     ),
          //                     ClipRRect(
          //                       borderRadius: BorderRadius.circular(8),
          //                       child: Image.asset(
          //                         'assets/images/profile.jpg',
          //                         height: 40,
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       width: 5,
          //                     ),
          //                     Expanded(
          //                       child: Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: <Widget>[
          //                           SizedBox(
          //                             height: 5,
          //                           ),
          //                           Text(
          //                             'Published by',
          //                             textAlign: TextAlign.start,
          //                             style: TextStyle(
          //                                 fontSize: 14, color: Colors.white60),
          //                           ),
          //                           Text(
          //                             'Giorgos Angelopoulos',
          //                             style: TextStyle(
          //                                 fontSize: 16, color: Colors.white),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     Icon(
          //                       Icons.star_half,
          //                       color: Colors.yellowAccent,
          //                     ),
          //                     SizedBox(
          //                       width: 2,
          //                     ),
          //                     Text(
          //                       '4.5',
          //                       style:
          //                           TextStyle(fontSize: 16, color: Colors.white),
          //                     ),
          //                     SizedBox(
          //                       width: 15,
          //                     )
          //                   ],
          //                 ),
          //               ),
          //             )),
          //       ],
          //     ),
          //   ),
          // ),
          ),
    );
  }
}
