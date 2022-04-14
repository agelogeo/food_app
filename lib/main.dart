import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/data/repositories/repository.dart';
import 'package:food_app/screens/home/view/recipe_page.dart';

import 'core/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Repository repository = Repository();
  runApp(App(repository: repository));
}

class App extends StatelessWidget {
  const App({Key? key, required this.repository}) : super(key: key);

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => repository,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.mainTheme,
        home: const RecipePage(),
      ),
    );
  }
}
