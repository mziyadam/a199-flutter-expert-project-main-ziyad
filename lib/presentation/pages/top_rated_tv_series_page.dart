import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/bloc_event.dart';
import 'package:ditonton/presentation/bloc/bloc_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_list/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';

  @override
  _TopRatedTvSeriesPageState createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() =>
    //     Provider.of<TopRatedTvSeriesNotifier>(context, listen: false)
    //         .fetchTopRatedTvSeries());
    context.read<TopRatedTvSeriesBloc>().add(OnVoid());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TvSeries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesBloc, BlocState>(
          builder: (context, state) {
            if (state is StateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StateHasData<TvSeries>) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return TvSeriesCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if(state is StateError){
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }else{
              return Container();
            }
          },
        ),
      ),
    );
  }
}
