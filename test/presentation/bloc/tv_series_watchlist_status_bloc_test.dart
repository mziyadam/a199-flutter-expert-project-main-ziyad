import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_movie_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/recommendation_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_watchlist_status_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_watchlist_status_bloc_test.mocks.dart';

@GenerateMocks(
    [GetTvSeriesWatchListStatus, SaveTvSeriesWatchlist, RemoveTvSeriesWatchlist])
void main() {
  late TvSeriesWatchlistStatusBloc searchBloc;
  late MockGetTvSeriesWatchListStatus mockSearchTvSeries;
  late MockSaveTvSeriesWatchlist mockSaveWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveWatchlist;

  setUp(() {
    mockSearchTvSeries = MockGetTvSeriesWatchListStatus();
    mockSaveWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveWatchlist = MockRemoveTvSeriesWatchlist();
    searchBloc = TvSeriesWatchlistStatusBloc(
        getWatchListStatus: mockSearchTvSeries,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist);
  });
  test('initial state should be empty', () {
    expect(searchBloc.state, StateHasDataDual(false, ""));
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
  final testTvSeriesDetail = TvSeriesDetail(
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    name: 'name',
    voteAverage: 1,
  );

  final tTvSeriesList = <TvSeries>[tTvSeriesModel];
  final tQuery = 557;

  blocTest<TvSeriesWatchlistStatusBloc, StateHasDataDual>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => false);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      StateHasDataDual(false,"")
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
  blocTest<TvSeriesWatchlistStatusBloc, StateHasDataDual>(
    'Should emit success(true) when successful',
    build: () {
      when(mockSaveWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right(''));
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => true);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    expect: () => [
      StateHasDataDual(true, "")
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
  blocTest<TvSeriesWatchlistStatusBloc, StateHasDataDual>(
    'Should emit error(false) when unsuccessful',
    build: () {
      when(mockSaveWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(ServerFailure('')));
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => false);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    expect: () => [
      StateHasDataDual(false, "")
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
  blocTest<TvSeriesWatchlistStatusBloc, StateHasDataDual>(
    'Should emit success(true) when successful',
    build: () {
      when(mockRemoveWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right(''));
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => true);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    expect: () => [
      StateHasDataDual(true, "")
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
  blocTest<TvSeriesWatchlistStatusBloc, StateHasDataDual>(
    'Should emit error(false) when unsuccessful',
    build: () {
      when(mockRemoveWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(ServerFailure('')));
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => false);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    expect: () => [
      StateHasDataDual(false, "")
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}
