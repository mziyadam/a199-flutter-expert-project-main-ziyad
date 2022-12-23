import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/recommendation_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_watchlist/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class MovieDetailEventFake extends Fake implements BlocEvent {}

class MovieDetailStateFake extends Fake implements BlocState {}

class MockTMovieDetailBloc extends MockBloc<BlocEvent, BlocState>
    implements MovieDetailBloc {}

class MockTWatchlistMoviesBloc extends MockBloc<BlocEvent, BlocState>
    implements WatchlistMoviesBloc {}

class MockTRecommendationMoviesBloc extends MockBloc<BlocEvent, BlocState>
    implements RecommendationMoviesBloc {}

class MockTMovieWatchlistStatusBloc
    extends MockBloc<BlocEvent, StateHasDataDual>
    implements MovieWatchlistStatusBloc {}

// @GenerateMocks([MovieDetailBloc,RecommendationMoviesBloc,MovieWatchlistStatusBloc])
void main() {
  late MockTMovieDetailBloc mockNotifier;
  late MockTRecommendationMoviesBloc mockRecommendationMoviesBloc;
  late MockTMovieWatchlistStatusBloc mockMovieWatchlistStatusBloc;
  late MockTWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
  });
  setUp(() {
    mockNotifier = MockTMovieDetailBloc();
    mockRecommendationMoviesBloc = MockTRecommendationMoviesBloc();
    mockMovieWatchlistStatusBloc = MockTMovieWatchlistStatusBloc();
    mockWatchlistMoviesBloc = MockTWatchlistMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(create: (_) => mockNotifier),
        BlocProvider<RecommendationMoviesBloc>(
            create: (_) => mockRecommendationMoviesBloc),
        BlocProvider<MovieWatchlistStatusBloc>(
            create: (_) => mockMovieWatchlistStatusBloc),
        BlocProvider<WatchlistMoviesBloc>(
            create: (_) => mockWatchlistMoviesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Detail Movie Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(StateLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });
  testWidgets('Detail Movie Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(StateError("message"));

    final progressBarFinder = find.byType(Text);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });
  testWidgets('Detail Movie Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(StateHasData(testMovieList));

    final progressBarFinder = find.byType(Container);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });
  testWidgets('Detail Movie Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.add(OnIdChanged(1)))
        .thenReturn(StateHasDataSingle<MovieDetail>(testMovieDetail));
    when(() => mockNotifier.state)
        .thenReturn(StateHasDataSingle<MovieDetail>(testMovieDetail));
    when(() => mockRecommendationMoviesBloc.add(OnIdChanged(1)))
        .thenReturn(StateHasData.initial().copyWith(testMovieList));
    when(() => mockRecommendationMoviesBloc.state).thenAnswer(
        (invocation) => StateHasData.initial().copyWith(testMovieList));
    when(() => mockMovieWatchlistStatusBloc.add(OnIdChanged(1)))
        .thenReturn(StateHasDataDual.initial().copyWith(false, ""));
    when(() => mockMovieWatchlistStatusBloc.state)
        .thenReturn(StateHasDataDual.initial().copyWith(false, ""));
    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
  testWidgets('Detail Movie Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.add(OnIdChanged(1)))
        .thenReturn(StateHasDataSingle<MovieDetail>(testMovieDetail));
    when(() => mockNotifier.state)
        .thenReturn(StateHasDataSingle<MovieDetail>(testMovieDetail));
    when(() => mockRecommendationMoviesBloc.add(OnIdChanged(1)))
        .thenReturn(StateHasData.initial().copyWith(testMovieList));
    when(() => mockRecommendationMoviesBloc.state).thenAnswer(
        (invocation) => StateHasData.initial().copyWith(testMovieList));
    when(() => mockMovieWatchlistStatusBloc.add(OnIdChanged(1)))
        .thenReturn(StateHasDataDual.initial().copyWith(true, ""));
    when(() => mockMovieWatchlistStatusBloc.state)
        .thenReturn(StateHasDataDual.initial().copyWith(true, ""));
    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
  testWidgets('Detail Movie Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.add(OnIdChanged(1)))
        .thenReturn(StateHasDataSingle<MovieDetail>(testMovieDetail));
    when(() => mockNotifier.state)
        .thenReturn(StateHasDataSingle<MovieDetail>(testMovieDetail));
    when(() => mockRecommendationMoviesBloc.add(OnIdChanged(1)))
        .thenReturn(StateHasData.initial().copyWith(testMovieList));
    when(() => mockRecommendationMoviesBloc.state).thenAnswer(
        (invocation) => StateHasData.initial().copyWith(testMovieList));
    when(() => mockMovieWatchlistStatusBloc.add(OnIdChanged(1))).thenReturn(
        StateHasDataDual.initial().copyWith(false, "Added to Watchlist"));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        StateHasDataDual.initial().copyWith(false, "Added to Watchlist"));
    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
  // testWidgets('Detail Movie Page should display Progressbar when loading',
  //     (WidgetTester tester) async {
  //   when(() => mockNotifier.add(OnIdChanged(1)))
  //       .thenReturn(StateHasDataSingle<MovieDetail>(testMovieDetail));
  //   when(() => mockNotifier.state)
  //       .thenReturn(StateHasDataSingle<MovieDetail>(testMovieDetail));
  //   when(() => mockRecommendationMoviesBloc.add(OnIdChanged(1)))
  //       .thenReturn(StateHasData.initial().copyWith(testMovieList));
  //   when(() => mockRecommendationMoviesBloc.state).thenAnswer(
  //       (invocation) => StateHasData.initial().copyWith(testMovieList));
  //   when(() => mockMovieWatchlistStatusBloc.add(OnIdChanged(1)))
  //       .thenReturn(StateHasDataDual.initial().copyWith(false, "Failed"));
  //   when(() => mockMovieWatchlistStatusBloc.state)
  //       .thenReturn(StateHasDataDual.initial().copyWith(false, "Failed"));
  //   final watchlistButton = find.byType(ElevatedButton);
  //
  //   await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
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
  //       when(mockNotifier.movie).thenReturn(testMovieDetail);
  //       when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
  //       when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
  //       when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  //       when(mockNotifier.watchlistMessage).thenReturn('Failed');
  //
  //       final watchlistButton = find.byType(ElevatedButton);
  //
  //       await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
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

/*
import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/recommendation_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

// Mock Bloc
class MockMovieDetailBloc extends MockBloc<BlocEvent, BlocState>
    implements MovieDetailBloc {}

class MockRecommendationMoviesBloc
    extends MockBloc<BlocEvent, BlocState>
    implements RecommendationMoviesBloc {}

class MockMovieWatchlistStatusBloc
    extends MockBloc<BlocEvent, StateHasDataDual>
    implements MovieWatchlistStatusBloc {}

// Mock event
class FakeMovieDetailEvent extends Fake implements BlocEvent {}

class FakeMovieRecommendationsEvent extends Fake
    implements BlocEvent {}

class FakeWatchlistStatusEvent extends Fake implements BlocEvent {}

// Mock state
class FakeMovieDetailState extends Fake implements BlocEvent {}

class FakeMovieRecommendationsState extends Fake
    implements BlocEvent {}

class FakeWatchlistStatusState extends Fake implements BlocEvent {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockRecommendationMoviesBloc mockRecommendationMoviesBloc;
  late MockMovieWatchlistStatusBloc mockMovieWatchlistStatusBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    registerFallbackValue(FakeMovieRecommendationsEvent());
    registerFallbackValue(FakeMovieRecommendationsState());
    registerFallbackValue(FakeWatchlistStatusEvent());
    registerFallbackValue(FakeWatchlistStatusState());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockRecommendationMoviesBloc = MockRecommendationMoviesBloc();
    mockMovieWatchlistStatusBloc = MockMovieWatchlistStatusBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieDetailBloc>(create: (_) => mockMovieDetailBloc),
          BlocProvider<RecommendationMoviesBloc>(
              create: (_) => mockRecommendationMoviesBloc),
          BlocProvider<MovieWatchlistStatusBloc>(
              create: (_) => mockMovieWatchlistStatusBloc),
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  tearDown(() {
    mockMovieDetailBloc.close();
    mockRecommendationMoviesBloc.close();
    mockMovieWatchlistStatusBloc.close();
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockMovieDetailBloc.state)
            .thenAnswer((invocation) => StateHasDataSingle(testMovieDetail));
        when(() =>
            mockRecommendationMoviesBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockRecommendationMoviesBloc.state)
            .thenAnswer((invocation) => StateHasData(tMovies));
        when(() => mockMovieWatchlistStatusBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockMovieWatchlistStatusBloc.state)
            .thenAnswer((invocation) => StateHasDataDual(false, ''));

        final watchlistButtonIcon = find.byIcon(Icons.add);
        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockMovieDetailBloc.state)
            .thenAnswer((invocation) => StateHasDataSingle(testMovieDetail));
        when(() =>
            mockRecommendationMoviesBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockRecommendationMoviesBloc.state)
            .thenAnswer((invocation) => StateHasData(tMovies));
        when(() => mockMovieWatchlistStatusBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockMovieWatchlistStatusBloc.add(OnSavedMovie(testMovieDetail)))
            .thenAnswer((invocation) {});
        when(() => mockMovieWatchlistStatusBloc.state).thenAnswer(
                (invocation) => StateHasDataDual(true, 'Added to Watchlist'));

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockMovieDetailBloc.state)
            .thenAnswer((invocation) => StateHasDataSingle(testMovieDetail));
        when(() =>
            mockRecommendationMoviesBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockRecommendationMoviesBloc.state)
            .thenAnswer((invocation) => StateHasData(tMovies));
        when(() => mockMovieWatchlistStatusBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockMovieWatchlistStatusBloc.state)
            .thenAnswer((invocation) => StateHasDataDual(false, ''));

        final watchlistButton = find.byType(ElevatedButton);
        final expectedStates = [
          StateHasDataDual(false, ''),
          StateHasDataDual(true, 'Added to Watchlist')
        ];

        whenListen(mockMovieWatchlistStatusBloc, Stream.fromIterable(expectedStates));
        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

        expect(find.byIcon(Icons.add), findsOneWidget);
        await tester.tap(watchlistButton);

        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockMovieDetailBloc.state)
            .thenAnswer((invocation) => StateHasDataSingle(testMovieDetail));
        when(() =>
            mockRecommendationMoviesBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockRecommendationMoviesBloc.state)
            .thenAnswer((invocation) => StateHasData(tMovies));
        when(() => mockMovieWatchlistStatusBloc.add(OnIdChanged(tId)))
            .thenAnswer((invocation) {});
        when(() => mockMovieWatchlistStatusBloc.state)
            .thenAnswer((invocation) => StateHasDataDual(false, ''));

        final watchlistButton = find.byType(ElevatedButton);
        whenListen(
            mockMovieWatchlistStatusBloc,
            Stream.fromIterable([
              StateHasDataDual(false, ''),
              StateHasDataDual(false, 'Failed')
            ]));
        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('Failed'), findsNothing);
        await tester.tap(watchlistButton, warnIfMissed: false);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });
}*/
