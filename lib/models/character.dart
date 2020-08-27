///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';

/// MG api player data wrapper
class Character {

  final int id;
  final String name, clazz;
  final String server, guild;
  final Color color;
  final String flair;

  Character(this.id, this.name, this.clazz, this.server, this.guild, this.color, this.flair);

  factory Character.fromJson(Map<String, dynamic> json) {
    // Todo: move somewhere accessible
    Color color;
    if (json['color'] != null) {
      final String hexString = 'FF' + json['color'].replaceFirst('#', '');
      color = Color(int.parse(hexString, radix: 16));
    }
    return Character(
        json['playerId'],
        json['playerName'],
        json['playerClass'],
        json['playerServer'],
        json['guild'],
        color,
        json['flair'],
    );
  }
}