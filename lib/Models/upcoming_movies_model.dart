import 'package:moviesapp/Models/results_model.dart';

class UpcomingMoviesModel {
  Dates _dates;
  int _page;
  List<ResultsModel> _results;
  int _totalPages;
  int _totalResults;

  Dates get dates => _dates;
  int get page => _page;
  List<ResultsModel> get results => _results;
  int get totalPages => _totalPages;
  int get totalResults => _totalResults;

  UpcomingMoviesModel({
      Dates dates, 
      int page, 
      List<ResultsModel> results,
      int totalPages, 
      int totalResults}){
    _dates = dates;
    _page = page;
    _results = results;
    _totalPages = totalPages;
    _totalResults = totalResults;
}

  UpcomingMoviesModel.fromJson(dynamic json) {
    _dates = json["dates"] != null ? Dates.fromJson(json["dates"]) : null;
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
    if (_dates != null) {
      map["dates"] = _dates.toJson();
    }
    map["page"] = _page;
    if (_results != null) {
      map["results"] = _results.map((v) => v.toJson()).toList();
    }
    map["total_pages"] = _totalPages;
    map["total_results"] = _totalResults;
    return map;
  }

}

class Dates {
  String _maximum;
  String _minimum;

  String get maximum => _maximum;
  String get minimum => _minimum;

  Dates({
      String maximum, 
      String minimum}){
    _maximum = maximum;
    _minimum = minimum;
}

  Dates.fromJson(dynamic json) {
    _maximum = json["maximum"];
    _minimum = json["minimum"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["maximum"] = _maximum;
    map["minimum"] = _minimum;
    return map;
  }

}