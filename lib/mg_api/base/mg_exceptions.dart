///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'package:http/http.dart' as http;

/// Base exception class
class MgClientException implements Exception {
  final String reason;
  final http.Response response;

  MgClientException(this.reason, this.response);

  @override
  String toString() {
    return 'MgClientException: $reason';
  }
}

class MgBadResponseCode extends MgClientException {
  MgBadResponseCode(http.Response response)
      : super('Bad response code ${response.statusCode} (${response.reasonPhrase}', response);
}

class MgMaxRetriesExceeded extends MgClientException {
  final dynamic error;
  MgMaxRetriesExceeded(int retries, this.error, http.Response response)
      : super('Max retries ($retries) exceeded', response);
}
