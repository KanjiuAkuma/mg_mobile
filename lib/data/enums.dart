///
/// Created by Kanjiu Akuma on 8/24/2020.
///
/// Enums for named parameters
///

class PlayerRole {
  static const int DPS = 1, HEALER = 2, TANK = 4;

  static int fromClass(String clazz) {
    if (Clazz.healers.containsKey(clazz)) {
      return HEALER;
    }
    else if (Clazz.tanks.containsKey(clazz)) {
      return TANK;
    }

    return DPS;
  }
}

class Span {

  static const Map<String, String> spans = {
    'Quarterly': 'q',
    'Monthly': 'm',
    'Weekly': 'w',
    'Daily': 'd',
  };

}

class Clazz {
  
  static const Map<String, int> healers = {
    'Mystic': 1,
    'Priest': 2,
  };
  
  static const Map<String, int> tanks = {
    'Lancer': 1,
    'Brawler (Tank)': 2,
    'Warrior (Tank)': 4,
  };
  
  static const List<String> clazzes = [
    'Archer',
    'Berserker',
    'Brawler (DPS)',
    'Brawler (Tank)',
    'Gunner',
    'Lancer',
    'Mystic',
    'Ninja',
    'Priest',
    'Reaper',
    'Slayer',
    'Sorcerer',
    'Valkyrie',
    'Warrior',
    'Warrior (Tank)',
  ];
}