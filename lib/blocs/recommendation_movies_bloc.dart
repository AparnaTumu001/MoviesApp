import 'package:moviesapp/Models/recommendation_movies_model.dart';
import 'package:moviesapp/repos/recommendation_movies_repo.dart';
import 'package:rxdart/rxdart.dart';

class RecommendationMoviesBloc {
  final recommendationMoviesRepo = RecommendationMoviesRepository();
  final moviesListFetcher = PublishSubject<RecommendationMoviesModel>();
  Stream<RecommendationMoviesModel> get moviesList => moviesListFetcher.stream;
  int currentPageIndex = 1;
  fetchRecommendationMovies(int movieId) async {
    if (_isDisposed) {
      return;
    }
    RecommendationMoviesModel recommendationMoviesModel =
        await recommendationMoviesRepo.fetchRecommendedMovies(movieId);
    if (recommendationMoviesModel != null) {
      moviesListFetcher.sink.add(recommendationMoviesModel);
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
