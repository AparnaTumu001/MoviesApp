import 'package:moviesapp/Models/upcoming_movies_model.dart';
import 'package:moviesapp/repos/upcoming_movies_repo.dart';
import 'package:rxdart/rxdart.dart';

class UpcomingMoviesBloc {
  final upcomingMoviesRepo = UpcomingMoviesRepository();
  final moviesListFetcher = PublishSubject<UpcomingMoviesModel>();
  Stream<UpcomingMoviesModel> get moviesList => moviesListFetcher.stream;
  int currentPageIndex = 1;
  UpcomingMoviesModel globalMoviesListModel;
  fetchUpcomingMoviesList() async {
    if (_isDisposed) {
      return;
    }
    UpcomingMoviesModel upcomingMoviesModel =
        await upcomingMoviesRepo.fetchPopularMoviesList(
      currentPageIndex,
    );
    if (upcomingMoviesModel != null) {
      if (currentPageIndex == 1 || currentPageIndex == null) {
        globalMoviesListModel = upcomingMoviesModel;
      } else if (globalMoviesListModel != null) {
        globalMoviesListModel.results.addAll(upcomingMoviesModel.results);
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
