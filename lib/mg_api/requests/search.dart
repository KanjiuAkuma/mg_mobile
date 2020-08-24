///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

final String _endpoint = 'search';

class Search extends MGRequest {
  final Model.Boss boss;

  Search._(String region, String characterName, Model.Boss boss, String server, bool searchForGuild, int page,
      bool sortByDps)
      : boss = boss,
        super(_endpoint, {
        'region': region,
        'name': characterName,
        if (page != null) 'page': page,
        if (boss != null) 'zone': boss.zoneId,
        if (boss != null) 'boss': boss.bossId,
        if (boss != null) 'version': boss.version,
        if (server != null) 'server': server,
        if (searchForGuild) 'guild': 'guild',
        if (sortByDps) 'sort': 'dps'
      });

  factory Search(String region,
      String characterName, {
        int zoneId,
        int bossId,
        int version,
        String server,
        bool searchForGuild = false,
        int page,
        bool sortByDps = false,
      }) {
    if (zoneId == null || bossId == null || version == null) {
      assert(zoneId == null && bossId == null && version == null, 'Only one of zoneId, bossId, version is set');
    }
    return Search._(
      region,
      characterName,
      zoneId != null ? Model.Boss(zoneId, bossId, version) : null,
      server,
      searchForGuild,
      page,
      sortByDps,
    );
  }

  factory Search.fromBoss(String region,
      String characterName,
      Model.Boss boss, {
        String server,
        bool searchForGuild = false,
        int page,
        bool sortByDps = false,
      }) {
    return Search._(
      region,
      characterName,
      boss,
      server,
      searchForGuild,
      page,
      sortByDps,
    );
  }

  @override
  List<Model.LogParty> parseResponseJson(List<dynamic> responseJson) {
    if (0 == responseJson.length || 0 == responseJson[0]['count']) {
      print('Warning: No results returned for $this');
      return [];
    }

    List<Model.LogParty> logs = [];

    responseJson = responseJson[1];

    // parse party batches
    String logId = responseJson[0]['logId'];
    List<Map<String, dynamic>> entries = [responseJson[0]];

    Function append;

    if (boss == null) {
      append = (e) => logs.add(Model.LogParty.fromJson(e));
    }
    else {
      append = (e) => logs.add(Model.LogParty.fromJsonAndBoss(boss, e));
    }

    for (int i = 1; i < responseJson.length; i++) {
      Map<String, dynamic> entry = responseJson[i];

      if (logId != entry ['logId']) {
        append(entries);
        logId = entry['logId'];
        entries = [];
      }

      entries.add(responseJson[i]);
    }

    // append last batch
    if (0 < entries.length) {
      append(entries);
    }

    return logs;
  }
}
