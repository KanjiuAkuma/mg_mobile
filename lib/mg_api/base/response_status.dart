///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:http/http.dart' as http;

class ResponseStatus {
  final int code;
  final String phrase;

  ResponseStatus(this.code, this.phrase);

  factory ResponseStatus.fromHttpResponse(http.Response response) {
    return ResponseStatus(response.statusCode, response.reasonPhrase);
  }

  @override
  String toString() {
    return 'Status $code ($phrase)';
  }
}