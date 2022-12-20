import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesBloc extends Bloc<BlocEvent, BlocState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesBloc(this._getTopRatedMovies) : super(StateEmpty()){
    on<OnVoid>((event, emit) async {

      emit(StateLoading());
      final result = await _getTopRatedMovies.execute();

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