import 'package:moviesapp/Models/movie_details_model.dart';
import 'package:moviesapp/repos/movie_details_repo.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailsBloc {
  final movieDetailsRepo = MovieDetailsRepository();
  final moviesListFetcher = PublishSubject<MovieDetailsModel>();
  Stream<MovieDetailsModel> get movieDetailsStream => moviesListFetcher.stream;
  fetchMovieDetails(movieId) async {
    if (_isDisposed) {
      return;
    }
    MovieDetailsModel movieDetailsModel =
        await movieDetailsRepo.fetchMovieDetails(movieId);
    if (movieDetailsModel != null) {
      moviesListFetcher.sink.add(movieDetailsModel);
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
