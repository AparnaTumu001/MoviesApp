import 'package:moviesapp/Models/results_model.dart';

class TopRatedMoviesModel {
  int _page;
  List<ResultsModel> _results;
  int _totalPages;
  int _totalResults;

  int get page => _page;
  List<ResultsModel> get results => _results;
  int get totalPages => _totalPages;
  int get totalResults => _totalResults;

  TopRatedMoviesModel(
      {int page,
      List<ResultsModel> results,
      int totalPages,
      int totalResults}) {
    _page = page;
    _results = results;
    _totalPages = totalPages;
    _totalResults = totalResults;
  }

  TopRatedMoviesModel.fromJson(dynamic json) {
    _page = json["page"];
    if (json["results"] != null) {
      _results = [];
      json["results"].forEach((v) {
        _results.add(ResultsModel.fromJson(v));
      });
    }
    _totalPages = json["total_pages"];
    _totalResults = json["total_results"];
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
