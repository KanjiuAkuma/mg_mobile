///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../../mg_api/base/mg_request.dart';
import '../../mg_api/base/mg_response.dart';

class RequestState<T extends MgRequest> {
  final T request;
  final RequestLoadedState<T> previousComplete;

  RequestState(this.request, this.previousComplete);
}

class RequestNoneState<T extends MgRequest> extends RequestState<T> {
  RequestNoneState(RequestLoadedState<T> previousComplete) : super(null, previousComplete);
}

class RequestLoadingState<T extends MgRequest> extends RequestState<T> {
  RequestLoadingState(T request, RequestLoadedState<T> previousComplete) : super(request, previousComplete);
}

class RequestLoadedState<T extends MgRequest> extends RequestState<T> {
  final MGResponse response;

  RequestLoadedState(this.response, T request, RequestLoadedState<T> previousComplete) : super(request, previousComplete?.copyWithoutPrevious());

  RequestLoadedState<T> copyWithoutPrevious() {
    return RequestLoadedState<T>(this.response, this.request, null);
  }
}

class RequestErrorState<T extends MgRequest> extends RequestState<T> {
  final String error;

  RequestErrorState(this.error, T request, RequestLoadedState<T> previousComplete) : super(request, previousComplete);
}