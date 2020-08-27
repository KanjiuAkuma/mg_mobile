"""
Created by Joscha Vack on 8/27/2020.
"""

import bs4
import requests
import json


input_path = '../TeraDpsMeterData/monsters/monsters-EU-EN.xml'
output_path = 'data/monsters.json'

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
            if zone_id == 3034:  # rk9 hm
                boss_ids = [b_id for b_id in boss_ids if b_id != 4000]

            zoneXml = soup.find('zone', id=zone_id)
            zone_name = zoneXml['name']
            zone_monsters = {boss_id: zoneXml.find('monster', id=boss_id)['name'] for boss_id in boss_ids}

            # re add 'special' monsters
            if zone_id == 3034:  # rk9 hm
                zone_monsters[4000] = zone_monsters[3000] + '+'

            monsters[zone_id] = {
                'version': version,
                'name': zone_name,
                'monsters': zone_monsters,
            }
        with open(output_path, 'w') as o:
            json.dump(monsters, o)


