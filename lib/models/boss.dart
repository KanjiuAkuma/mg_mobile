///
/// Created by Kanjiu Akuma on 8/22/2020.
///

/// MG api boss data wrapper
class Boss {
  final int zoneId, bossId, version;

  Boss(this.zoneId, this.bossId, this.version);

  factory Boss.fromJson(Map<String, dynamic> json) {
    return Boss(
        json['zoneId'],
        json['bossId'],
        json['version'],
    );
  }
}