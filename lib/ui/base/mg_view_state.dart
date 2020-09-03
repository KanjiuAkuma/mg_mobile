import 'dart:ui';

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
  R createRequest(String region, [bool changed = false]);
}

abstract class MgViewState<W extends StatefulWidget, T, R extends MgRequest<T>> extends State<W> {
  MgViewState({
    SliverPersistentHeaderDelegate header,
    @required RequestFactory<R> requestFactory,
  })  : _header = header,
        _requestFactory = requestFactory;

  final SliverPersistentHeaderDelegate _header;
  final RequestFactory<R> _requestFactory;
  bool _isLoadingIndicatorShowing = false;

  Future<void> _shouldDisposeLoadingIndicator() async {
    if (_isLoadingIndicatorShowing) {
      return Future<void>(() => _shouldDisposeLoadingIndicator());
    }
  }

  /// Hook to force or suppress refresh upon certain states
  bool shouldRebuild(RequestState<R> requestState) {
    if (requestState is RequestLoadingState<R>)
      return !_isLoadingIndicatorShowing && requestState.previousComplete == null;
    return true;
  }

  /// To be overwritten
  Widget buildItem(T item, int index);

  /// Default implementation for build error
  Widget buildError(R request, String err) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: GestureDetector(
        onTap: () => BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(request)),
        child: Container(
          width: double.infinity,
          color: MgTheme.Background.global,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Something went wrong, Tap to retry:',
                style: MgTheme.Text.normal,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  err,
                  style: MgTheme.Text.normal.copyWith(color: Colors.red[800]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Default implementation for build loading
  Widget buildLoading() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Default implementation for build loaded
  Widget buildLoaded(List<T> logs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return buildItem(logs[index], index);
        },
        childCount: logs.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegionBloc, RegionState>(
      listener: (context, state) {
        // fetch again, region changed
        // R request = _requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region, true);
        // if (request != null) {
        //   BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(request));
        // }
      },
      builder: (context, regionState) {
        return RefreshIndicator(
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
              List<Widget> slivers = [
                if (_header != null)
                  SliverPersistentHeader(
                    floating: true,
                    delegate: _header,
                  ),
              ];

              if (state is RequestLoadedState<R>) {
                _isLoadingIndicatorShowing = false;
                if (state.request.region != regionState.region) {
                  slivers.add(buildLoading());
                  R request = _requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region, true);
                  if (request != null) {
                    BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(request));
                  }
                } else {
                  if (state.request.shouldRefresh()) {
                    R request = _requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region);
                    if (request != null) {
                      BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(request));
                    }
                  }
                  slivers.add(buildLoaded(state.response.data));
                }
              } else if (state is RequestNoneState<R>) {
                // nothing fetched yet => fetch new
                R request = _requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region);
                if (request != null) {
                  BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(request));
                  slivers.add(buildLoading());
                }
                slivers.add(buildLoaded([]));
              } else if (state is RequestLoadingState<R>) {
                slivers.add(buildLoading());
              } else {
                _isLoadingIndicatorShowing = false;
                if (state is RequestErrorState<R>) {
                  slivers.add(buildError(state.request, state.error));
                } else {
                  assert(false, 'Unknown state $state!');
                  slivers.add(buildError(state.request, 'Unknown state $state!'));
                }
              }

              return CustomScrollView(
                slivers: slivers,
              );
            },
          ),
        );
      },
    );
  }
}
