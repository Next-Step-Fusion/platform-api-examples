import json
import requests
import subprocess

BACKEND_URL = 'https://api.fusiontwin.io'

API_KEY = ''
WORKSPACE_ID = ''

TWIN_KEY = 'smart2024'
SIMULATOR_KEY = 'NSFS'

def find_suite(suites: list, twin_key: str, simulator_key: str) -> dict:
    return next(filter(
        lambda s: s['digital_twin']['key'] == twin_key and
                  s['simulator']['key'] == simulator_key and
                  s['available'] is True,
        suites))

def call_controller_script(step_json: dict) -> dict:
    """Calls external Python script `controller.py` with step_json as input and returns modified JSON."""
    try:
        process = subprocess.run(
            ["python3", "controller.py"],  # Properly calling the script
            input=json.dumps(step_json),   # Pass JSON as stdin
            capture_output=True, 
            text=True,
            check=True
        )
        return json.loads(process.stdout.strip())  # Parse and return modified JSON
    except subprocess.CalledProcessError as e:
        print(f"Error calling controller.py: {e}")
        return step_json  # Return the original step_json in case of failure

def main():
    rsp = requests.get(f'{BACKEND_URL}/dicts/simulation_suites/', headers={'X-Api-Key': API_KEY})
    suites = rsp.json()

    # Find the suite that matches the tokamak digital replica (twin) and simulator
    suite = find_suite(suites, TWIN_KEY, SIMULATOR_KEY)

    with open('init.json') as f:
        init_json = json.load(f)

    rsp = requests.post(f'{BACKEND_URL}/workspaces/{WORKSPACE_ID}/simulations/init/',
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

    with open('step.json') as f:
        step_json = json.load(f)

    for i in range(steps_num):
        step_json['step'] = i

        # Call external script to modify step_json
        step_json = call_controller_script(step_json)

        rsp = requests.post(f'{BACKEND_URL}/workspaces/{WORKSPACE_ID}/simulations/step/{simulation_id}/',
                            headers={'X-Api-Key': API_KEY},
                            json=step_json)

        if rsp.ok:
            print(rsp.json())
        else:
            print(f'Simulation failed, step={i}, rsp={rsp.json()}')
            break

main()