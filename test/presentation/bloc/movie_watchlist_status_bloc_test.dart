import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_movie_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/save_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/recommendation_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/movie_detail_notifier_test.mocks.dart';
import '../provider/movie_search_notifier_test.mocks.dart';

@GenerateMocks(
    [GetMovieWatchListStatus, SaveMovieWatchlist, RemoveMovieWatchlist])
void main() {
  late MovieWatchlistStatusBloc searchBloc;
  late MockGetMovieWatchListStatus mockSearchMovies;
  late MockSaveMovieWatchlist mockSaveWatchlist;
  late MockRemoveMovieWatchlist mockRemoveWatchlist;

  setUp(() {
    mockSearchMovies = MockGetMovieWatchListStatus();
    mockSaveWatchlist = MockSaveMovieWatchlist();
    mockRemoveWatchlist = MockRemoveMovieWatchlist();
    searchBloc = MovieWatchlistStatusBloc(
        getWatchListStatus: mockSearchMovies,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist);
  });
  test('initial state should be empty', () {
    expect(searchBloc.state, StateHasDataDual(false, ""));
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 557;

  blocTest<MovieWatchlistStatusBloc, StateHasDataDual>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => false);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      StateHasDataDual(false,"")
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );
  blocTest<MovieWatchlistStatusBloc, StateHasDataDual>(
    'Should emit success(true) when successful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right(''));
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => true);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    expect: () => [
      StateHasDataDual(true, "")
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );
  blocTest<MovieWatchlistStatusBloc, StateHasDataDual>(
    'Should emit error(false) when unsuccessful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(ServerFailure('')));
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => false);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    expect: () => [
      StateHasDataDual(false, "")
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );
  blocTest<MovieWatchlistStatusBloc, StateHasDataDual>(
    'Should emit success(true) when successful',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right(''));
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => true);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    expect: () => [
      StateHasDataDual(true, "")
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );
  blocTest<MovieWatchlistStatusBloc, StateHasDataDual>(
    'Should emit error(false) when unsuccessful',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(ServerFailure('')));
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => false);
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    expect: () => [
      StateHasDataDual(false, "")
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );
}
