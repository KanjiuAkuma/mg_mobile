///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

String _endpoint = 'related_characters';

class RelatedCharacters extends MGRequest {
  RelatedCharacters(String region, String characterName, [String server])
      : super(_endpoint, {
          'region': region,
          'name': characterName,
          if (server != null) 'server': server,
        });

  RelatedCharacters.fromCharacter(String region, Model.Character character, [String server])
    : this(region, character.name, server);

  @override
  List<Model.Character> parseResponseJson(List<dynamic> responseJson) {
    return responseJson.map((e) => Model.Character.fromJson(e)).toList();
  }
}
