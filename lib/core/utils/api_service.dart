import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:track_me_updated/features/exercises/data/models/exercise_model/exercise_model.dart';

class ApiService {
  final _recipeUrl = "https://api.spoonacular.com";
  final _exerciseUrl = "https://exercisedb.p.rapidapi.com";
  final Dio dio;
  ApiService(this.dio);
  Future<Map<String, dynamic>> getRecipe(
      String endPoint, Map<String, dynamic>? queryParameters) async {
    var response =
        await dio.get('$_recipeUrl$endPoint', queryParameters: queryParameters);
    return response.data;
  }

  Future<List<ExerciseModel>> getExercise(
      String endPoint, Map<String, dynamic>? queryParameters) async {
    var response = await dio.get('$_exerciseUrl$endPoint',
        queryParameters: queryParameters,
        options: Options(headers: {
          'X-RapidAPI-Key': dotenv.env['rapidApiKey'],
          'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com'
        }));
    List<dynamic> data = response.data;
    return data.map((e) => ExerciseModel.fromJson(e)).toList();
  }
}
