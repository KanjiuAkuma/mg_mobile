///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import '../base/mg_request.dart';
import '../base/mg_response.dart';
import '../base/response_status.dart';
import 'package:mg/models/models.dart' as Model;

final String _endpoint = 'ranking_24hour';

class Ranking24Hour extends MgRequest<Model.LogCharacter> {
  Ranking24Hour(String region) : super(region, _endpoint, {'region': region});

  @override
  MgResponse<Model.LogCharacter> buildResponse(ResponseStatus status, String rawResponse, List<dynamic> jsonData) {
    List<Model.LogCharacter> data = jsonData.map((e) => Model.LogCharacter.fromJson(e)).toList();

    return MgResponse<Model.LogCharacter>(
      this,
      status,
      rawResponse,
      data,
    );
  }
}
