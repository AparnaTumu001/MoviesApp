import 'package:moviesapp/Models/results_model.dart';

class SearchMoviesModel {
  int _page;
  List<ResultsModel> _results;
  int _totalPages;
  int _totalResults;

  int get page => _page;

  List<ResultsModel> get results => _results;

  int get totalPages => _totalPages;

  int get totalResults => _totalResults;

  SearchMoviesModel.fromJson(dynamic json) {
    _page = json["page"];
    if (json["results"] != null) {
      _results = [];
      List resultsList = json['results'];
      for (int movie = 0; movie < resultsList.length; movie++) {
        _results.add(ResultsModel.fromJson(resultsList[movie]));
      }
      _totalPages = json["total_pages"];
      _totalResults = json["total_results"];
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["page"] = _page;
    if (_results != null) {
      map["results"] = _results.map((v) => v.toJson()).toList();
    }
    map["total_pages"] = _totalPages;
    map["total_results"] = _totalResults;
    return map;
  }
}


