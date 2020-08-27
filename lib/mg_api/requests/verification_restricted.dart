///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

final String _endpoint = 'verification_restricted';

class VerificationRestricted extends MGRequest<Model.Character> {
  VerificationRestricted() : super(_endpoint, {});

  @override
  List<Model.Character> parseResponseJson(List<dynamic> responseJson) {
    return responseJson.map((e) => Model.Character.fromJson(e)).toList();
  }
}