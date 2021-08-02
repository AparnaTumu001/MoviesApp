import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final apiKey = "6584f558b699da04586abff2b4f70716";
final baseUrl = "https://api.themoviedb.org/3/movie/";
final searchMoviesApi = "https://api.themoviedb.org/3/search/movie";
final imagesPath = "https://image.tmdb.org/t/p/original";

class ApisRepo {
  static Future<dynamic> getPopularMoviesList(int page) async {
    var response = await http.get(Uri.parse(
        baseUrl + "popular?api_key=" + apiKey + "&page=" + page.toString()));
    Map<dynamic, dynamic> jsonData = {"statusCode": response.statusCode};
    if (response.statusCode == 200) {
      jsonData['info'] = json.decode(response.body);
    } else {
      jsonData['info'] = "Please try after sometime";
    }
    return jsonData;
  }

  static Future<dynamic> getUpcomingMoviesList(int page) async {
    var response = await http.get(Uri.parse(
        baseUrl + "upcoming?api_key=" + apiKey + "&page=" + page.toString()));
    Map<dynamic, dynamic> jsonData = {"statusCode": response.statusCode};
    if (response.statusCode == 200) {
      jsonData['info'] = json.decode(response.body);
    } else {
      jsonData['info'] = "Please try after sometime";
    }
    return jsonData;
  }

  static Future<dynamic> getTopRatedMoviesList(int page) async {
    var response = await http.get(Uri.parse(
        baseUrl + "top_rated?api_key=" + apiKey + "&page=" + page.toString()));
    Map<dynamic, dynamic> jsonData = {"statusCode": response.statusCode};
    if (response.statusCode == 200) {
      jsonData['info'] = json.decode(response.body);
    } else {
      jsonData['info'] = "Please try after sometime";
    }
    return jsonData;
  }

  static Future<dynamic> getSearchedMoviesList(int page, String query) async {
    var response = await http.get(Uri.parse(searchMoviesApi +
        "?api_key=" +
        apiKey +
        "&query=" +
        query +
        "&page=" +
        page.toString()));
    Map<dynamic, dynamic> jsonData = {"statusCode": response.statusCode};
    if (response.statusCode == 200) {
      jsonData['info'] = json.decode(response.body);
    } else {
      jsonData['info'] = "Please try after sometime";
    }
    return jsonData;
  }

  static Future<dynamic> getMovieDetails(int movieId) async {
    var response = await http
        .get(Uri.parse(baseUrl + movieId.toString() + "?api_key=" + apiKey));
    Map<dynamic, dynamic> jsonData = {"statusCode": response.statusCode};
    if (response.statusCode == 200) {
      jsonData['info'] = json.decode(response.body);
    } else {
      jsonData['info'] = "Please try after sometime";
    }
    return jsonData;
  }

  static Future<dynamic> getRecommendationMoviesList(int movieId) async {
    var response = await http.get(Uri.parse(
        baseUrl + movieId.toString() + "/recommendations?api_key=" + apiKey));
    Map<dynamic, dynamic> jsonData = {"statusCode": response.statusCode};
    if (response.statusCode == 200) {
      jsonData['info'] = json.decode(response.body);
    } else {
      jsonData['info'] = "Please try after sometime";
    }
    return jsonData;
  }
}
