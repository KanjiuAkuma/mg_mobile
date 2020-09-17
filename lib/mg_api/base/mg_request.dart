///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'mg_response.dart';
import 'response_status.dart';

const double _updateInterval = 12e4; // 2 minutes

abstract class MgRequest<T> {
  final String _region;
  final String _apiEndpoint;
  final Map<String, dynamic> _parameters;
  final DateTime _createdAt = DateTime.now();


  MgRequest(this._region, this._apiEndpoint, this._parameters);

  /// To be implemented.
  /// Arguments:
  /// - status: Response status if response succeeded
  /// - rawResponse: Response body
  /// - jsonData: Response body as json
  ///
  /// Return:
  /// A [MgResponse] containing the given data
  MgResponse<T> buildResponse(ResponseStatus status, String rawResponse, List<dynamic> jsonData);

  get createdAt {
    return _createdAt;
  }

  get region {
    return _region;
  }

  bool shouldRefresh() {
    return DateTime.now().millisecondsSinceEpoch - _createdAt.millisecondsSinceEpoch > _updateInterval;
  }

  /// Creates a usable url from given data
  String build() {
    return '$_apiEndpoint?${_parameters.entries.map((e) => '${e.key}=${e.value}').join('&')}';
  }

  @override
  String toString() {
    return '[${super.toString()}]: ${build()}';
  }
}