///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mg_api/base/mg_request.dart';
import '../../mg_api/base/mg_client.dart';

import 'request_event.dart';
import 'request_state.dart';

class RequestBloc<T extends MgRequest> extends Bloc<RequestEvent<T>, RequestState<T>> {
  final MGClient client = MGClient.instance;

  RequestBloc() : super(RequestNoneState<T>(null));

  @override
  Stream<RequestState<T>> mapEventToState(RequestEvent<T> event) async* {
    RequestState<T> currentState = state;
    // signal request is loading
    yield RequestLoadingState<T>(event.request, currentState is RequestLoadedState ? currentState : null);

    // get response
    try {
      yield RequestLoadedState<T>(await client.get(event.request), event.request, currentState is RequestLoadedState ? currentState : null);
    } catch (err) {
      // failed
      print(err);
      yield RequestErrorState<T>(err.toString(), event.request, currentState is RequestLoadedState ? currentState : null);
    }
  }
}
