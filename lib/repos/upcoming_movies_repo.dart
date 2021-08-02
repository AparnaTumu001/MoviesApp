import 'package:moviesapp/Models/upcoming_movies_model.dart';
import 'package:moviesapp/utils/apis_repo.dart';

class UpcomingMoviesApiProvider {
  Future<UpcomingMoviesModel> getUpcomingMoviesList(int pageIndex) async {
    Map response = await ApisRepo.getUpcomingMoviesList(pageIndex);
    if (response['statusCode'] == 200 &&
        response['info'] != 'somethingwentwrong') {
      return UpcomingMoviesModel.fromJson(response['info']);
    } else {
      return null;
    }
  }
}

class UpcomingMoviesRepository {
  final apiProvider = new UpcomingMoviesApiProvider();
  Future<UpcomingMoviesModel> fetchPopularMoviesList(int pageIndex) =>
      apiProvider.getUpcomingMoviesList(pageIndex);
}
