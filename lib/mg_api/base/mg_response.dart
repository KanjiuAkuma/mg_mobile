///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'mg_request.dart';
import 'response_status.dart';

class MgResponse<T> extends Iterable<T> {
  final MgRequest<T> _request;
  final ResponseStatus _status;
  final String _rawResponse;
  final List<T> _data;

  MgResponse(this._request, this._status, this._rawResponse, this._data);

  /// The requests this response originated from
  MgRequest<T> get request {
    return _request;
  }

  /// Status code
  ResponseStatus get status {
    return _status;
  }

  /// Raw response
  String get rawResponse {
    return _rawResponse;
  }

  /// Parsed response json
  List<T> get data {
    return _data;
  }

  @override
  Iterator<T> get iterator => _data.iterator;

  @override
  String toString() {
    return "[Instance of 'MgResponse']: $status";
  }
}

typedef RequestBuilder<T, R extends MgRequest<T>> = R Function(R, Iterable<T>);

class ExtendableMgResponse<T, R extends MgRequest<T>> extends MgResponse<T> {

  final bool _canFetchMore;
  final RequestBuilder<T, R> _requestBuilder;

  ExtendableMgResponse(MgRequest<T> request, ResponseStatus status, String rawResponse, List<T> data, this._canFetchMore, this._requestBuilder)
    : super(request, status, rawResponse, data);

  /// Whether more data is available
  bool get canFetchMore {
    return _canFetchMore;
  }

  R buildNextRequest() {
    return _requestBuilder(this._request, this.data);
  }

}