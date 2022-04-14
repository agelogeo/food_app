import 'package:equatable/equatable.dart';

abstract class RecipePageEvent extends Equatable {}

class FetchDataEvent extends RecipePageEvent {
  @override
  List<Object?> get props => [];
}
