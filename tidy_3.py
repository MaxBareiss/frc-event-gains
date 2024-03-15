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
            resp = session.get('https://www.thebluealliance.com/api/v3/event/{}'.format(event), headers=headers, timeout=30)
            res.append(resp)
            events.append(event)
            #print(event,',',resp.json()['start_date'])
            # quit()
    with open('tidy_3_dates.csv','w') as outfile:
        outfile.write('year_event,date\n')
        for future in tqdm(as_completed(res)):
            resp = future.result().json()
            try:
                event = resp['key']
                outfile.write("{},{}\n".format(event,resp['start_date']))
            except:
                continue