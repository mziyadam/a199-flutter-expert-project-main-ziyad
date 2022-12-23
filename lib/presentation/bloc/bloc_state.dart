import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class BlocState extends Equatable {
  const BlocState();

  @override
  List<Object> get props => [];
}

class StateEmpty extends BlocState {}

class StateLoading extends BlocState {}

class StateError extends BlocState {
  final String message;

  StateError(this.message);

  @override
  List<Object> get props => [message];
}

class StateHasData<T> extends BlocState {
  final List<T> result;

  StateHasData(this.result);

  StateHasData copyWith(
    List<T>? result,
  ) {
    return StateHasData(result ?? this.result);
  }

  factory StateHasData.initial() {
    return StateHasData([]);
  }

  @override
  List<Object> get props => [result];
}

// abstract class BlocStateSingle extends Equatable {
//   const BlocStateSingle();
//
//   // @override
//   // List<Object> get props => [];
// }
//
class StateHasDataSingle<T extends Object> extends BlocState {
  final T? result;

  StateHasDataSingle(this.result);

  StateHasDataSingle copyWith(
    T? result,
  ) {
    return StateHasDataSingle(result ?? this.result);
  }

  factory StateHasDataSingle.initial() {
    return StateHasDataSingle(null);
  }

  @override
  List<Object> get props => [result!];
}

class StateHasDataDual extends BlocState {
  final String msg;
  final bool status;

  StateHasDataDual(this.status, this.msg);

  StateHasDataDual copyWith(bool status, String msg) {
    return StateHasDataDual(status ?? this.status, msg ?? this.msg);
  }

  factory StateHasDataDual.initial() {
    return StateHasDataDual(false, "");
  }

  @override
  List<Object> get props => [status, msg];
}
