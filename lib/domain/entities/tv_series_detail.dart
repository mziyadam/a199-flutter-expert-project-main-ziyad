import 'package:ditonton/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetail extends Equatable {
  //poster, judul, rating, dan sinopsis.
  TvSeriesDetail({
    required this.posterPath,
    required this.genres,
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
  });

  List<Genre>? genres;
  int id;
  String? overview;
  String? posterPath;
  String? name;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
    posterPath,
    genres,
    id,
    name,
    overview,
    voteAverage,
  ];
}
