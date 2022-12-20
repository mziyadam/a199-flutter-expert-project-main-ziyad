import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  //poster, judul, rating, dan sinopsis.
  TvSeries({
    required this.posterPath,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
  });

  TvSeries.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });

  List<int>? genreIds;
  int id;
  String? overview;
  String? posterPath;
  String? name;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        posterPath,
        genreIds,
        id,
        name,
        overview,
        voteAverage,
      ];
}
