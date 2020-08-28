///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_state.dart';
import '../../../bloc/request/request_event.dart';

import '../../theme.dart' as MgTheme;

import '../../../mg_api/requests/requests.dart' as Requests;
import '../../../models/models.dart' as Model;

import '../../widgets/character_search_bar.dart';
import '../../widgets/log_party_card.dart';

class PlayerSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayerSearchState();
}

class _PlayerSearchState extends State<PlayerSearch> {
  bool disposeLoadingIndicator, isFetchingMore;

  Future<void> shouldDisposeLoadingIndicator() async {
    if (!disposeLoadingIndicator) {
      return Future<void>(() => shouldDisposeLoadingIndicator());
    }
  }

  Widget _buildError(Requests.Search request, String err) {
    return GestureDetector(
      onTap: () => BlocProvider.of<RequestBloc<Requests.Search>>(context).add(RequestEvent<Requests.Search>(request)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong.',
            style: MgTheme.Text.normal,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            err,
            style: MgTheme.Text.normal.copyWith(color: Colors.red[800]),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Tap to retry',
            style: MgTheme.Text.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildEmpty() {
    return Center();
  }

  Widget _buildLoaded(List<Model.LogParty> logs, Requests.Search request) {
    disposeLoadingIndicator = true;
    return RefreshIndicator(
      color: MgTheme.Foreground.accent,
      backgroundColor: MgTheme.Background.appBar,
      onRefresh: () async {
        disposeLoadingIndicator = false;
        // yield search again
        BlocProvider.of<RequestBloc<Requests.Search>>(context)
            .add(RequestEvent<Requests.Search>(request.copyWith(page: 0)));
        return Future<void>(() => shouldDisposeLoadingIndicator());
      },
      child: ListView.builder(
        itemCount: logs.length + (request.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < logs.length) {
            return LogPartyCard(logs[index]);
          } else {
            if (!isFetchingMore) {
              isFetchingMore = true;
              BlocProvider.of<RequestBloc<Requests.Search>>(context)
                  .add(RequestEvent<Requests.Search>(Requests.Search.fetchMore(request, logs)));
            }
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: MgTheme.Background.appBar,
                    valueColor: AlwaysStoppedAnimation<Color>(MgTheme.Foreground.accent),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isFetchingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search bar
        CharacterSearchBar(),
        SizedBox(
          height: 10,
        ),
        // search results
        Expanded(
          child: BlocBuilder<RequestBloc<Requests.Search>, RequestState<Requests.Search>>(
            buildWhen: (previous, current) {
              return !(current is RequestLoadingState<Requests.Search> &&
                  (current.request.page != 0 || current.previousComplete != null));
            },
            builder: (context, state) {
              if (state is RequestNoneState<Requests.Search>) {
                return _buildEmpty();
              } else if (state is RequestLoadingState<Requests.Search>) {
                return _buildLoading();
              } else if (state is RequestLoadedState<Requests.Search>) {
                isFetchingMore = false;
                return _buildLoaded(state.response.data, state.request);
              } else {
                if (state is RequestErrorState<Requests.Search>) {
                  return _buildError(state.request, state.error);
                }
                return _buildError(state.request, 'Unknown error');
              }
            },
          ),
        )
      ],
    );
  }
}
