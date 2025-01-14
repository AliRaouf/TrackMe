import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:track_me_updated/core/failures.dart';
import 'package:track_me_updated/core/utils/api_service.dart';
import 'package:track_me_updated/features/recipes/data/models/meal_planner_model/meal_planner_model/meal_planner_model.dart';
import 'package:track_me_updated/features/recipes/data/models/recipe_model/recipe_model.dart';
import 'package:track_me_updated/features/recipes/data/repo/recipe_repo.dart';

class RecipeRepoImplementation implements RecipeRepo {
  final ApiService apiService;

  RecipeRepoImplementation(this.apiService);
  @override
  Future<Either<Failures, List<RecipeModel>>> getRandomRecipes() async {
    try {
      var data = await apiService.getRecipe('/recipes/random', {
        'number': '10',
        'apiKey': dotenv.env['recipeApiKey'],
        'includeNutrition': "True"
      });
      List<RecipeModel> recipes = [];
      for (var item in data['recipes']) {
        recipes.add(RecipeModel.fromJson(item));
      }
      return right(recipes);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<RecipeModel>>> getSearchRecipes(
      {required String query}) async {
    try {
      var data = await apiService.getRecipe('/recipes/complexSearch', {
        'query': query,
        'addRecipeNutrition': "true",
        'addRecipeInstructions': "true",
        'sort': 'popularity',
        'apiKey': dotenv.env['recipeApiKey']
      });
      List<RecipeModel> recipes = [];
      for (var item in data['results']) {
        recipes.add(RecipeModel.fromJson(item));
      }
      return right(recipes);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, MealPlannerModel>> getMealPlan(
      String day, targetCalories, diet, exclude) async {
    try {
      var data = await apiService.getRecipe('/mealplanner/generate', {
        'timeFrame': day,
        'targetCalories': targetCalories,
        'apiKey': dotenv.env['recipeApiKey'],
        'diet': diet,
        'exclude': exclude
      });

      return right(MealPlannerModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, RecipeModel>> getRecipeByID({required int id}) async {
    try {
      var data = await apiService.getRecipe('/recipes/$id/information',
          {'includeNutrition': 'true', 'apiKey': dotenv.env['recipeApiKey']});

      return right(RecipeModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
