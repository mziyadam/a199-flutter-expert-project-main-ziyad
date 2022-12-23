import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import '../dummy_data/dummy_objects.dart';

void main() {
  final List<GenreModel> genres=[GenreModel(id: 1, name: 'Action')];
  final int id=1;
  final String overview='overview';
  final String? posterPath='posterPath';
  final String name='name';
  final double voteAverage=1;
  final tTvSeriesResponse = TvSeriesDetailModel(
    genres: genres,
    id: id,
    overview: overview,
    posterPath: posterPath,
    name: name,
    voteAverage: voteAverage,
  );
  final testTvSeriesDetail = TvSeriesDetail(
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    name: 'name',
    voteAverage: 1,
  );
  final tez={
    "genres": [
      {
        "id": 1,
        "name": "Action"
      }
    ],
    "id": 1,
    "overview": "overview",
    "poster_path": "posterPath",
    "name": "name",
    "vote_average": 1.0
  };
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  test('should be a subclass of Movie entity', () async {
    final mTvSeriesResponse = TvSeriesDetailModel(
      genres: genres,
      id: id,
      overview: overview,
      posterPath: posterPath,
      name: name,
      voteAverage: voteAverage,
    );
    expect(mTvSeriesResponse, tTvSeriesResponse);
  });
  test('should be a subclass of Movie entity', () async {
    final result = tTvSeriesResponse.toJson();

    expect(tTvSeriesResponse, TvSeriesDetailModel.fromJson(tez));
  });
  // test('should be a subclass of Movie entity', () async {
  //   final result = tTvSeriesResponse.toJson();
  //
  //   expect(result, tez);
  // });
  test('should be a subclass of Movie entity', () async {
    final result = tTvSeriesResponse.toEntity();
    expect(result, testTvSeriesDetail);
  });
  test('should be a subclass of Movie entity', () async {
    final result = tTvSeriesResponse.props;
    expect(result, [genres,id,overview,posterPath,name, voteAverage]);
  });
  test('should be a subclass of Movie entity', () async {
    final result = tTvSeriesResponse.genres[0].props;
    final tGenre=genres[0];
    expect(result, [tGenre.id,tGenre.name]);
  });
  test('should be a subclass of Movie entity', () async {
    final resultJson=tGenreModel.toJson();
    expect(tGenreModel, GenreModel.fromJson(resultJson));
  });
  test('should be a subclass of Movie entity', () async {
    final resultEntity=Genre(id: 1, name: 'Action');
    expect(tGenreModel.toEntity(), resultEntity);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tGenreModel.props, [1,'Action']);
  });

}
