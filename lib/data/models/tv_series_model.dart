import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class TvSeriesModel extends Equatable {
  TvSeriesModel({
    required this.posterPath,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
  });

  final List<int> genreIds;
  final int id;
  final String overview;
  final String? posterPath;
  final String name;
  final double voteAverage;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    name: json["name"],
    voteAverage: json["vote_average"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "overview": overview,
    "poster_path": posterPath,
    "name": name,
    "vote_average": voteAverage,
  };

  TvSeries toEntity() {
    return TvSeries(
      genreIds: this.genreIds,
      id: this.id,
      overview: this.overview,
      posterPath: this.posterPath,
      name: this.name,
      voteAverage: this.voteAverage,
    );
  }

  @override
  List<Object?> get props => [
    genreIds,
    id,
    overview,
    posterPath,
    name,
    voteAverage,
  ];
}
