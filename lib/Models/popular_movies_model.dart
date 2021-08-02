
import 'package:moviesapp/Models/results_model.dart';

class PopularMoviesModel {
  int _page;
  List<ResultsModel> _results;
  int _totalPages;
  int _totalResults;

  int get page => _page;
  List<ResultsModel> get results => _results;
  int get totalPages => _totalPages;
  int get totalResults => _totalResults;

  PopularMoviesModel.fromJson(dynamic json) {
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