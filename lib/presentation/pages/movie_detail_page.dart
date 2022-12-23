import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/recommendation_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-movie';

  final int id;

  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   Provider.of<MovieDetailNotifier>(context, listen: false)
    //       .fetchMovieDetail(widget.id);
    //   Provider.of<MovieDetailNotifier>(context, listen: false)
    //       .loadWatchlistStatus(widget.id);
    // });
    context.read<RecommendationMoviesBloc>().add(OnIdChanged(widget.id));
    context.read<MovieDetailBloc>().add(OnIdChanged(widget.id));
    context.read<MovieWatchlistStatusBloc>().add(OnIdChanged(widget.id));
    context.read<WatchlistMoviesBloc>().add(OnVoid());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, BlocState>(
        builder: (context, state) {
          if (state is StateLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StateHasDataSingle<MovieDetail>) {
            final movie = state.result;
            return SafeArea(
              child: DetailContent(
                  movie!,
                  context.select(
                      (MovieWatchlistStatusBloc bloc) => bloc.state.status)),
            );
          } else if (state is StateError) {
            return Text(state.message);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;

  // final List<Movie> recommendations;
  final bool isAddedWatchlist;

  // DetailContent(this.movie, this.recommendations, this.isAddedWatchlist);
  DetailContent(this.movie, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            BlocConsumer<MovieWatchlistStatusBloc,
                                StateHasDataDual>(
                              listenWhen: (before, after) => after.msg != "",
                              listener: (BuildContext context, state) {
                                if (state.msg ==
                                        MovieWatchlistStatusBloc
                                            .watchlistAddSuccessMessage ||
                                    state.msg ==
                                        MovieWatchlistStatusBloc
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.msg)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(state.msg),
                                        );
                                      });
                                }
                              },
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    // FirebaseCrashlytics.instance.crash();
                                    if (!isAddedWatchlist) {
                                      context
                                          .read<MovieWatchlistStatusBloc>()
                                          .add(OnSavedMovie(movie));
                                    } else {
                                      context
                                          .read<MovieWatchlistStatusBloc>()
                                          .add(OnUnsavedMovie(movie));
                                    }

                                    context
                                        .read<WatchlistMoviesBloc>()
                                        .add(OnVoid());
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isAddedWatchlist
                                          ? Icon(Icons.check)
                                          : Icon(Icons.add),
                                      Text('Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationMoviesBloc, BlocState>(
                              builder: (context, state) {
                                if (state is StateLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is StateError) {
                                  return Text(state.message);
                                } else if (state is StateHasData) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = state.result[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.result.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
