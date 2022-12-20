import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/recommendation_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/recommendation_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/movie_detail_notifier_test.mocks.dart';
import '../provider/movie_search_notifier_test.mocks.dart';
import '../provider/tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([GetTvSeriesRecommendations])
void main() {
  late RecommendationTvSeriesBloc searchBloc;
  late MockGetTvSeriesRecommendations mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockGetTvSeriesRecommendations();
    searchBloc = RecommendationTvSeriesBloc(getTvSeriesRecommendations: mockSearchTvSeries);
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
  final tQuery = 557;

  blocTest<RecommendationTvSeriesBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvSeriesList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      StateLoading(),
      StateHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
  blocTest<RecommendationTvSeriesBloc, BlocState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnIdChanged(tQuery)),
    expect: () => [
      StateLoading(),
      StateError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}