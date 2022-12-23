import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/recommendation_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/recommendation_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_watchlist/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class TvSeriesDetailEventFake extends Fake implements BlocEvent {}

class TvSeriesDetailStateFake extends Fake implements BlocState {}

class MockTTvSeriesDetailBloc extends MockBloc<BlocEvent, BlocState>
    implements TvSeriesDetailBloc {}

class MockTWatchlistTvSeriesBloc extends MockBloc<BlocEvent, BlocState>
    implements WatchlistTvSeriesBloc {}

class MockTRecommendationTvSeriesBloc extends MockBloc<BlocEvent, BlocState>
    implements RecommendationTvSeriesBloc {}

class MockTTvSeriesWatchlistStatusBloc
    extends MockBloc<BlocEvent, StateHasDataDual>
    implements TvSeriesWatchlistStatusBloc {}

// @GenerateMocks([TvSeriesDetailBloc,RecommendationTvSeriesBloc,TvSeriesWatchlistStatusBloc])
void main() {
  late MockTTvSeriesDetailBloc mockNotifier;
  late MockTRecommendationTvSeriesBloc mockRecommendationTvSeriesBloc;
  late MockTTvSeriesWatchlistStatusBloc mockTvSeriesWatchlistStatusBloc;
  late MockTWatchlistTvSeriesBloc mockWatchlistTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(TvSeriesDetailEventFake());
    registerFallbackValue(TvSeriesDetailStateFake());
  });
  setUp(() {
    mockNotifier = MockTTvSeriesDetailBloc();
    mockRecommendationTvSeriesBloc = MockTRecommendationTvSeriesBloc();
    mockTvSeriesWatchlistStatusBloc = MockTTvSeriesWatchlistStatusBloc();
    mockWatchlistTvSeriesBloc = MockTWatchlistTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>(create: (_) => mockNotifier),
        BlocProvider<RecommendationTvSeriesBloc>(
            create: (_) => mockRecommendationTvSeriesBloc),
        BlocProvider<TvSeriesWatchlistStatusBloc>(
            create: (_) => mockTvSeriesWatchlistStatusBloc),
        BlocProvider<WatchlistTvSeriesBloc>(
            create: (_) => mockWatchlistTvSeriesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Detail TvSeries Page should display Progressbar when loading',
          (WidgetTester tester) async {
        when(() => mockNotifier.state).thenReturn(StateLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

        expect(progressBarFinder, findsOneWidget);
      });
  testWidgets('Detail TvSeries Page should display Progressbar when loading',
          (WidgetTester tester) async {
        when(() => mockNotifier.state).thenReturn(StateError("message"));

        final progressBarFinder = find.byType(Text);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

        expect(progressBarFinder, findsOneWidget);
      });
  testWidgets('Detail TvSeries Page should display Progressbar when loading',
          (WidgetTester tester) async {
        when(() => mockNotifier.state).thenReturn(StateHasData(testTvSeriesList));

        final progressBarFinder = find.byType(Container);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

        expect(progressBarFinder, findsOneWidget);
      });
  testWidgets('Detail TvSeries Page should display Progressbar when loading',
          (WidgetTester tester) async {
        when(() => mockNotifier.add(OnIdChanged(1)))
            .thenReturn(StateHasDataSingle<TvSeriesDetail>(testTvSeriesDetail));
        when(() => mockNotifier.state)
            .thenReturn(StateHasDataSingle<TvSeriesDetail>(testTvSeriesDetail));
        when(() => mockRecommendationTvSeriesBloc.add(OnIdChanged(1)))
            .thenReturn(StateHasData.initial().copyWith(testTvSeriesList));
        when(() => mockRecommendationTvSeriesBloc.state).thenAnswer(
                (invocation) => StateHasData.initial().copyWith(testTvSeriesList));
        when(() => mockTvSeriesWatchlistStatusBloc.add(OnIdChanged(1)))
            .thenReturn(StateHasDataDual.initial().copyWith(false, ""));
        when(() => mockTvSeriesWatchlistStatusBloc.state)
            .thenReturn(StateHasDataDual.initial().copyWith(false, ""));
        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });
  testWidgets('Detail TvSeries Page should display Progressbar when loading',
          (WidgetTester tester) async {
        when(() => mockNotifier.add(OnIdChanged(1)))
            .thenReturn(StateHasDataSingle<TvSeriesDetail>(testTvSeriesDetail));
        when(() => mockNotifier.state)
            .thenReturn(StateHasDataSingle<TvSeriesDetail>(testTvSeriesDetail));
        when(() => mockRecommendationTvSeriesBloc.add(OnIdChanged(1)))
            .thenReturn(StateHasData.initial().copyWith(testTvSeriesList));
        when(() => mockRecommendationTvSeriesBloc.state).thenAnswer(
                (invocation) => StateHasData.initial().copyWith(testTvSeriesList));
        when(() => mockTvSeriesWatchlistStatusBloc.add(OnIdChanged(1)))
            .thenReturn(StateHasDataDual.initial().copyWith(true, ""));
        when(() => mockTvSeriesWatchlistStatusBloc.state)
            .thenReturn(StateHasDataDual.initial().copyWith(true, ""));
        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });
  testWidgets('Detail TvSeries Page should display Progressbar when loading',
          (WidgetTester tester) async {
        when(() => mockNotifier.add(OnIdChanged(1)))
            .thenReturn(StateHasDataSingle<TvSeriesDetail>(testTvSeriesDetail));
        when(() => mockNotifier.state)
            .thenReturn(StateHasDataSingle<TvSeriesDetail>(testTvSeriesDetail));
        when(() => mockRecommendationTvSeriesBloc.add(OnIdChanged(1)))
            .thenReturn(StateHasData.initial().copyWith(testTvSeriesList));
        when(() => mockRecommendationTvSeriesBloc.state).thenAnswer(
                (invocation) => StateHasData.initial().copyWith(testTvSeriesList));
        when(() => mockTvSeriesWatchlistStatusBloc.add(OnIdChanged(1))).thenReturn(
            StateHasDataDual.initial().copyWith(false, "Added to Watchlist"));
        when(() => mockTvSeriesWatchlistStatusBloc.state).thenReturn(
            StateHasDataDual.initial().copyWith(false, "Added to Watchlist"));
        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });
  // testWidgets('Detail TvSeries Page should display Progressbar when loading',
  //     (WidgetTester tester) async {
  //   when(() => mockNotifier.add(OnIdChanged(1)))
  //       .thenReturn(StateHasDataSingle<TvSeriesDetail>(testTvSeriesDetail));
  //   when(() => mockNotifier.state)
  //       .thenReturn(StateHasDataSingle<TvSeriesDetail>(testTvSeriesDetail));
  //   when(() => mockRecommendationTvSeriesBloc.add(OnIdChanged(1)))
  //       .thenReturn(StateHasData.initial().copyWith(testTvSeriesList));
  //   when(() => mockRecommendationTvSeriesBloc.state).thenAnswer(
  //       (invocation) => StateHasData.initial().copyWith(testTvSeriesList));
  //   when(() => mockTvSeriesWatchlistStatusBloc.add(OnIdChanged(1)))
  //       .thenReturn(StateHasDataDual.initial().copyWith(false, "Failed"));
  //   when(() => mockTvSeriesWatchlistStatusBloc.state)
  //       .thenReturn(StateHasDataDual.initial().copyWith(false, "Failed"));
  //   final watchlistButton = find.byType(ElevatedButton);
  //
  //   await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
  //
  //   expect(find.byIcon(Icons.add), findsOneWidget);
  //
  //   await tester.tap(watchlistButton);
  //   await tester.pump();
  //
  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   expect(find.text('Failed'), findsOneWidget);
  // });
  // testWidgets(
  //     'Watchlist button should display AlertDialog when add to watchlist failed',
  //         (WidgetTester tester) async {
  //       when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
  //       when(mockNotifier.movie).thenReturn(testTvSeriesDetail);
  //       when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
  //       when(mockNotifier.movieRecommendations).thenReturn(<TvSeries>[]);
  //       when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  //       when(mockNotifier.watchlistMessage).thenReturn('Failed');
  //
  //       final watchlistButton = find.byType(ElevatedButton);
  //
  //       await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
  //
  //       expect(find.byIcon(Icons.add), findsOneWidget);
  //
  //       await tester.tap(watchlistButton);
  //       await tester.pump();
  //
  //       expect(find.byType(AlertDialog), findsOneWidget);
  //       expect(find.text('Failed'), findsOneWidget);
  //     });
}

