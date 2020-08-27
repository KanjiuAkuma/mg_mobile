///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'package:flutter_bloc/flutter_bloc.dart';

import '../mg_api/base/mg_request.dart';
import '../mg_api/base/mg_client.dart';

import 'request_event.dart';
import 'request_state.dart';

class RequestBloc<T extends MGRequest> extends Bloc<RequestEvent<T>, RequestState<T>> {
  final MGClient client = MGClient.instance;

  RequestBloc() : super(RequestNoneState<T>());

  @override
  Stream<RequestState<T>> mapEventToState(RequestEvent<T> event) async* {
    // signal request is loading
    yield RequestLoadingState<T>(event.request);

    // get response
    try {
      yield RequestLoadedState<T>(await client.get(event.request), event.request);
    } catch (err) {
      // failed
      print(err);
      yield RequestErrorState<T>(event.request);
    }
  }
}
