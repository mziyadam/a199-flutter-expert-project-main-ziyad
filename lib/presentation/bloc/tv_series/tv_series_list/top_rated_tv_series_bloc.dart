import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvSeriesBloc extends Bloc<BlocEvent, BlocState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this._getTopRatedTvSeries) : super(StateEmpty()){
    on<OnVoid>((event, emit) async {

      emit(StateLoading());
      final result = await _getTopRatedTvSeries.execute();

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