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
  bool _disposeLoadingIndicator, _isFetchingMore;
  CharacterSearchBar _characterSearchBar;
  ScrollController _scrollController;

  Future<void> shouldDisposeLoadingIndicator() async {
    if (!_disposeLoadingIndicator) {
      return Future<void>(() => shouldDisposeLoadingIndicator());
    }
  }

  Widget _buildError(Requests.Search request, String err) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () => BlocProvider.of<RequestBloc<Requests.Search>>(context).add(RequestEvent<Requests.Search>(request)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Something went wrong, Tap to retry:',
              style: MgTheme.Text.normal,
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                err,
                style: MgTheme.Text.normal.copyWith(color: Colors.red[800]),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  @override
  void initState() {
    super.initState();
    _isFetchingMore = false;
    _characterSearchBar = CharacterSearchBar();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc<Requests.Search>, RequestState<Requests.Search>>(
      buildWhen: (previous, current) {
        if (current is RequestLoadedState<Requests.Search>) {
          if (current.request.page == 0) {
            _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.linear);
          }
        }
        return !(current is RequestLoadingState<Requests.Search> &&
            (current.request.page != 0 || current.previousComplete != null));
      },
      builder: (context, state) {
        int itemCount = 0;
        if (state is RequestLoadedState<Requests.Search>) {
          _isFetchingMore = false;
          _disposeLoadingIndicator = true;
          itemCount = state.response.data.length + (state.request.hasMore ? 1 : 0);
        }
        else if (!(state is RequestNoneState<Requests.Search>)) {
          itemCount = 1;
        } else if (state is RequestLoadingState<Requests.Search>) {
          return _buildLoading();
        }

        return RefreshIndicator(
          color: MgTheme.Foreground.accent,
          backgroundColor: MgTheme.Background.appBar,
          onRefresh: () async {
            if (!(state is RequestNoneState<Requests.Search>)) {
              _disposeLoadingIndicator = false;
              // yield search again
              BlocProvider.of<RequestBloc<Requests.Search>>(context)
                  .add(RequestEvent<Requests.Search>(state.request.copyWith(page: 0)));
              return Future<void>(() => shouldDisposeLoadingIndicator());
            }
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 1 + itemCount,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    // CharacterSearchBar(),
                    _characterSearchBar,
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
              index -= 1;
              if (state is RequestLoadedState<Requests.Search>) {
                if (index < state.response.data.length) {
                  return LogPartyCard(state.response.data[index]);
                } else {
                  if (!_isFetchingMore) {
                    _isFetchingMore = true;
                    BlocProvider.of<RequestBloc<Requests.Search>>(context)
                        .add(RequestEvent<Requests.Search>(Requests.Search.fetchMore(state.request, state.response.data)));
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
              }
              else if (state is RequestLoadingState<Requests.Search>) {
                return _buildLoading();
              } else {
                if (state is RequestErrorState<Requests.Search>) {
                  return _buildError(state.request, state.error);
                }
                return _buildError(state.request, 'Unknown error');
              }
            },
          ),
        );
      },
    );
  }
}
