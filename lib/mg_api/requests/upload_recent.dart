///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import '../base/mg_response.dart';
import '../base/response_status.dart';
import 'package:mg/models/models.dart' as Model;

final String _endpoint = 'upload_recent';

class UploadRecent extends MgRequest<Model.LogParty> {
  UploadRecent(String region) : super(region, _endpoint, {'region': region});

  @override
  MgResponse<Model.LogParty> buildResponse(ResponseStatus status, String rawResponse, List<dynamic> jsonData) {
    if (0 == jsonData.length) {
      print('Warning: No results returned for $this');
      return MgResponse<Model.LogParty>(
        this,
        status,
        rawResponse,
        [],
      );
    }

    List<Model.LogParty> logs = [];

    // parse party batches
    String logId = jsonData[0]['logId'];
    List<Map<String, dynamic>> entries = [jsonData[0]];

    for (int i = 1; i < jsonData.length; i++) {
      Map<String, dynamic> entry = jsonData[i];

      if (logId != entry ['logId']) {
        logs.add(Model.LogParty.fromJson(entries));
        logId = entry['logId'];
        entries = [];
      }

      entries.add(jsonData[i]);
    }

    // append last batch
    if (0 < entries.length) {
      logs.add(Model.LogParty.fromJson(entries));
    }

    return MgResponse<Model.LogParty>(
      this,
      status,
      rawResponse,
      logs,
    );
  }

}