///
/// Created by Kanjiu Akuma on 8/22/2020.
///

/// MG api boss data wrapper
class Boss {
  final int version;
  final String zoneId, bossId;

  Boss(this.version, this.zoneId, this.bossId);

  factory Boss.fromJson(Map<String, dynamic> json) {
    return Boss(
      json['version'],
      '${json['zoneId']}',
      '${json['bossId']}',
    );
  }

  @override
  String toString() {
    return 'Boss id=$bossId, zone=$zoneId, version=$version';
  }
}
