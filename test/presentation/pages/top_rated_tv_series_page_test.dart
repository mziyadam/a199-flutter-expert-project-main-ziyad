import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_list/now_playing_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_list/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class TvSeriesDetailEventFake extends Fake implements BlocEvent {}

class TvSeriesDetailStateFake extends Fake implements BlocState {}

class MockTTopRatedTvSeriesBloc extends MockBloc<BlocEvent, BlocState>
    implements TopRatedTvSeriesBloc {}

// @GenerateMocks([TopRatedTvSeriesNotifier])
void main() {
  late MockTTopRatedTvSeriesBloc mockNotifier;

  setUpAll(() {
    registerFallbackValue(TvSeriesDetailEventFake());
    registerFallbackValue(TvSeriesDetailStateFake());
  });
  setUp(() {
    mockNotifier = MockTTopRatedTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TopRatedTvSeriesBloc>(create: (_) => mockNotifier),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockNotifier.state).thenReturn(StateLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockNotifier.add(OnVoid())).thenReturn(StateHasData<TvSeries>(testTvSeriesList));
        when(() => mockNotifier.state).thenReturn(StateHasData<TvSeries>(testTvSeriesList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockNotifier.state).thenReturn(StateError("Error Message"));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}
