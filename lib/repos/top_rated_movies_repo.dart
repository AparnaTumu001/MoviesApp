import 'package:moviesapp/Models/top_rated_movies_model.dart';

import '../utils/apis_repo.dart';

class TopRatedMoviesProvider {
  Future<TopRatedMoviesModel> getTopRatedMoviesList(int pageIndex) async {
    Map response = await ApisRepo.getTopRatedMoviesList(pageIndex);
    if (response['statusCode'] == 200 &&
        response['info'] != 'somethingwentwrong') {
      return TopRatedMoviesModel.fromJson(response['info']);
    } else {
      return null;
    }
  }
}

class TopRatedMoviesRepository {
  final apiProvider = new TopRatedMoviesProvider();
  Future<TopRatedMoviesModel> fetchTopRatedMoviesList(int pageIndex) =>
      apiProvider.getTopRatedMoviesList(pageIndex);
}
