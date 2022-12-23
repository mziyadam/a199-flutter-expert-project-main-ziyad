import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../dummy_data/dummy_objects.dart';


class TestBlocEvent extends BlocEvent{}
void main() {
  final testBlocEvent=TestBlocEvent();
  testBlocEvent.props;
  final onQueryChanged=OnQueryChanged("query");
  onQueryChanged.props;
  final onIdChanged=OnIdChanged(1);
  onIdChanged.props;
  final onSavedMovie=OnSavedMovie(testMovieDetail);
  onSavedMovie.props;
  final onUnsavedMovie=OnUnsavedMovie(testMovieDetail);
  onUnsavedMovie.props;
  final onSavedTvSeries=OnSavedTvSeries(testTvSeriesDetail);
  onSavedTvSeries.props;
  final onUnsavedTvSeries=OnUnsavedTvSeries(testTvSeriesDetail);
  onUnsavedTvSeries.props;
  final onWatchlistStatus=OnWatchlistStatus(1);
  onWatchlistStatus.props;
  final onVoid=OnVoid();
  onVoid.props;

  test('should be a subclass of Movie entity', () async {
    final result = testBlocEvent.props;
    expect(result, []);
  });
  test('should be a subclass of Movie entity', () async {
    final result = onQueryChanged.props;
    expect(result, ["query"]);
  });
  test('should be a subclass of Movie entity', () async {
    final result = onIdChanged.props;
    expect(result, [1]);
  });
  test('should be a subclass of Movie entity', () async {
    final result = onSavedMovie.props;
    expect(result, [testMovieDetail]);
  });
  test('should be a subclass of Movie entity', () async {
    final result = onUnsavedMovie.props;
    expect(result, [testMovieDetail]);
  });
  test('should be a subclass of Movie entity', () async {
    final result = onSavedTvSeries.props;
    expect(result, [testTvSeriesDetail]);
  });
  test('should be a subclass of Movie entity', () async {
    final result = onUnsavedTvSeries.props;
    expect(result, [testTvSeriesDetail]);
  });
  test('should be a subclass of Movie entity', () async {
    final result = onWatchlistStatus.props;
    expect(result, [1]);
  });
  test('should be a subclass of Movie entity', () async {
    final result = onVoid.props;
    expect(result, []);
  });
}
