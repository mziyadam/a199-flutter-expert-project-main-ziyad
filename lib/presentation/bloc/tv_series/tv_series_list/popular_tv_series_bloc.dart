import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesBloc extends Bloc<BlocEvent, BlocState> {
  final GetPopularTvSeries _getPopularTvSeries;

  PopularTvSeriesBloc(this._getPopularTvSeries) : super(StateEmpty()){
    on<OnVoid>((event, emit) async {

      emit(StateLoading());
      final result = await _getPopularTvSeries.execute();

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