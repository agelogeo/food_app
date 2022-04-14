import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/utils/constants.dart';
import 'package:food_app/data/models/ingredient_w_quantity_model.dart';
import 'package:food_app/data/models/recipe_model.dart';
import 'package:food_app/data/repositories/repository.dart';
import 'package:food_app/screens/edit_recipe/bloc/edit_recipe_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:units_converter/units_converter.dart';

class EditRecipePage extends StatelessWidget {
  const EditRecipePage({Key? key, this.initialRecipe}) : super(key: key);

  final RecipeModel? initialRecipe;

  static PageRoute route({RecipeModel? initialRecipe}) {
    return MaterialPageRoute(
        builder: (context) => EditRecipePage(
              initialRecipe: initialRecipe,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditRecipeBloc(
          recipeRepository: context.read<Repository>(),
          initialRecipe: initialRecipe),
      child: const EditRecipeView(),
    );
  }
}

class EditRecipeView extends StatelessWidget {
  const EditRecipeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final l10n = context.l10n;
    final status = context.select((EditRecipeBloc bloc) => bloc.state.status);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(editPageTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: status.isLoadingOrSuccess
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  context
                      .read<EditRecipeBloc>()
                      .add(const EditRecipeSubmitted());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(invalidData)),
                  );
                }
              },
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: BlocConsumer<EditRecipeBloc, EditRecipeState>(
            listener: (context, state) {
          if (state.status == EditRecipeStatus.success) {
            Navigator.of(context).pop();
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const _TitleField(),
                    const _SubtitleField(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // CHECK IF IMAGE HAS NOT BEEN TAKEN SHOW THE STORED ONE
                        state.imageFile != null
                            ? SizedBox(
                                child: Image.file(File(state.imageFile!.path)),
                                height: 150,
                                width: 100,
                              )
                            : state.imageUrl != null &&
                                    (state.imageUrl?.isNotEmpty ?? false)
                                ? SizedBox(
                                    child: Image.network(state.imageUrl!),
                                    height: 150,
                                    width: 100,
                                  )
                                : Container(),
                        Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.camera),
                                onPressed: () => context
                                    .read<EditRecipeBloc>()
                                    .add(const EditRecipeImagePicker(
                                        ImageSource.camera)),
                                label: const Text(camera)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.collections_outlined),
                                onPressed: () => context
                                    .read<EditRecipeBloc>()
                                    .add(const EditRecipeImagePicker(
                                        ImageSource.gallery)),
                                label: const Text(gallery)),
                          )
                        ]),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      padding: const EdgeInsets.all(8),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${state.ingredients?.length ?? 0} Ingredients",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return IngredientInputRow(
                                ingredient: state.ingredients![index],
                                index: index);
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.ingredients?.length ?? 0,
                        ),
                        (state.ingredients?.length ?? 0) < maxIngredients
                            ? ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<EditRecipeBloc>()
                                      .add(const AddNewIngredient());
                                },
                                child: const Icon(Icons.add))
                            : Container(),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      padding: const EdgeInsets.all(8),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${state.steps?.length ?? 0} Steps",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return StepInputRow(
                                step: state.steps![index], index: index);
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.steps?.length ?? 0,
                        ),
                        (state.steps?.length ?? 0) < maxSteps
                            ? ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<EditRecipeBloc>()
                                      .add(const AddNewStep());
                                },
                                child: const Icon(Icons.add))
                            : Container(),
                      ]),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class IngredientInputRow extends StatefulWidget {
  IngredientInputRow({Key? key, required this.ingredient, required this.index})
      : super(key: key);

  final int index;
  final IngredientWithQuantityModel ingredient;

  @override
  State<IngredientInputRow> createState() => _IngredientInputRowState();
}

class _IngredientInputRowState extends State<IngredientInputRow> {
  @override
  Widget build(BuildContext context) {
    final unit =
        context.watch<EditRecipeBloc>().state.ingredients![widget.index].unit;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
                hintText: "e.x 5",
                suffixIcon:
                    // DropdownButton(
                    //   items: units.map((e) {
                    //     return DropdownMenuItem(
                    //       child: Text(e.symbol!),
                    //       value: e.symbol,
                    //     );
                    //   }).toList(),
                    //   onChanged: (String? value) {
                    //     setState(() {
                    //       context.read<EditRecipeBloc>().add(
                    //           EditRecipeIngredientUnitChanged(
                    //               widget.index, value!));
                    //     });
                    //   },
                    // )
                    TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return SizedBox(
                            height: 200,
                            child: CupertinoPicker(
                              key: UniqueKey(),
                              backgroundColor: Colors.grey[100],
                              scrollController:
                                  FixedExtentScrollController(initialItem: 0),
                              children: units.map((e) {
                                return Center(
                                    child: Text(e.symbol ==
                                            NumeralSystems().decimal.symbol
                                        ? "Piece"
                                        : e.symbol!));
                              }).toList(),
                              itemExtent: 40,
                              onSelectedItemChanged: (unitIndex) {
                                context.read<EditRecipeBloc>().add(
                                    EditRecipeIngredientUnitChanged(
                                        widget.index, unitIndex));
                                setState(() {});
                              },
                            ),
                          );
                        });
                  },
                  child: Text(unit.isEmpty ? "Piece" : unit),
                ),
              ),
              initialValue: widget.ingredient.quantity.toString(),
              onChanged: (value) => context.read<EditRecipeBloc>().add(
                  EditRecipeIngredientQuantityChanged(
                      double.tryParse(value) ?? 1, widget.index)),
            ),
            flex: 5,
          ),
          const SizedBox(width: 10),
          Flexible(
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: "Name", hintText: "teaspoons of sugar"),
                onChanged: (value) => context
                    .read<EditRecipeBloc>()
                    .add(EditRecipeIngredientNameChanged(value, widget.index)),
                initialValue: widget.ingredient.name,
              ),
              flex: 7),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context
                  .read<EditRecipeBloc>()
                  .add(RemoveIngredientAtIndex(widget.index));
            },
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class StepInputRow extends StatelessWidget {
  const StepInputRow({Key? key, required this.step, required this.index})
      : super(key: key);

  final int index;
  final String step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Step ${(index + 1)}",
                    hintText: "Preheat oven to 350 degrees "),
                onChanged: (value) => context
                    .read<EditRecipeBloc>()
                    .add(EditRecipeStepChanged(value, index)),
                initialValue: step,
              ),
              flex: 7),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<EditRecipeBloc>().add(RemoveStepAtIndex(index));
            },
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;
    final state = context.watch<EditRecipeBloc>().state;
    const hintText = 'Title';

    return TextFormField(
      key: const Key('recipeTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: const InputDecoration(
        labelText: hintText,
      ),
      maxLength: 150,
      onChanged: (value) {
        context.read<EditRecipeBloc>().add(EditRecipeTitleChanged(value));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}

class _SubtitleField extends StatelessWidget {
  const _SubtitleField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final l10n = context.l10n;

    final state = context.watch<EditRecipeBloc>().state;
    const hintText = 'Subtitle';

    return TextFormField(
      key: const Key('recipeTodoView_description_textFormField'),
      initialValue: state.subtitle,
      decoration: const InputDecoration(
        labelText: hintText,
      ),
      maxLength: 300,
      maxLines: 3,
      onChanged: (value) {
        context.read<EditRecipeBloc>().add(EditRecipeSubtitleChanged(value));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}
