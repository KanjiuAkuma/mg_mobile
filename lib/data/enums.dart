///
/// Created by Kanjiu Akuma on 8/24/2020.
///
/// Enums for named parameters
///

const int DPS = 1, HEALER = 2, TANK = 4;

int roleFromClass(String clazz) {
  if (healers.containsKey(clazz)) {
    return HEALER;
  } else if (tanks.containsKey(clazz)) {
    return TANK;
  }

  return DPS;
}

const Map<String, String> spans = {
  'Quarterly': 'q',
  'Monthly': 'm',
  'Weekly': 'w',
  'Daily': 'd',
};

const Map<String, int> healers = {
  'Mystic': 1,
  'Priest': 2,
};

const Map<String, int> tanks = {
  'Lancer': 1,
  'Brawler (Tank)': 2,
  'Warrior (Tank)': 4,
};

const List<String> clazzes = [
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

const Map<String, Map<String, dynamic>> regions = {
  'EU': {
    'name': 'Europe',
    'servers': [
      'Mystel',
      'Seren',
      'Shakan',
      'Shen',
      'Yurian',
    ]
  },
  'NA': {
    'name': 'North America',
    'servers': [
      'Kaiator',
      'Velika',
    ]
  },
  // 'KR': 'Korea',
  // 'JP': 'Japan',
  // 'TW': 'Taiwan',
};
