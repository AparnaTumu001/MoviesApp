import 'package:flutter/material.dart';
import 'package:moviesapp/Models/movie_details_model.dart';

import '../utils/apis_repo.dart';

class MovieDetailsApiProvider {
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    Map response = await ApisRepo.getMovieDetails(movieId);
    if (response['statusCode'] == 200 &&
        response['info'] != 'somethingwentwrong') {
      return MovieDetailsModel.fromJson(response['info']);
    } else {
      return null;
    }
  }
}

class MovieDetailsRepository {
  final apiProvider = new MovieDetailsApiProvider();
  Future<MovieDetailsModel> fetchMovieDetails(int movieId) =>
      apiProvider.getMovieDetails(movieId);
}
