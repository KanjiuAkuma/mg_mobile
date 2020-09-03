///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../base/mg_request.dart';
import 'package:mg/models/models.dart' as Model;

final String _endpoint = 'search';

class Search extends MgRequest<Model.LogParty> {
  final Model.Boss boss;
  final String region, characterName, server;
  final bool searchForGuild, sortByDps;
  final int page;
  final List<Model.LogParty> previousResults;
  bool hasMore;

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
    assert(previous.hasMore ?? false, 'Attempting to load more entries but there are none.');
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
  List<Model.LogParty> parseResponseJson(List<dynamic> responseJson) {
    if (0 == responseJson.length || 0 == responseJson[0]['count']) {
      print('Warning: No results returned for $this');
      hasMore = false;
      return [];
    }

    List<Model.LogParty> logs = previousResults;

    int totalCount = responseJson[0]['count'];
    responseJson = responseJson[1];

    // parse party batches
    String logId = responseJson[0]['logId'];
    List<Map<String, dynamic>> entries = [responseJson[0]];

    Function append;

    if (boss == null) {
      append = (e) => logs.add(Model.LogParty.fromJson(e));
    } else {
      append = (e) => logs.add(Model.LogParty.fromJsonAndBoss(boss, e));
    }

    for (int i = 1; i < responseJson.length; i++) {
      Map<String, dynamic> entry = responseJson[i];

      if (logId != entry['logId']) {
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

    hasMore = logs.length < totalCount;
    return logs;
  }
}
