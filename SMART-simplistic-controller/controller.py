import sys
import json
import random

def modify_signals(json_input):
    data = json.loads(json_input)

    if "signals" in data and isinstance(data["signals"], list):
        data["signals"] = [value * random.uniform(0.95, 1.05) for value in data["signals"]]

    return json.dumps(data, indent=2)

if __name__ == "__main__":
    input_json = sys.stdin.read().strip()
    if not input_json:
        print("Error: No input received", file=sys.stderr)
        sys.exit(1)

    output_json = modify_signals(input_json)
    print(output_json)