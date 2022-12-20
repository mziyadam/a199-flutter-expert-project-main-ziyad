import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

abstract class BlocEvent extends Equatable {
  const BlocEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends BlocEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class OnIdChanged extends BlocEvent{
  final int id;

  OnIdChanged(this.id);

  @override
  List<Object> get props => [id];

}
class OnSavedMovie extends BlocEvent{
  final MovieDetail movie;

  OnSavedMovie(this.movie);

  @override
  List<Object> get props => [movie];

}
class OnUnsavedMovie extends BlocEvent{
  final MovieDetail movie;

  OnUnsavedMovie(this.movie);

  @override
  List<Object> get props => [movie];

}
class OnSavedTvSeries extends BlocEvent{
  final TvSeriesDetail movie;

  OnSavedTvSeries(this.movie);

  @override
  List<Object> get props => [movie];

}
class OnUnsavedTvSeries extends BlocEvent{
  final TvSeriesDetail movie;

  OnUnsavedTvSeries(this.movie);

  @override
  List<Object> get props => [movie];

}
class OnWatchlistStatus extends BlocEvent{
  final int id;

  OnWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];

}
class OnVoid extends BlocEvent{

  OnVoid();

  @override
  List<Object> get props => [];

}
