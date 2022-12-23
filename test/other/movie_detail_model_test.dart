import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
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
  final tMovieResponse = MovieDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    budget: 100,
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: "https://google.com",
    id: 1,
    imdbId: 'imdb1',
    originalLanguage: 'en',
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    revenue: 12000,
    runtime: 120,
    status: 'Status',
    tagline: 'Tagline',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
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
  final tez={
    "adult": false,
    "backdrop_path": "backdropPath",
    "belongs_to_collection": {
      "id": 11,
      "name": "Collection",
      "poster_path": null,
      "backdrop_path": null
    },
    "budget": 100,
    "genres": [
      {
        "id": 1,
        "name": "Action"
      }
    ],
    "homepage": "https://google.com",
    "id": 1,
    "imdb_id": "imdb1",
    "original_language": "en",
    "original_title": "originalTitle",
    "overview": "overview",
    "popularity": 1.0,
    "poster_path": "posterPath",
    "production_companies": [
      {
        "id": 1,
        "logo_path": null,
        "name": "Company",
        "origin_country": "US"
      }
    ],
    "production_countries": [
      {
        "iso_3166_1": "US",
        "name": "United States of America"
      }
    ],
    "release_date": "releaseDate",
    "revenue": 12000,
    "runtime": 120,
    "spoken_languages": [
      {
        "english_name": "English",
        "iso_639_1": "en",
        "name": "English"
      },
      {
        "english_name": "German",
        "iso_639_1": "de",
        "name": "Deutsch"
      },
      {
        "english_name": "Spanish",
        "iso_639_1": "es",
        "name": "Español"
      }
    ],
    "status": "Status",
    "tagline": "Tagline",
    "title": "title",
    "video": false,
    "vote_average": 1.0,
    "vote_count": 1
  };
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  test('should be a subclass of Movie entity', () async {
    final kMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );
    expect(tMovieResponse, kMovieResponse);
  });
  test('should be a subclass of Movie entity', () async {
    final result = tMovieResponse.toJson();

    expect(tMovieResponse, MovieDetailResponse.fromJson(tez));
  });
// test('should be a subclass of Movie entity', () async {
//   final result = tMovieResponse.toJson();
//
//   expect(result, tez);
// });
  test('should be a subclass of Movie entity', () async {
    final result = tMovieResponse.toEntity();
    expect(result, testMovieDetail);
  });
  test('should be a subclass of Movie entity', () async {
    final result = tMovieResponse.props;
    expect(result, [false,
      'backdropPath',
      100,
      genres,
      'https://google.com',
      1,
      'imdb1',
      'en',
      'originalTitle',
      'overview',
      1.0,
      'posterPath',
      'releaseDate',
      12000,
      120,
      'Status',
      'Tagline',
      'title',
      false,
      1.0,
      1]);
  });
  test('should be a subclass of Movie entity', () async {
    final result = tMovieResponse.genres[0].props;
    final tGenre=genres[0];
    expect(result, [tGenre.id,tGenre.name]);
  });
}
