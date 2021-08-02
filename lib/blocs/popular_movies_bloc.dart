import 'package:moviesapp/Models/popular_movies_model.dart';
import 'package:moviesapp/repos/popular_movies_repo.dart';
import 'package:rxdart/rxdart.dart';

class PopularMoviesBloc {
  final popularMoviesRepo = PopularMoviesRepository();
  final moviesListFetcher = PublishSubject<PopularMoviesModel>();
  Stream<PopularMoviesModel> get popularMoviesList => moviesListFetcher.stream;
  int currentPageIndex = 1;
  PopularMoviesModel globalMoviesListModel;
  fetchPopularMoviesList() async {
    if (_isDisposed) {
      return;
    }
    PopularMoviesModel popularMoviesModel =
        await popularMoviesRepo.fetchPopularMoviesList(
      currentPageIndex,
    );
    if (popularMoviesModel != null) {
      if (currentPageIndex == 1 || currentPageIndex == null) {
        globalMoviesListModel = popularMoviesModel;
      } else if (globalMoviesListModel != null) {
        globalMoviesListModel.results.addAll(popularMoviesModel.results);
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
