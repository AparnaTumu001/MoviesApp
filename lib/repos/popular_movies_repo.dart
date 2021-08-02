import 'package:moviesapp/Models/popular_movies_model.dart';
import 'package:moviesapp/utils/apis_repo.dart';

class PopularMoviesApiProvider {
  Future<PopularMoviesModel> getPopularMoviesList(int pageIndex) async {
    Map response = await ApisRepo.getPopularMoviesList(pageIndex);
    if (response['statusCode'] == 200 &&
        response['info'] != 'somethingwentwrong') {
      return PopularMoviesModel.fromJson(response['info']);
    } else {
      return null;
    }
  }
}

class PopularMoviesRepository {
  final apiProvider = new PopularMoviesApiProvider();
  Future<PopularMoviesModel> fetchPopularMoviesList(int pageIndex) =>
      apiProvider.getPopularMoviesList(pageIndex);
}
