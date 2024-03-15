# Copyright (C) 2024 Max Bareiss

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
import requests_futures
import requests_futures.sessions
from concurrent.futures import as_completed
from tqdm import tqdm
import os

if __name__ == '__main__':
    headers = {'X-TBA-Auth-Key':os.environ['TBA_KEY'],
               'accept': 'application/json'}
    session = requests_futures.sessions.FuturesSession()
    res = list()
    events = list()
    with open('tidy_2_events.csv','r') as file:
        for event in tqdm(file):
            event = event.strip()
            # print(event)
            resp = session.get('https://www.thebluealliance.com/api/v3/event/{}/oprs'.format(event), headers=headers, timeout=30)
            res.append(resp)
            events.append(event)
            #print(event,',',resp.json()['start_date'])
            # quit()
    with open('opr_1_download.csv','w') as outfile:
        outfile.write("year_event,team_number,opr,dpr\n")
        for future in tqdm(as_completed(res)):
            resp = future.result()
            event = resp.url.split('/')[-2]
            tqdm.write(event)
            resp = resp.json()
            #.json()
            try:
                oprs = resp['oprs']
                dprs = resp['dprs']
                for key in oprs:
                    outfile.write("{},{},{},{}\n".format(event,key,oprs[key],dprs[key]))
                #print(event,',',resp.json()['start_date'])
            except:
                continue