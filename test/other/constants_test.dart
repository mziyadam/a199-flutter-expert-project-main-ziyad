import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // colors
  final tRichBlack = Color(0xFF000814);
  final tOxfordBlue = Color(0xFF001D3D);
  final tPrussianBlue = Color(0xFF003566);
  final tMikadoYellow = Color(0xFFffc300);
  final tDavysGrey = Color(0xFF4B5358);
  final tGrey = Color(0xFF303030);
// text style
  final tHeading5 =
      GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400);
  final tHeading6 = GoogleFonts.poppins(
      fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15);
  final tSubtitle = GoogleFonts.poppins(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15);
  final tBodyText = GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25);

  final  TEST_BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';

// text theme
  final tTextTheme = TextTheme(
    headline5: tHeading5,
    headline6: tHeading6,
    subtitle1: tSubtitle,
    bodyText2: tBodyText,
  );

  final tColorScheme = ColorScheme(
    primary: tMikadoYellow,
    primaryContainer: tMikadoYellow,
    secondary: tPrussianBlue,
    secondaryContainer: tPrussianBlue,
    surface: tRichBlack,
    background: tRichBlack,
    error: Colors.red,
    onPrimary: tRichBlack,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  test('should be a subclass of Movie entity', () async {
    expect(tRichBlack, kRichBlack);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tOxfordBlue, kOxfordBlue);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tPrussianBlue, kPrussianBlue);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tMikadoYellow, kMikadoYellow);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tDavysGrey, kDavysGrey);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tGrey, kGrey);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tHeading5, kHeading5);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tHeading6, kHeading6);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tSubtitle, kSubtitle);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tBodyText, kBodyText);
  });
  test('should be a subclass of Movie entity', () async {
    expect(TEST_BASE_IMAGE_URL, BASE_IMAGE_URL);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tTextTheme, kTextTheme);
  });
  test('should be a subclass of Movie entity', () async {
    expect(tColorScheme, kColorScheme);
  });
}
