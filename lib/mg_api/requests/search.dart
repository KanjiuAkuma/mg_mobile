///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import '../base/mg_response.dart';
import '../base/response_status.dart';
import 'package:mg/models/models.dart' as Model;

final String _endpoint = 'search';

class Search extends MgRequest<Model.LogParty> {

  final Model.Boss boss;
  final String region, characterName, server;
  final bool searchForGuild, sortByDps;
  final int page;
  final List<Model.LogParty> previousResults;

  Search._(String region, String characterName, Model.Boss boss, String server, bool searchForGuild, int page,
      bool sortByDps,
      [List<Model.LogParty> previousResults])
      : boss = boss,
        region = region,
        characterName = characterName,
        server = server,
        searchForGuild = searchForGuild,
        sortByDps = sortByDps,
        page = page ?? 0,
        previousResults = previousResults ?? [],
        super(region, _endpoint, {
          'region': region,
          'name': characterName,
          if (page != null) 'page': page,
          if (boss != null) 'zone': boss.zoneId,
          if (boss != null) 'boss': boss.bossId,
          if (boss != null) 'ver': boss.version,
          if (server != null) 'server': server,
          if (searchForGuild) 'type': 'guild',
          if (sortByDps) 'sort': 'dps'
        });

  factory Search(
    String region,
    String characterName, {
    int version,
    String zoneId,
    String bossId,
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
      zoneId != null ? Model.Boss(version, zoneId, bossId) : null,
      server,
      searchForGuild,
      page,
      sortByDps,
    );
  }

  factory Search.fromBoss(
    String region,
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

  Search copyWith({int page}) {
    return Search._(region, characterName, boss, server, searchForGuild, page ?? this.page, sortByDps);
  }

  factory Search.fetchMore(Search previous, List<Model.LogParty> results) {
    return Search._(
      previous.region,
      previous.characterName,
      previous.boss,
      previous.server,
      previous.searchForGuild,
      previous.page + 1,
      previous.sortByDps,
      results,
    );
  }

  @override
  ExtendableMgResponse<Model.LogParty, Search> buildResponse(ResponseStatus status, String rawResponse, List<dynamic> jsonData) {
    if (0 == jsonData.length || 0 == jsonData[0]['count']) {
      print('Warning: No results returned for $this');
      return ExtendableMgResponse<Model.LogParty, Search>(
        this,
        status,
        rawResponse,
        [],
        false,
        (request, data) => Search.fetchMore(request, data),
      );
    }

    // copy previousResults
    List<Model.LogParty> logs = previousResults.sublist(0);

    int totalCount = jsonData[0]['count'];
    jsonData = jsonData[1];

    // parse party batches
    String logId = jsonData[0]['logId'];
    List<Map<String, dynamic>> entries = [jsonData[0]];

    Function append;

    if (boss == null) {
      append = (e) => logs.add(Model.LogParty.fromJson(e));
    } else {
      append = (e) => logs.add(Model.LogParty.fromJsonAndBoss(boss, e));
    }

    for (int i = 1; i < jsonData.length; i++) {
      Map<String, dynamic> entry = jsonData[i];

      if (logId != entry['logId']) {
        append(entries);
        logId = entry['logId'];
        entries = [];
      }

      entries.add(jsonData[i]);
    }

    // append last batch
    if (0 < entries.length) {
      append(entries);
    }

    return ExtendableMgResponse<Model.LogParty, Search>(
      this,
      status,
      rawResponse,
      logs,
      logs.length < totalCount,
      (request, data) => Search.fetchMore(request, data)
    );
  }
}
