"""
Created by Joscha Vack on 8/27/2020.
"""

import bs4
import requests
import json


input_path = '../TeraDpsMeterData/monsters/monsters-EU-EN.xml'
output_paths = ['data/monsters.json', '../../assets/data/monsters.json']

if __name__ == '__main__':
    # get list of supported ids
    r = json.loads(requests.get('https://kabedon.moongourd.com/api/shinra/whitelist').content)
    with open(input_path) as i:
        soup = bs4.BeautifulSoup(i.read(), features='html.parser')
        monsters = {}
        for e in r:
            version = e['Ver']
            zone_id = e['AreaId']
            boss_ids = e['BossIds']
            # check for 'special bosses'
            zone_monsters = {}

            zone_xml = soup.find('zone', id=zone_id)
            # check for 'special areas'
            zone_name = zone_xml['name']

            zone_monsters.update(**{str(boss_id): zone_xml.find('monster', id=boss_id)['name'] for boss_id in boss_ids})

            monsters[zone_id] = {
                'version': version,
                'name': zone_name,
                'monsters': dict(sorted(zone_monsters.items())),
            }

        print('Monsters:')
        print(monsters)

        for p in output_paths:
            with open(p, 'w') as o:
                json.dump(monsters, o)


