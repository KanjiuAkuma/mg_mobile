///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import '../base/mg_response.dart';
import '../base/response_status.dart';
import 'package:mg/models/models.dart' as Model;

String _endpoint = 'related_characters';

class RelatedCharacters extends MgRequest<Model.Character> {
  RelatedCharacters(String region, String characterName, [String server])
      : super(region, _endpoint, {
          'region': region,
          'name': characterName,
          if (server != null) 'server': server,
        });

  RelatedCharacters.fromCharacter(String region, Model.Character character, [String server])
    : this(region, character.name, server);

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
