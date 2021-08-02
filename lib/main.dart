import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:moviesapp/Models/top_rated_movies_model.dart';
import 'package:moviesapp/Models/upcoming_movies_model.dart';
import 'package:moviesapp/blocs/popular_movies_bloc.dart';
import 'package:moviesapp/blocs/top_rated_movies_bloc.dart';
import 'package:moviesapp/blocs/upcoming_movies_bloc.dart';
import 'package:moviesapp/views/movie_view.dart';
import 'package:moviesapp/repos/search_movies_repo.dart';
import 'package:moviesapp/views/movies_list_view.dart';
import 'Models/popular_movies_model.dart';
import 'Models/results_model.dart';
import 'Models/search_movies_model.dart';
import 'utils/apis_repo.dart';
import 'blocs/search_movies_bloc.dart';
import 'utils/custom_widgets.dart';

//App Entry point
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieNow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of the application.
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: "JosefinSans",
      ),
      home: MyHomePage(title: 'MovieNow'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TopRatedMoviesBloc topRatedMoviesBloc = TopRatedMoviesBloc();
  UpcomingMoviesBloc upcomingMoviesBloc = UpcomingMoviesBloc();
  PopularMoviesBloc popularMoviesBloc = PopularMoviesBloc();
  SearchMoviesApiProvider searchMoviesApiProvider;
  SearchMoviesModel searchMoviesModel;
  final controller = FloatingSearchBarController();
  ScrollController _scrollController;
  int _maxPageIndex = 0;
  bool readyForRequest = true;
  String query = "";
  SearchMoviesBloc searchMoviesBloc = new SearchMoviesBloc();
  @override
  void initState() {
    super.initState();
    fetchTopRatedMovies();
    fetchUpComingMovies();
    fetchPopularMovies();
    _scrollController = new ScrollController()
      ..addListener(
          _scrollListener); //Scroll Controller to listen to search movies list
  }

  @override
  void dispose() {
    //Dispose all the controllers
    _scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  //Fetch top rated movies
  fetchTopRatedMovies() async {
    await topRatedMoviesBloc.fetchTopRatedMoviesList();
  }

  //fetch upcoming movies
  fetchUpComingMovies() async {
    await upcomingMoviesBloc.fetchUpcomingMoviesList();
  }

  //fetch popular movies
  fetchPopularMovies() async {
    await popularMoviesBloc.fetchPopularMoviesList();
  }

  void _scrollListener() async {
    try {
      //Based on the scroll control position we will call Api the next page data.
      if (_scrollController.position.extentAfter < 100 &&
          readyForRequest == true &&
          searchMoviesBloc.currentPageIndex <= _maxPageIndex) {
        readyForRequest = false;
        alertWithProgressBar(context);
        await searchMoviesBloc.fetchSearchedMovies(query);
        searchMoviesBloc.currentPageIndex++;
        readyForRequest = true;
        Navigator.of(context).pop();
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: new SafeArea(
          //To avoid status bar overlap
          left: false,
          top: false,
          right: false,
          bottom: false,
          child: Scaffold(
            appBar: new AppBar(
              title: new Text("MovieNow"),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new SizedBox(
                        height: 60.0,
                      ),
                      Container(
                        margin: new EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Text(
                              "Top Rated Movies",
                              style: new TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            new GestureDetector(
                              child: new Text("View All",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500)),
                              onTap: () {
                                //Navigate to all top rated movies list
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (_) => new MoviesListView(
                                            false, true, false)));
                              },
                            )
                          ],
                        ),
                      ),
                      topRatedMoviesWidget(),
                      new SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        margin: new EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Text(
                              "Upcoming Movies",
                              style: new TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            new InkWell(
                              child: new Text("View All",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500)),
                              onTap: () {
                                //Navigate to all upcoming movies list
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (_) => new MoviesListView(
                                            false, false, true)));
                              },
                            )
                          ],
                        ),
                      ),
                      upComingMoviesWidget(),
                      new SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        margin: new EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Text(
                              "Popular Movies",
                              style: new TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            new InkWell(
                              child: new Text("View All",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500)),
                              onTap: () {
                                //Navigate to all popular movies list
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (_) => new MoviesListView(
                                            true, false, false)));
                              },
                            )
                          ],
                        ),
                      ),
                      popularMoviesWidget()
                    ],
                  ),
                ),
                buildFloatingSearchBar() //Search Bar
              ],
            ),
          )),
    );
  }

  Widget topRatedMoviesWidget() {
    return StreamBuilder(
        stream: topRatedMoviesBloc.moviesList,
        builder: (context, AsyncSnapshot<TopRatedMoviesModel> snapshot) {
          if (snapshot.hasData) {
            TopRatedMoviesModel topRatedMoviesModel = snapshot.data;
            List<ResultsModel> topRatedResults = topRatedMoviesModel.results;
            return Container(
              height: 200.0,
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: kIsWeb
                      ? topRatedResults.length
                      : topRatedResults.length > 5
                          ? 5
                          : topRatedResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    ResultsModel topRatedResultsModel = topRatedResults[index];
                    return Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      elevation: 5,
                      child: InkWell(
                        child: Center(
                            child: topRatedResultsModel.posterPath != null
                                ? new Image.network(
                                    imagesPath +
                                        topRatedResultsModel.posterPath,
                                  )
                                : new Image.asset(
                                    "assets/default_movie_icon.png")),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (_) =>
                                      new MovieView(topRatedResultsModel.id)));
                        },
                      ),
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return errorWidget();
          }

          return new Container();
        });
  }

  Widget popularMoviesWidget() {
    return StreamBuilder(
        stream: popularMoviesBloc.popularMoviesList,
        builder: (context, AsyncSnapshot<PopularMoviesModel> snapshot) {
          if (snapshot.hasData) {
            PopularMoviesModel popularMoviesModel = snapshot.data;
            List<ResultsModel> resultsList = popularMoviesModel.results;
            return Container(
              height: 200.0,
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: kIsWeb
                      ? resultsList.length
                      : resultsList.length > 5
                          ? 5
                          : resultsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    ResultsModel topRatedResultsModel = resultsList[index];
                    return Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      elevation: 5,
                      child: InkWell(
                        child: Center(
                            child: topRatedResultsModel.posterPath != null
                                ? new Image.network(
                                    imagesPath +
                                        topRatedResultsModel.posterPath,
                                  )
                                : new Image.asset(
                                    "assets/default_movie_icon.png")),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (_) =>
                                      new MovieView(topRatedResultsModel.id)));
                        },
                      ),
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return errorWidget();
          }
          return new Container();
        });
  }

  Widget upComingMoviesWidget() {
    return StreamBuilder(
        stream: upcomingMoviesBloc.moviesList,
        builder: (context, AsyncSnapshot<UpcomingMoviesModel> snapshot) {
          if (snapshot.hasData) {
            UpcomingMoviesModel upcomingMoviesModel = snapshot.data;
            List<ResultsModel> upComingResults = upcomingMoviesModel.results;
            return Container(
              //width: 100.0,
              height: 100,
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: kIsWeb
                      ? upComingResults.length
                      : upComingResults.length > 5
                          ? 5
                          : upComingResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    ResultsModel upComingMoviesModel = upComingResults[index];
                    return Container(
                      width: 120.0,
                      height: 150.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (_) =>
                                      new MovieView(upComingMoviesModel.id)));
                        },
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          elevation: 5,
                          child: upComingMoviesModel.posterPath != null
                              ? Container(
                                  child: new Image.network(
                                      imagesPath +
                                          upComingMoviesModel.posterPath,
                                      fit: BoxFit.fill),
                                )
                              : new Image.asset(
                                  "assets/default_movie_icon.png"),
                        ),
                      ),
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return errorWidget();
          }
          return new Container();
        });
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: 'Search Movie Names',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: kIsWeb
          ? MediaQuery.of(context).size.width
          : isPortrait
              ? 600
              : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (searchQuery) async {
        if (searchQuery.isNotEmpty) {
          await searchMoviesBloc.fetchSearchedMovies(searchQuery);
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: getMoviesList(),
          ),
        );
      },
    );
  }

  Widget getMoviesList() {
    return new StreamBuilder(
        stream: searchMoviesBloc.moviesList,
        builder: (context, AsyncSnapshot<SearchMoviesModel> snapshot) {
          if (snapshot.hasData) {
            SearchMoviesModel searchMoviesModel = snapshot.data;
            _maxPageIndex = searchMoviesModel.totalPages;
            return ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                ResultsModel searchResultsModel =
                    searchMoviesModel.results[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (_) =>
                                new MovieView(searchResultsModel.id)));
                  },
                  child: Container(
                    color: Colors.grey[800],
                    padding: new EdgeInsets.all(5.0),
                    height: 100.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        searchResultsModel.posterPath != null
                            ? new Image.network(
                                imagesPath + searchResultsModel.posterPath,
                                fit: BoxFit.fill)
                            : new Image.asset("assets/default_movie_icon.png"),
                        new SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: new Text(
                                        searchResultsModel.title ?? "",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700),
                                        // overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new SizedBox(
                                height: 5.0,
                              ),
                              new Text(getCustomDateFormat(
                                  searchResultsModel.releaseDate ?? "")),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: searchMoviesModel.results.length ?? 0,
            );
          }
          return new Container();
        });
  }

  Widget buildBody() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: getMoviesList(),
    );
  }
}
