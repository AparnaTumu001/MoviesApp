import 'package:moviesapp/Models/search_movies_model.dart';

import '../utils/apis_repo.dart';

class SearchMoviesApiProvider {
  Future<SearchMoviesModel> getSearchMoviesList(
      int pageIndex, String query) async {
    Map response = await ApisRepo.getSearchedMoviesList(pageIndex, query);
    if (response['statusCode'] == 200 &&
        response['info'] != 'somethingwentwrong') {
      return SearchMoviesModel.fromJson(response['info']);
    } else {
      return null;
    }
  }
}

class SearchMoviesRepository {
  final apiProvider = new SearchMoviesApiProvider();
  Future<SearchMoviesModel> fetchSearchMoviesList(
          int pageIndex, String query) =>
      apiProvider.getSearchMoviesList(pageIndex, query);
}
