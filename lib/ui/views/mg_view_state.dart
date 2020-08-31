///
/// Created by Kanjiu Akuma on 8/31/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/request/request_bloc.dart';
import '../../bloc/request/request_state.dart';
import '../../bloc/request/request_event.dart';

import '../../bloc/region/region_bloc.dart';
import '../../bloc/region/region_state.dart';

import '../../mg_api/base/mg_request.dart';

import '../theme.dart' as MgTheme;

abstract class RequestFactory<R extends MgRequest> {
  R createRequest(String region);
}

abstract class MgViewState<W extends StatefulWidget, T, R extends MgRequest<T>> extends State<W> {
  MgViewState({
    Widget header,
    @required RequestFactory<R> requestFactory,
  })  : _header = header,
        _requestFactory = requestFactory;

  final Widget _header;
  final RequestFactory<R> _requestFactory;
  ScrollController _scrollController = ScrollController();
  bool _isLoadingIndicatorShowing = false;

  Future<void> _shouldDisposeLoadingIndicator() async {
    if (_isLoadingIndicatorShowing) {
      return Future<void>(() => _shouldDisposeLoadingIndicator());
    }
  }

  /// Hook to force or suppress refresh upon certain states
  bool shouldRebuild(RequestState<R> requestState) {
    if (requestState is RequestLoadingState<R>) return !_isLoadingIndicatorShowing;
    return true;
  }

  /// To be overwritten
  Widget buildItem(T item);

  /// Default implementation for build error
  Widget buildError(R request, String err) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () => BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(request)),
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

  /// Default implementation for build loading
  Widget buildLoading() {
    return Expanded(child: Center(child: CircularProgressIndicator()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegionBloc, RegionState>(
      listener: (context, state) {
        // fetch again, region changed
        R request = _requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region);
        if (request != null) {
          BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(request));
        }
      },
      child: RefreshIndicator(
        color: MgTheme.Foreground.accent,
        backgroundColor: MgTheme.Background.appBar,
        onRefresh: () async {
          _isLoadingIndicatorShowing = true;
          R request = _requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region);
          if (request != null) {
            BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(request));
            return Future<void>(() => _shouldDisposeLoadingIndicator());
          }
        },
        child: BlocBuilder<RequestBloc<R>, RequestState<R>>(
          buildWhen: (previous, current) {
            return shouldRebuild(current);
          },
          builder: (context, state) {
            int itemCount = _header != null ? 1 : 0;
            List<T> logs;

            if (state is RequestLoadedState<R>) {
              _isLoadingIndicatorShowing = false;
              itemCount += state.response.data.length;
              logs = state.response.data;
            } else if (state is RequestNoneState<R>) {
              // nothing fetched yet => fetch new
              R request = _requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region);
              if (request != null) {
                BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(request));
                itemCount += 1;
              } else {
                logs = [];
              }
            } else if (state is RequestLoadingState<R>) {
              return Column(
                children: [
                  if (_header != null)
                    _header,
                  buildLoading(),
                ],
              );
            } else {
              itemCount += 1;
            }

            return ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (_header != null) {
                  if (index == 0) {
                    return _header;
                  }
                  index--;
                }

                if (logs != null) {
                  // state is either loaded or none
                  return buildItem(logs[index]);
                } else if (state is RequestLoadingState<R>) {
                  return buildLoading();
                } else {
                  if (state is RequestErrorState<R>) {
                    return buildError(state.request, state.error);
                  }
                  return buildError(state.request, 'Unknown state $state');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
