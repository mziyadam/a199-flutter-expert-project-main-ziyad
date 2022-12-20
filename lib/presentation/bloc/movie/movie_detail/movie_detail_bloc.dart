import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_movie_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/save_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailBloc extends Bloc<BlocEvent, BlocState> {

  final GetMovieDetail getMovieDetail;
  MovieDetailBloc({
    required this.getMovieDetail
  }): super(StateEmpty()){
    on<OnIdChanged>((event, emit) async {

      emit(StateLoading());
      final resultMovie = await getMovieDetail.execute(event.id);

      resultMovie.fold(
            (failure) {
          emit(StateError(failure.message));
        },
            (data) {
          emit(StateHasDataSingle(data));
        },
      );
    });

    /*on<OnSaved>((event, emit) async {
      emit(StateLoading());
      final result = await saveWatchlist.execute(movie);

      result.fold(
            (failure) {
          emit(StateError(failure.message));
        },
            (data) {
          emit(StateHasDataSingle(data));
        },
      );
      final resultStatus = await getWatchListStatus.execute(id);
      _isAddedtoWatchlist = resultStatus;
    });
    on<OnUnsaved>((event, emit) async {
      emit(StateLoading());
      final result = await removeWatchlist.execute(movie);

      result.fold(
            (failure) {
          emit(StateError(failure.message));
        },
            (data) {
          emit(StateHasDataSingle(data));
        },
      );
      final resultStatus = await getWatchListStatus.execute(id);
      _isAddedtoWatchlist = resultStatus;
    });*/
  }

}