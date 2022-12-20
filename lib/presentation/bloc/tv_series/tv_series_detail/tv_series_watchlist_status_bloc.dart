import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_movie_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesWatchlistStatusBloc extends Bloc<BlocEvent, StateHasDataDual> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesWatchListStatus getWatchListStatus;
  final SaveTvSeriesWatchlist saveWatchlist;
  final RemoveTvSeriesWatchlist removeWatchlist;
  TvSeriesWatchlistStatusBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist
  }): super(StateHasDataDual(false, "")){
    on<OnSavedTvSeries>((event, emit) async {

      // emit(StateLoading());
      final result = await saveWatchlist.execute(event.movie);
      String msg="";
      result.fold(
            (failure) {
          msg=failure.message;
          // emit(StateError(failure.message));
        },
            (success) async {
          msg=watchlistAddSuccessMessage;
        },
      );
      final status = await getWatchListStatus.execute(event.movie.id);
      emit(StateHasDataDual(status, msg));
    });
    on<OnUnsavedTvSeries>((event, emit) async {

      // emit(StateLoading());
      final result = await removeWatchlist.execute(event.movie);
      String msg="";
      result.fold(
            (failure) {
          msg=failure.message;
          // emit(StateError(failure.message));
        },
            (success) async {
          msg=watchlistRemoveSuccessMessage;
        },
      );
      final status = await getWatchListStatus.execute(event.movie.id);
      emit(StateHasDataDual(status, msg));
    });
    on<OnIdChanged>((event, emit) async {

      // emit(StateLoading());
      final result = await getWatchListStatus.execute(event.id);
      emit(StateHasDataDual(result, ""));
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
