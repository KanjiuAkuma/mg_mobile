///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

final String _endpoint = 'ranking_24hour';

class Ranking24Hour extends MGRequest {
  Ranking24Hour(String region) : super(_endpoint, {'region': region});

  @override
  List<Model.LogCharacter> parseResponseJson(List<dynamic> responseJson) {
    return responseJson.map((e) => Model.LogCharacter.fromJson(e)).toList();
  }
}
