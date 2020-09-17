///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import '../base/mg_response.dart';
import '../base/response_status.dart';
import 'package:mg/models/models.dart' as Model;

final String _endpoint = 'verification_restricted';

class VerificationRestricted extends MgRequest<Model.Character> {
  VerificationRestricted() : super('', _endpoint, {});

  @override
  MgResponse<Model.Character> buildResponse(ResponseStatus status, String rawResponse, List<dynamic> jsonData) {
    return MgResponse<Model.Character>(
      this,
      status,
      rawResponse,
      jsonData.map((e) => Model.Character.fromJson(e)).toList(),
    );
  }
}