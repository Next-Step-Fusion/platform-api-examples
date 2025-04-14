import json
import requests

API_URL = 'https://api.fusiontwin.io'
API_KEY = ''
WORKSPACE_ID = ''

TWIN_KEY = 'isttok2024'
SIMULATOR_KEY = 'NSFS'

def find_suite(suites: list, twin_key: str, simulator_key: str) -> dict:
    return next(filter(
        lambda s: s['digital_twin']['key'] == twin_key and
                  s['simulator']['key'] == simulator_key and
                  s['available'] is True,
        suites))

def main():
    rsp = requests.get(f'{API_URL}/dicts/simulation_suites/', headers={'X-Api-Key': API_KEY})
    suites = rsp.json()

    # Find the suite that matches the tokamak digital replica (twin) and simulator
    suite = find_suite(suites, TWIN_KEY, SIMULATOR_KEY)

    with open('init.json') as f:
        init_json = json.load(f)

    rsp = requests.post(f'{API_URL}/workspaces/{WORKSPACE_ID}/simulations/init/',
                        headers={'X-Api-Key': API_KEY},
                        json={
                            'digital_twin': suite['digital_twin']['id'],
                            'simulator': suite['simulator']['id'],
                            'type': suite['simulation_type']['id'],
                            'preset': suite['preset']['id'],
                            'input': init_json,
                        },
                        # Do not save the simulation to the workspace
                        params={'save': False})

    simulation_id = rsp.json()['id']

    # Read steps_num from init.json if it is present, otherwise make only 1 step
    steps_num = init_json.get('steps_num', 1)

    step_json = init_json['steps'][0]

    rsp = requests.post(f'{API_URL}/workspaces/{WORKSPACE_ID}/simulations/step/{simulation_id}/',
                            headers={'X-Api-Key': API_KEY},
                            json=step_json)

    if rsp.ok:
        print(rsp.json())
    else:
        print(f'Simulation failed, step={i}, rsp={rsp.json()}')

main()
