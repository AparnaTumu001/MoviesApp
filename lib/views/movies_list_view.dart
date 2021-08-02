import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moviesapp/blocs/popular_movies_bloc.dart';
import 'package:moviesapp/blocs/top_rated_movies_bloc.dart';
import 'package:moviesapp/blocs/upcoming_movies_bloc.dart';
import 'package:moviesapp/views/movie_view.dart';
import '../Models/results_model.dart';
import '../utils/apis_repo.dart';
import '../utils/custom_widgets.dart';

class MoviesListView extends StatefulWidget {
  bool isTopRated, isUpcoming, isPopular;
  MoviesListView(
    this.isPopular,
    this.isTopRated,
    this.isUpcoming, {
    Key key,
  }) : super(key: key);

  @override
  _MoviesListViewState createState() => _MoviesListViewState();
}

class _MoviesListViewState extends State<MoviesListView> {
  TopRatedMoviesBloc topRatedMoviesBloc;
  UpcomingMoviesBloc upcomingMoviesBloc;
  PopularMoviesBloc popularMoviesBloc;
  ScrollController _scrollController;
  bool readyForRequest = true;
  int _maxPageIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    //fetch the list based on the selected options
    if (widget.isTopRated) {
      topRatedMoviesBloc = new TopRatedMoviesBloc();
      fetchTopRatedMovies();
    }
    if (widget.isUpcoming) {
      upcomingMoviesBloc = new UpcomingMoviesBloc();
      fetchUpComingMovies();
    }
    if (widget.isPopular) {
      popularMoviesBloc = new PopularMoviesBloc();
      fetchPopularMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  fetchTopRatedMovies() async {
    await topRatedMoviesBloc.fetchTopRatedMoviesList();
  }

  fetchUpComingMovies() async {
    await upcomingMoviesBloc.fetchUpcomingMoviesList();
  }

  fetchPopularMovies() async {
    await popularMoviesBloc.fetchPopularMoviesList();
  }

  void _scrollListener() async {
    try {
      //Based on the scroll control position we will call Api the next page data.
      if (_scrollController.position.extentAfter < 100 &&
          readyForRequest == true &&
          currentIndex() <= _maxPageIndex) {
        readyForRequest = false;
        alertWithProgressBar(context);
        if (widget.isTopRated) {
          topRatedMoviesBloc.currentPageIndex++;
          await fetchTopRatedMovies();
        }
        if (widget.isUpcoming) {
          upcomingMoviesBloc.currentPageIndex++;
          await fetchUpComingMovies();
        }
        if (widget.isPopular) {
          popularMoviesBloc.currentPageIndex++;
          await fetchPopularMovies();
        }
        readyForRequest = true;
        Navigator.of(context).pop();
      }
    } catch (error) {
      print(error);
    }
  }

  int currentIndex() {
    if (widget.isPopular) {
      return popularMoviesBloc.currentPageIndex;
    }
    if (widget.isUpcoming) {
      return upcomingMoviesBloc.currentPageIndex;
    }

    if (widget.isTopRated) {
      return topRatedMoviesBloc.currentPageIndex;
    }
  }

  Stream<dynamic> currentStream() {
    if (widget.isTopRated) {
      return topRatedMoviesBloc.moviesList;
    }
    if (widget.isUpcoming) {
      return upcomingMoviesBloc.moviesList;
    }

    if (widget.isPopular) {
      return popularMoviesBloc.popularMoviesList;
    }
  }

  getTitle() {
    if (widget.isTopRated) {
      return "Top Rated Movies";
    }
    if (widget.isUpcoming) {
      return "Upcoming Movies";
    }
    if (widget.isPopular) {
      return "Popular Movies";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(getTitle()),
      ),
      body: StreamBuilder(
        stream: currentStream(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            _maxPageIndex = snapshot.data.totalPages;
            return StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              controller: _scrollController,
              itemCount: snapshot.data.results.length,
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              padding: const EdgeInsets.all(2),
              itemBuilder: (BuildContext context, int index) {
                ResultsModel resultsModel = snapshot.data.results[index];
                var percent = (resultsModel.voteAverage ?? 0) * 10;
                String strPercent = percent.toInt().toString();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (_) => new MovieView(resultsModel.id)));
                  },
                  child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      elevation: 5,
                      child: Stack(fit: StackFit.expand, children: [
                        resultsModel.posterPath != null
                            ? new Image.network(
                                imagesPath + resultsModel.posterPath,
                                fit: BoxFit.fill,
                              )
                            : new Image.asset(
                                "assets/default_movie_icon.png",
                                fit: BoxFit.fill,
                              ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: new EdgeInsets.all(5.0),
                            child: new CircleAvatar(
                              backgroundColor: Colors.green,
                              child: new Text(
                                strPercent + "%",
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                            ),
                          ),
                        )
                      ])),
                );
              },
            );
          } else if (snapshot.hasError) {
            return errorWidget();
          }
          return new Container();
        },
      ),
    );
  }
}
