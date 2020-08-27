///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../mg_api/base/mg_request.dart';
import '../mg_api/base/mg_response.dart';

class RequestState<T extends MGRequest> {
  final T request;

  RequestState(this.request);
}

class RequestNoneState<T extends MGRequest> extends RequestState<T> {
  RequestNoneState() : super(null);
}

class RequestLoadingState<T extends MGRequest> extends RequestState<T> {
  RequestLoadingState(T request) : super(request);
}

class RequestLoadedState<T extends MGRequest> extends RequestState<T> {
  final MGResponse response;

  RequestLoadedState(this.response, T request) : super(request);
}

class RequestErrorState<T extends MGRequest> extends RequestState<T> {
  RequestErrorState(T request) : super(request);
}