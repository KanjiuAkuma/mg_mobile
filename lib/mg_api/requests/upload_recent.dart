///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

final String _endpoint = 'upload_recent';

class UploadRecent extends MGRequest {
  UploadRecent(String region) : super(_endpoint, {'region': region});

  @override
  List<Model.LogParty> parseResponseJson(List<dynamic> responseJson) {
    if (0 == responseJson.length) {
      print('Warning: No results returned for $this');
      return [];
    }

    List<Model.LogParty> logs = [];

    // parse party batches
    String logId = responseJson[0]['logId'];
    List<Map<String, dynamic>> entries = [responseJson[0]];

    for (int i = 1; i < responseJson.length; i++) {
      Map<String, dynamic> entry = responseJson[i];

      if (logId != entry ['logId']) {
        logs.add(Model.LogParty.fromJson(entries));
        logId = entry['logId'];
        entries = [];
      }

      entries.add(responseJson[i]);
    }

    // append last batch
    if (0 < entries.length) {
      logs.add(Model.LogParty.fromJson(entries));
    }

    return logs;
  }

}