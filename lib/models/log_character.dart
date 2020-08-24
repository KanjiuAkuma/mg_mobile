///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'character.dart';
import 'boss.dart';

/// MG api player log data wrapper
class LogCharacter {
  final String logId;
  final Boss boss;
  final int dps;
  final Character character;

  LogCharacter(this.logId, this.boss, this.dps, this.character);

  factory LogCharacter.fromJson(Map<String, dynamic> json) {
    return LogCharacter(
      json['logId'],
      Boss.fromJson(json),
      json['playerDps'],
      Character.fromJson(json),
    );
  }
}