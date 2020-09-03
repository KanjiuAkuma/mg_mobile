///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'mg_request.dart';
import 'response_status.dart';

class MGResponse<T> extends Iterable<T> {
  final MgRequest<T> _request;
  final ResponseStatus _status;
  final String _rawResponse;
  final List<T> _data;

  MGResponse(this._request, this._status, this._rawResponse, this._data);

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
