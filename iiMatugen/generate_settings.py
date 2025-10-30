import json
import os
import sys
import shutil

# --- Path Definitions ---
script_dir = os.path.dirname(os.path.abspath(__file__))
DEST_CONFIG_PATH = os.path.join(script_dir, "config.json")
OUTPUT_PATH = os.path.join(script_dir, "Settings.qml")

# --- Modify here for SOURCE_CONFIG_PATH portability using $HOME ---
# Get the user's home directory. os.path.expanduser('~') is the most robust and cross-platform way.
# Alternatively, you could use os.environ.get('HOME') but expanduser handles Windows and other shells better.
home_dir = os.path.expanduser('~')

# Construct the source config file path based on the home directory
SOURCE_CONFIG_PATH = os.path.join(home_dir, ".config", "illogical-impulse", "config.json")
# -------------------------------------------------------------------

# --- Functions (remain unchanged) ---
def flatten_dict(d, parent_key='', sep='_'):
    """Flattens a nested dictionary."""
    items = []
    for k, v in d.items():
        new_key = f"{parent_key}{sep}{k}" if parent_key else k
        if isinstance(v, dict):
            items.extend(flatten_dict(v, new_key, sep=sep).items())
        elif isinstance(v, list):
            items.append((new_key, json.dumps(v, separators=(',', ':'))))
        else:
            items.append((new_key, v))
    return dict(items)

def qml_value(val):
    """Converts a Python value to a valid QML representation."""
    if isinstance(val, str):
        s = val.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
        return f'"{s}"'
    elif isinstance(val, bool):
        return "true" if val else "false"
    elif isinstance(val, (int, float)):
        return str(val)
    elif val is None:
        return "null"
    else:
        return qml_value(str(val))

def qml_type(val):
    """Determines the most appropriate QML type."""
    if isinstance(val, str):
        return "string"
    elif isinstance(val, bool):
        return "bool"
    elif isinstance(val, int):
        return "int"
    elif isinstance(val, float):
        return "real"
    else:
        return "var"

# --- Debug logging for paths ---
print(f"Script directory: {script_dir}")
print(f"Source config path: {SOURCE_CONFIG_PATH}")
print(f"Destination config path: {DEST_CONFIG_PATH}")
print(f"QML output path: {OUTPUT_PATH}")

# --- Copy operation ---
print(f"Attempting to copy {SOURCE_CONFIG_PATH} to {DEST_CONFIG_PATH}...")
if not os.path.exists(SOURCE_CONFIG_PATH):
    print(f"❌ Error: Source file not found at {SOURCE_CONFIG_PATH}. Cannot copy.")
    sys.exit(1)

os.makedirs(os.path.dirname(DEST_CONFIG_PATH), exist_ok=True)

try:
    shutil.copy2(SOURCE_CONFIG_PATH, DEST_CONFIG_PATH)
    print(f"✅ File successfully copied from {SOURCE_CONFIG_PATH} to {DEST_CONFIG_PATH}")
except Exception as e:
    print(f"❌ Error copying file: {e}")
    sys.exit(1)

# --- Proceed with reading and generation (using DEST_CONFIG_PATH) ---
if not os.path.exists(DEST_CONFIG_PATH):
    print(f"❌ Error: {DEST_CONFIG_PATH} not found after copy.")
    sys.exit(1)

with open(DEST_CONFIG_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

flat = flatten_dict(data)

with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
    f.write("""pragma Singleton
import QtQuick
QtObject {
""")
    for key, value in sorted(flat.items()):
        safe_key = key.replace("-", "_").replace(".", "_").replace("/", "_")
        prop_type = qml_type(value)
        prop_value = qml_value(value)
        f.write(f"    property {prop_type} {safe_key}: {prop_value}\n")
    f.write("}\n")
print(f"✅ {OUTPUT_PATH} generated with {len(flat)} properties.")