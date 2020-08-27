///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../../mg_api/base/mg_request.dart';
import '../../mg_api/base/mg_response.dart';

class RequestState<T extends MGRequest> {
  final T request;
  final RequestLoadedState<T> previousComplete;

  RequestState(this.request, this.previousComplete);
}

class RequestNoneState<T extends MGRequest> extends RequestState<T> {
  RequestNoneState(RequestLoadedState<T> previousComplete) : super(null, previousComplete);
}

class RequestLoadingState<T extends MGRequest> extends RequestState<T> {
  RequestLoadingState(T request, RequestLoadedState<T> previousComplete) : super(request, previousComplete);
}

class RequestLoadedState<T extends MGRequest> extends RequestState<T> {
  final MGResponse response;

  RequestLoadedState(this.response, T request, RequestLoadedState<T> previousComplete) : super(request, previousComplete);
}

class RequestErrorState<T extends MGRequest> extends RequestState<T> {
  RequestErrorState(T request, RequestLoadedState<T> previousComplete) : super(request, previousComplete);
}