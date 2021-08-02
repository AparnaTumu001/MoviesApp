import 'package:moviesapp/Models/top_rated_movies_model.dart';
import 'package:moviesapp/repos/top_rated_movies_repo.dart';
import 'package:rxdart/rxdart.dart';

class TopRatedMoviesBloc {
  final topRatedMoviesRepo = TopRatedMoviesRepository();
  final moviesListFetcher = PublishSubject<TopRatedMoviesModel>();
  Stream<TopRatedMoviesModel> get moviesList => moviesListFetcher.stream;
  int currentPageIndex = 1;
  TopRatedMoviesModel globalMoviesListModel;
  fetchTopRatedMoviesList() async {
    if (_isDisposed) {
      return;
    }
    TopRatedMoviesModel topRatedMoviesModel =
        await topRatedMoviesRepo.fetchTopRatedMoviesList(
      currentPageIndex,
    );
    if (topRatedMoviesModel != null) {
      if (currentPageIndex == 1 || currentPageIndex == null) {
        globalMoviesListModel = topRatedMoviesModel;
      } else if (globalMoviesListModel != null) {
        globalMoviesListModel.results.addAll(topRatedMoviesModel.results);
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
