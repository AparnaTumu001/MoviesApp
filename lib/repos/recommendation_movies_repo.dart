import 'package:moviesapp/Models/recommendation_movies_model.dart';
import 'package:moviesapp/utils/apis_repo.dart';

class RecommendationMoviesApiProvider{
  Future<RecommendationMoviesModel> getRecommendationMoviesList(int movieId) async {
    Map response = await ApisRepo.getRecommendationMoviesList(movieId);
    if (response['statusCode'] == 200 &&
        response['info'] != 'somethingwentwrong') {
      return RecommendationMoviesModel.fromJson(response['info']);
    } else {
      return null;
    }
  }
}

class RecommendationMoviesRepository{
  final apiProvider = new RecommendationMoviesApiProvider();
  Future<RecommendationMoviesModel> fetchRecommendedMovies(int movieId) =>
      apiProvider.getRecommendationMoviesList(movieId);
}