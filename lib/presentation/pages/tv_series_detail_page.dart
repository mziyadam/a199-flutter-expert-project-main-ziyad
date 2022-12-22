import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/recommendation_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_watchlist/watchlist_tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-series';

  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   Provider.of<TvSeriesDetailNotifier>(context, listen: false)
    //       .fetchTvSeriesDetail(widget.id);
    //   Provider.of<TvSeriesDetailNotifier>(context, listen: false)
    //       .loadWatchlistStatus(widget.id);
    // });
    context.read<RecommendationTvSeriesBloc>().add(OnIdChanged(widget.id));
    context.read<TvSeriesDetailBloc>().add(OnIdChanged(widget.id));
    context.read<TvSeriesWatchlistStatusBloc>().add(OnIdChanged(widget.id));
    context.read<WatchlistTvSeriesBloc>().add(OnVoid());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvSeriesDetailBloc, BlocState>(
        builder: (context, state) {
          if (state is StateLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StateHasDataSingle<TvSeriesDetail>) {
            final movie = state.result;
            return SafeArea(
              child: DetailContent(
                  movie,
                  context.select(
                          (TvSeriesWatchlistStatusBloc bloc) => bloc.state.status)),
            );
          } else if (state is StateError){
            return Text(state.message);
          }else{
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail movie;

  // final List<TvSeries> recommendations;
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
                              movie.name!,
                              style: kHeading5,
                            ),
                            BlocConsumer<TvSeriesWatchlistStatusBloc,
                                StateHasDataDual>(
                              listenWhen: (before, after) => after.msg != "",
                              listener: (BuildContext context, state) {
                                if (state.msg ==
                                    TvSeriesWatchlistStatusBloc
                                        .watchlistAddSuccessMessage ||
                                    state.msg ==
                                        TvSeriesWatchlistStatusBloc
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
                                    if (!isAddedWatchlist) {
                                      context
                                          .read<TvSeriesWatchlistStatusBloc>()
                                          .add(OnSavedTvSeries(movie));
                                    } else {
                                      context
                                          .read<TvSeriesWatchlistStatusBloc>()
                                          .add(OnUnsavedTvSeries(movie));
                                    }

                                    context
                                        .read<WatchlistTvSeriesBloc>()
                                        .add(OnVoid());
                                    final message =
                                        state.msg;

                                    if (message ==
                                        TvSeriesWatchlistStatusBloc
                                            .watchlistAddSuccessMessage ||
                                        message ==
                                            TvSeriesWatchlistStatusBloc
                                                .watchlistRemoveSuccessMessage) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(content: Text(message)));
                                    } else {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (context) {
                                      //       return AlertDialog(
                                      //         content: Text(message),
                                      //       );
                                      //     });
                                    }
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
                              _showGenres(movie.genres!),
                            ),

                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage! / 2,
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
                              movie.overview!,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationTvSeriesBloc, BlocState>(
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
                                                TvSeriesDetailPage.ROUTE_NAME,
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

// class DetailContent extends StatelessWidget {
//   final TvSeriesDetail tvSeries;
//   final List<TvSeries> recommendations;
//   final bool isAddedWatchlist;
//
//   DetailContent(this.tvSeries, this.recommendations, this.isAddedWatchlist);
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Stack(
//       children: [
//         CachedNetworkImage(
//           imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
//           width: screenWidth,
//           placeholder: (context, url) => Center(
//             child: CircularProgressIndicator(),
//           ),
//           errorWidget: (context, url, error) => Icon(Icons.error),
//         ),
//         Container(
//           margin: const EdgeInsets.only(top: 48 + 8),
//           child: DraggableScrollableSheet(
//             builder: (context, scrollController) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: kRichBlack,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                 ),
//                 padding: const EdgeInsets.only(
//                   left: 16,
//                   top: 16,
//                   right: 16,
//                 ),
//                 child: Stack(
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(top: 16),
//                       child: SingleChildScrollView(
//                         controller: scrollController,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               tvSeries.name!,
//                               style: kHeading5,
//                             ),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 if (!isAddedWatchlist) {
//                                   await Provider.of<TvSeriesDetailNotifier>(
//                                       context,
//                                       listen: false)
//                                       .addWatchlist(tvSeries);
//                                 } else {
//                                   await Provider.of<TvSeriesDetailNotifier>(
//                                       context,
//                                       listen: false)
//                                       .removeFromWatchlist(tvSeries);
//                                 }
//
//                                 final message =
//                                     Provider.of<TvSeriesDetailNotifier>(context,
//                                         listen: false)
//                                         .watchlistMessage;
//
//                                 if (message ==
//                                     TvSeriesDetailNotifier
//                                         .watchlistAddSuccessMessage ||
//                                     message ==
//                                         TvSeriesDetailNotifier
//                                             .watchlistRemoveSuccessMessage) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(content: Text(message)));
//                                 } else {
//                                   showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return AlertDialog(
//                                           content: Text(message),
//                                         );
//                                       });
//                                 }
//                               },
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   isAddedWatchlist
//                                       ? Icon(Icons.check)
//                                       : Icon(Icons.add),
//                                   Text('Watchlist'),
//                                 ],
//                               ),
//                             ),
//                             Text(
//                               _showGenres(tvSeries.genres!),
//                             ),
//                             Row(
//                               children: [
//                                 RatingBarIndicator(
//                                   rating: tvSeries.voteAverage! / 2,
//                                   itemCount: 5,
//                                   itemBuilder: (context, index) => Icon(
//                                     Icons.star,
//                                     color: kMikadoYellow,
//                                   ),
//                                   itemSize: 24,
//                                 ),
//                                 Text('${tvSeries.voteAverage}')
//                               ],
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               'Overview',
//                               style: kHeading6,
//                             ),
//                             Text(
//                               tvSeries.overview!,
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               'Recommendations',
//                               style: kHeading6,
//                             ),
//                             Consumer<TvSeriesDetailNotifier>(
//                               builder: (context, data, child) {
//                                 if (data.recommendationState ==
//                                     RequestState.Loading) {
//                                   return Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 } else if (data.recommendationState ==
//                                     RequestState.Error) {
//                                   return Text(data.message);
//                                 } else if (data.recommendationState ==
//                                     RequestState.Loaded) {
//                                   return Container(
//                                     height: 150,
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemBuilder: (context, index) {
//                                         final tvSeries = recommendations[index];
//                                         return Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: InkWell(
//                                             onTap: () {
//                                               Navigator.pushReplacementNamed(
//                                                 context,
//                                                 TvSeriesDetailPage.ROUTE_NAME,
//                                                 arguments: tvSeries.id,
//                                               );
//                                             },
//                                             child: ClipRRect(
//                                               borderRadius: BorderRadius.all(
//                                                 Radius.circular(8),
//                                               ),
//                                               child: CachedNetworkImage(
//                                                 imageUrl:
//                                                 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
//                                                 placeholder: (context, url) =>
//                                                     Center(
//                                                       child:
//                                                       CircularProgressIndicator(),
//                                                     ),
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                     Icon(Icons.error),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       itemCount: recommendations.length,
//                                     ),
//                                   );
//                                 } else {
//                                   return Container();
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Container(
//                         color: Colors.white,
//                         height: 4,
//                         width: 48,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             // initialChildSize: 0.5,
//             minChildSize: 0.25,
//             // maxChildSize: 1.0,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundColor: kRichBlack,
//             foregroundColor: Colors.white,
//             child: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   String _showGenres(List<Genre> genres) {
//     String result = '';
//     for (var genre in genres) {
//       result += genre.name + ', ';
//     }
//
//     if (result.isEmpty) {
//       return result;
//     }
//
//     return result.substring(0, result.length - 2);
//   }
//
// }
