///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:mg/mg_api/base/mg_client.dart';
import 'package:mg/mg_api/base/mg_response.dart';
import 'package:mg/mg_api/requests/requests.dart' as MGRequest;

import 'models/models.dart' as Model;

void main() async {
  MGClient client = MGClient();

  /* test requests */
  final Model.Boss boss = Model.Boss(3102, 1000, 1);
  final String region = 'eu';

  // ranking 24 hours: EU
  {
    MGResponse r = await client.get(MGRequest.Ranking24Hour(region));
    print(r);
  }


  // ranking class: Commander Kalligar, EU
  {
    MGResponse r = await client.get(MGRequest.RankingClass.fromBoss(region, MGRequest.PlayerRole.DPS, boss));
    print(r);
  }

  // ranking party: Commander Kalligar, EU
  {
    MGResponse r = await client.get(MGRequest.RankingParty.fromBoss(region, boss));
    print(r);
  }

  // ranking user: Commander Kalligar, EU
  {
    MGResponse r = await client.get(MGRequest.RankingClearsUsers.fromBoss(region, boss));
    print(r);
  }

  // ranking characters: Commander Kalligar, EU
  {
    MGResponse r = await client.get(MGRequest.RankingClearsCharacters.fromBoss(region, boss));
    print(r);
  }

  // related characters: EU
  {
    MGResponse r = await client.get(MGRequest.RelatedCharacters(region, 'Kami-Kaze'));
    print(r);
  }

  // search: Kami-Kaze, EU
  {
    MGResponse r = await client.get(MGRequest.Search(region, 'Kami-Kaze'));
    print(r);
  }

  // upload recent: EU
  {
    MGResponse r = await client.get(MGRequest.UploadRecent(region));
    print(r);
  }

  // verification restricted
  {
    MGResponse r = await client.get(MGRequest.VerificationRestricted());
    print(r);
  }
}