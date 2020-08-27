///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/region/region_bloc.dart';
import '../../../bloc/region/region_state.dart';

import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_state.dart';
import '../../../bloc/request/request_event.dart';

import '../../theme.dart' as MgTheme;
import '../../widgets/log_character_card.dart';

import '../../../mg_api/requests/requests.dart' as Requests;
import '../../../models/models.dart' as Model;

class TodaysTopDps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodaysTopDpsState();
}

class _TodaysTopDpsState extends State<TodaysTopDps> {
  ScrollController _scrollController = ScrollController();
  bool disposeLoadingIndicator;

  Future<void> shouldDisposeLoadingIndicator() async {
    if (!disposeLoadingIndicator) {
      return Future<void>(() => shouldDisposeLoadingIndicator());
    }
  }

  Widget _buildError() {
    return Center(child: Text('Something went wrong'));
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildLoaded(List<Model.LogCharacter> logs) {
    disposeLoadingIndicator = true;
    return RefreshIndicator(
      color: MgTheme.Foreground.accent,
      backgroundColor: MgTheme.Background.appBar,
      onRefresh: () async {
        disposeLoadingIndicator = false;
        BlocProvider.of<RequestBloc<Requests.Ranking24Hour>>(context).add(
            RequestEvent<Requests.Ranking24Hour>(Requests.Ranking24Hour(BlocProvider.of<RegionBloc>(context).region)));
        return Future<void>(() => shouldDisposeLoadingIndicator());
      },
      child: ListView(
        controller: _scrollController,
        children: logs.map((l) => LogCharacterCard(l)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegionBloc, RegionState>(
      listener: (context, regionState) {
        // fetch recent uploads
        BlocProvider.of<RequestBloc<Requests.Ranking24Hour>>(context)
            .add(RequestEvent<Requests.Ranking24Hour>(Requests.Ranking24Hour(regionState.region)));
      },
      child: BlocBuilder<RequestBloc<Requests.Ranking24Hour>, RequestState<Requests.Ranking24Hour>>(
        buildWhen: (previous, current) {
          return current.previousComplete == null || current is RequestLoadedState || current is RequestErrorState;
        },
        builder: (context, state) {
          if (state is RequestNoneState<Requests.Ranking24Hour>) {
            // fetch new
            BlocProvider.of<RequestBloc<Requests.Ranking24Hour>>(context).add(RequestEvent<Requests.Ranking24Hour>(
                Requests.Ranking24Hour(BlocProvider.of<RegionBloc>(context).region)));
            return _buildLoading();
          } else if (state is RequestLoadingState<Requests.Ranking24Hour>) {
            return _buildLoading();
          } else if (state is RequestLoadedState<Requests.Ranking24Hour>) {
            return _buildLoaded(state.response.data);
          } else {
            assert(state is RequestErrorState<Requests.Ranking24Hour>, 'Unknown state $state!');
            return _buildError();
          }
        },
      ),
    );
  }
}
