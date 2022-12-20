import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchMoviesBloc extends Bloc<BlocEvent, BlocState> {
  final SearchMovies _searchMovies;

  SearchMoviesBloc(this._searchMovies) : super(StateEmpty()){
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(StateLoading());
      final result = await _searchMovies.execute(query);

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