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
  bool disposeLoadingIndicator = false;

  Future<void> shouldDisposeLoadingIndicator() async {
    if (!disposeLoadingIndicator) {
      return Future<void>(() => shouldDisposeLoadingIndicator());
    }
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
    return Center(child: CircularProgressIndicator());
  }

  /// Default implementation for build loaded
  Widget buildLoaded(List<T> logs) {
    disposeLoadingIndicator = true;
    return RefreshIndicator(
      color: MgTheme.Foreground.accent,
      backgroundColor: MgTheme.Background.appBar,
      onRefresh: () async {
        disposeLoadingIndicator = false;
        BlocProvider.of<RequestBloc<R>>(context)
            .add(RequestEvent<R>(_requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region)));
        return Future<void>(() => shouldDisposeLoadingIndicator());
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: logs.length + (_header == null ? 0 : 1),
        itemBuilder: (context, index) {
          if (_header != null) {
            if (index == 0) {
              return _header;
            }
            index--;
          }
          return buildItem(logs[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegionBloc, RegionState>(
      listener: (context, state) {
        // fetch again, region changed
        BlocProvider.of<RequestBloc<R>>(context).add(RequestEvent<R>(_requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region)));
      },
      child: BlocBuilder<RequestBloc<R>, RequestState<R>>(
        buildWhen: (previous, current) {
          return current.previousComplete == null || current is RequestLoadedState || current is RequestErrorState;
        },
        builder: (context, state) {
          if (state is RequestNoneState<R>) {
            // nothing fetched yet => fetch new
            BlocProvider.of<RequestBloc<R>>(context)
                .add(RequestEvent<R>(_requestFactory.createRequest(BlocProvider.of<RegionBloc>(context).region)));
            return buildLoading();
          } else if (state is RequestLoadingState<R>) {
            return buildLoading();
          } else if (state is RequestLoadedState<R>) {
            return buildLoaded(state.response.data);
          } else {
            if (state is RequestErrorState<R>) {
              return buildError(state.request, state.error);
            }
            return buildError(state.request, 'Unknown state $state');
          }
        },
      ),
    );
  }
}
