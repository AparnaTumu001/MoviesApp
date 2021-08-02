import 'package:flutter/material.dart';
import 'package:moviesapp/utils/apis_repo.dart';
import 'package:moviesapp/blocs/movie_details_bloc.dart';
import 'package:moviesapp/blocs/recommendation_movies_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../Models/movie_details_model.dart';
import '../Models/recommendation_movies_model.dart';
import '../Models/results_model.dart';
import '../utils/custom_widgets.dart';

class MovieView extends StatefulWidget {
  var movieId;
  MovieView(this.movieId, {Key key}) : super(key: key);

  @override
  _MovieViewState createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  MovieDetailsBloc movieDetailsBloc;
  RecommendationMoviesBloc recommendationMoviesBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieDetailsBloc = new MovieDetailsBloc();
    recommendationMoviesBloc = new RecommendationMoviesBloc();
    fetchMovieDetails();
  }

  //Fetch selected movie details
  fetchMovieDetails() async {
    await movieDetailsBloc.fetchMovieDetails(widget.movieId);
  }

  //Fetch recommended movies
  fetchRecommendedMovies() async {
    await recommendationMoviesBloc.fetchRecommendationMovies(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: movieDetailsBloc.movieDetailsStream,
        builder:
            (BuildContext context, AsyncSnapshot<MovieDetailsModel> snapshot) {
          if (snapshot.hasData) {
            fetchRecommendedMovies();//on getting the details get the recommended movies list
            MovieDetailsModel movieDetailsModel = snapshot.data;

            return Align(
                alignment: Alignment.topLeft,
                child: new SafeArea(
                  left: false,
                  top: false,
                  right: false,
                  bottom: false,
                  child: Scaffold(
                    body: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              kIsWeb
                                  ? webViewWidgets(movieDetailsModel)
                                  : childrenWidget(
                                      movieDetailsModel,
                                    ),
                              Container(
                                margin: new EdgeInsets.all(10.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Text(
                                      "Recommended Movies",
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    new SizedBox(
                                      height: 5.0,
                                    ),
                                    new StreamBuilder(
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  RecommendationMoviesModel>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          RecommendationMoviesModel
                                              recommendationMoviesModel =
                                              snapshot.data;
                                          List<ResultsModel> resultsList =
                                              recommendationMoviesModel.results;
                                          return Container(
                                            height: 200.0,
                                            child: resultsList.length > 0
                                                ? ListView.builder(
                                                    physics:
                                                        ClampingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        resultsList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      ResultsModel
                                                          topRatedResultsModel =
                                                          resultsList[index];
                                                      return Card(
                                                        semanticContainer: true,
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        elevation: 5,
                                                        child: InkWell(
                                                          child: Center(
                                                              child: topRatedResultsModel
                                                                          .posterPath !=
                                                                      null
                                                                  ? new Image
                                                                      .network(
                                                                      imagesPath +
                                                                          topRatedResultsModel
                                                                              .posterPath,
                                                                    )
                                                                  : new Image
                                                                          .asset(
                                                                      "assets/default_movie_icon.png")),
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                new MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        new MovieView(
                                                                            topRatedResultsModel.id)));
                                                          },
                                                        ),
                                                      );
                                                    })
                                                : new Text("No movies found"),
                                          );
                                        }
                                        return new Container();
                                      },
                                      stream:
                                          recommendationMoviesBloc.moviesList,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: new EdgeInsets.only(top: 50.0, left: 10.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white.withOpacity(0.5),
                              child: IconButton(
                                  color: Colors.black,
                                  padding: EdgeInsets.all(10),
                                  iconSize: 15,
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          } else if (snapshot.hasError) {
            return Align(
                alignment: Alignment.topLeft,
                child: new SafeArea(
                    left: false,
                    top: false,
                    right: false,
                    bottom: false,
                    child: Scaffold(body: errorWidget())));
          }
          return new Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget childrenWidget(MovieDetailsModel movieDetailsModel) {
    String genreName = "";
    if (movieDetailsModel.genres != null) {
      for (int genre = 0; genre < movieDetailsModel.genres.length; genre++) {
        if (genre != 0) {
          genreName += " | ";
        }
        genreName += movieDetailsModel.genres[genre].name;
      }
    }
    String spokenLanguages = "";
    if (movieDetailsModel.spokenLanguages != null) {
      for (int lang = 0;
          lang < movieDetailsModel.spokenLanguages.length;
          lang++) {
        if (lang != 0) {
          spokenLanguages += " | ";
        }
        spokenLanguages += movieDetailsModel.spokenLanguages[lang].englishName;
      }
    }
    var columnWidgets = [
      Container(
        height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.width,
        child: new Image.network(
          imagesPath + movieDetailsModel.posterPath,
          fit: BoxFit.fill,
        ),
      ),
      Container(
        margin: new EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    movieDetailsModel.title,
                    style: new TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w700),
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: new Row(
                        children: [
                          new Text(genreName),
                          new SizedBox(width: 5.0),
                          new CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 3.0,
                          ),
                          new SizedBox(width: 5.0),
                          new Text(
                              movieDetailsModel.runtime.toString() + " min")
                        ],
                      )),
                  new SizedBox(
                    height: 5.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Text("Release Date: "),
                      new Text(
                          getCustomDateFormat(movieDetailsModel.releaseDate))
                    ],
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(5.0),
                            color: Colors.orangeAccent),
                        padding: new EdgeInsets.all(5.0),
                        child: new Text(
                          movieDetailsModel.voteAverage != null
                              ? movieDetailsModel.voteAverage.toString()
                              : "0",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(5.0),
                            color: Colors.green),
                        padding: new EdgeInsets.all(5),
                        child: new Text(
                          spokenLanguages != null ? spokenLanguages : "",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      movieDetailsModel.adult
                          ? Container(
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  color: Colors.red),
                              padding:
                                  new EdgeInsets.only(left: 5.0, right: 5.0),
                              child: new Text(
                                "18+",
                                style: new TextStyle(color: Colors.white),
                              ),
                            )
                          : new Container()
                    ],
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  new Text(
                    "Summary",
                    style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  new SizedBox(
                    height: 5.0,
                  ),
                  new Text(
                    movieDetailsModel.overview,
                    style: new TextStyle(color: Colors.white70),
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
    return new Column(
      children: columnWidgets,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget webViewWidgets(MovieDetailsModel movieDetailsModel) {
    String genreName = "";
    if (movieDetailsModel.genres != null) {
      for (int genre = 0; genre < movieDetailsModel.genres.length; genre++) {
        if (genre != 0) {
          genreName += " | ";
        }
        genreName += movieDetailsModel.genres[genre].name;
      }
    }
    String spokenLanguages = "";
    if (movieDetailsModel.spokenLanguages != null) {
      for (int lang = 0;
          lang < movieDetailsModel.spokenLanguages.length;
          lang++) {
        if (lang != 0) {
          spokenLanguages += " | ";
        }
        spokenLanguages += movieDetailsModel.spokenLanguages[lang].englishName;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: new EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height / 4,
              //width: MediaQuery.of(context).size.width / 3,
              child: new Image.network(
                imagesPath + movieDetailsModel.posterPath,
                //fit: BoxFit.fill,
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  movieDetailsModel.title,
                  style: new TextStyle(
                      fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
                new Row(
                  children: [
                    new Text(genreName),
                    new SizedBox(width: 5.0),
                    new CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 3.0,
                    ),
                    new SizedBox(width: 5.0),
                    new Text(movieDetailsModel.runtime.toString() + " min"),
                  ],
                ),
                new SizedBox(
                  height: 5.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Text("Release Date: "),
                    new Text(getCustomDateFormat(movieDetailsModel.releaseDate))
                  ],
                ),
                new SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(5.0),
                          color: Colors.orangeAccent),
                      padding: new EdgeInsets.all(5.0),
                      child: new Text(
                        movieDetailsModel.voteAverage != null
                            ? movieDetailsModel.voteAverage.toString()
                            : "0",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(5.0),
                          color: Colors.green),
                      padding: new EdgeInsets.all(5),
                      child: new Text(
                        spokenLanguages != null ? spokenLanguages : "",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    movieDetailsModel.adult
                        ? Container(
                            decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(5.0),
                                color: Colors.red),
                            padding: new EdgeInsets.only(left: 5.0, right: 5.0),
                            child: new Text(
                              "18+",
                              style: new TextStyle(color: Colors.white),
                            ),
                          )
                        : new Container()
                  ],
                ),
              ],
            )
          ],
        ),
        new SizedBox(
          height: 10.0,
        ),
        Container(
          margin: new EdgeInsets.all(10.0),
          child: new Text(
            "Summary",
            style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ),
        new SizedBox(
          height: 5.0,
        ),
        Container(
          margin: new EdgeInsets.all(10.0),
          child: new Text(
            movieDetailsModel.overview,
            style: new TextStyle(color: Colors.white70, fontSize: 18.0),
          ),
        ),
        new SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
