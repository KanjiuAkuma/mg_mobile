///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'package:http/http.dart' as http;

/// Base exception class
class MGClientException implements Exception {
  final String reason;
  final http.Response response;

  MGClientException(this.reason, this.response);
}

class MGBadResponseCode extends MGClientException {
  MGBadResponseCode(http.Response response)
      : super('Bad response code ${response.statusCode} (${response.reasonPhrase}', response);
}