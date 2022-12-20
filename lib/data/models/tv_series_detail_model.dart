import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailModel extends Equatable {
  TvSeriesDetailModel({
    required this.posterPath,
    required this.genres,
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
  });

  final List<GenreModel> genres;
  final int id;
  final String overview;
  final String? posterPath;
  final String name;
  final double voteAverage;

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) => TvSeriesDetailModel(
    genres: List<GenreModel>.from(
        json["genres"].map((x) => GenreModel.fromJson(x))),
    id: json["id"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    name: json["name"],
    voteAverage: json["vote_average"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "genres": List<dynamic>.from(genres.map((x) => x)),
    "id": id,
    "overview": overview,
    "poster_path": posterPath,
    "name": name,
    "vote_average": voteAverage,
  };

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      overview: this.overview,
      posterPath: this.posterPath,
      name: this.name,
      voteAverage: this.voteAverage,
    );
  }

  @override
  List<Object?> get props => [
    genres,
    id,
    overview,
    posterPath,
    name,
    voteAverage,
  ];
}
