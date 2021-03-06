///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart' as ioHttp;
import 'package:http/http.dart' as http;

import 'mg_request.dart';
import 'mg_response.dart';
import 'response_status.dart';
import 'mg_exceptions.dart';

/// MG endpoint url
final String _mgUrl = 'https://kabedon.moongourd.com/api/mg';

/// Client to access mg api
/// Use [instance] to obtain an instance.
class MgClient {
  final http.Client _httpClient = ioHttp.IOClient(HttpClient()..badCertificateCallback = (_, __, ___) => true);

  Future<MgResponse<T>> get<T>(MgRequest<T> request, [int retries = 5]) async {
    print('MgClient::get: $request');
    int tries = 0;
    http.Response r;
    var err;
    while (tries < retries) {
      try {
        r = await _httpClient.get('$_mgUrl/${request.build()}');
        if (r.statusCode != 200) {
          throw MgBadResponseCode(r);
        }

        return request.buildResponse(ResponseStatus.fromHttpResponse(r), r.body, json.decode(r.body));
      } catch (e) {
        err = e;
      }
      tries ++;
    }

    assert (err != null, 'Error and/or response was null after $tries retries but nothing returned!');
    throw MgMaxRetriesExceeded(retries, err, r);
  }

  /* Singleton */

  MgClient._();

  static final MgClient instance = MgClient._();
}
