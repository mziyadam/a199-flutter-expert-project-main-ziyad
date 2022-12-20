import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingMoviesBloc extends Bloc<BlocEvent, BlocState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMoviesBloc(this._getNowPlayingMovies) : super(StateEmpty()){
    on<OnVoid>((event, emit) async {
      emit(StateLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
            (failure) {
          emit(StateError(failure.message));
        },
            (data) {
          emit(StateHasData(data));
        },
      );
    });
  }

}