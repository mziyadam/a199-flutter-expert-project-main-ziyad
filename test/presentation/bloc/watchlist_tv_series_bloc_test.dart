import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/movie/movie_watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_watchlist/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesBloc searchBloc;
  late MockGetWatchlistTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockGetWatchlistTvSeries();
    searchBloc = WatchlistTvSeriesBloc(mockSearchTvSeries);
  });
  test('initial state should be empty', () {
    expect(searchBloc.state, StateEmpty());
  });

  final tTvSeriesModel = TvSeries(
    genreIds: [1],
    id: 557,
    overview:
    'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    name: 'Spider-Man',
    voteAverage: 7.2,
  );
  final tTvSeriesList = <TvSeries>[tTvSeriesModel];

  blocTest<WatchlistTvSeriesBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnVoid()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      StateLoading(),
      StateHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute());
    },
  );
  blocTest<WatchlistTvSeriesBloc, BlocState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnVoid()),
    expect: () => [
      StateLoading(),
      StateError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute());
    },
  );
}