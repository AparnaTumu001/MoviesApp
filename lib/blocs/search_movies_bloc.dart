import 'package:moviesapp/Models/search_movies_model.dart';
import 'package:moviesapp/repos/search_movies_repo.dart';
import 'package:rxdart/rxdart.dart';

class SearchMoviesBloc {
  final searchMoviesRepo = SearchMoviesRepository();
  final moviesListFetcher = PublishSubject<SearchMoviesModel>();
  Stream<SearchMoviesModel> get moviesList => moviesListFetcher.stream;
  int currentPageIndex = 1;
  SearchMoviesModel globalMoviesListModel;
  fetchSearchedMovies(String query) async {
    if (_isDisposed) {
      return;
    }
    SearchMoviesModel searchMoviesModel =
        await searchMoviesRepo.fetchSearchMoviesList(currentPageIndex, query);
    if (searchMoviesModel != null) {
      if (currentPageIndex == 1 || currentPageIndex == null) {
        globalMoviesListModel = searchMoviesModel;
      } else if (globalMoviesListModel != null) {
        globalMoviesListModel.results.addAll(searchMoviesModel.results);
      }
      moviesListFetcher.sink.add(globalMoviesListModel);
    } else {
      moviesListFetcher.sink.addError("Some thing went wrong");
    }
  }

  bool _isDisposed = false;
  dispose() {
    moviesListFetcher.close();
    _isDisposed = true;
  }
}
