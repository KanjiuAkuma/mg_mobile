///
/// Created by Kanjiu Akuma on 8/22/2020.
///

/// MG api player data wrapper
class Character {

  final int id;
  final String name, clazz;
  final String server, guild;
  final String color, flair;

  Character(this.id, this.name, this.clazz, this.server, this.guild, this.color, this.flair);

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
        json['playerId'],
        json['playerName'],
        json['playerClass'],
        json['playerServer'],
        json['guild'],
        json['color'],
        json['flair'],
    );
  }
}