#!/usr/bin/env python3
import json
import shutil
import sys
import re
from pathlib import Path
from typing import Any, Dict, Tuple

# --- Configuration ---
PROJECT_NAME = "illogical-impulse"
SOURCE_CONFIG = Path.home() / ".config" / PROJECT_NAME / "config.json"
SCRIPT_DIR = Path(__file__).parent.resolve()
LOCAL_CONFIG = SCRIPT_DIR / "config.json"
OUTPUT_QML = SCRIPT_DIR / "Settings.qml"


def flatten_dict(d: Dict[str, Any], parent_key: str = '', sep: str = '_') -> Dict[str, Any]:
    """
    Recursively flattens a nested dictionary into a single-level dictionary.
    """
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


def sanitise_identifier(key: str) -> str:
    """
    Ensures the key is a valid QML/JS identifier.
    1. Replaces any non-alphanumeric character with an underscore.
    2. Prepends an underscore if the key starts with a digit.
    """
    # Replace all non-alphanumeric chars (except underscore) with '_'
    clean_key = re.sub(r'[^a-zA-Z0-9_]', '_', key)
    
    # QML identifiers cannot start with a digit
    if clean_key and clean_key[0].isdigit():
        clean_key = f"_{clean_key}"
        
    return clean_key


def get_qml_type(val: Any) -> str:
    """
    Maps Python types to QML property types.
    """
    if isinstance(val, bool):
        return "bool"
    if isinstance(val, int):
        return "int"
    if isinstance(val, float):
        return "real"
    if isinstance(val, str):
        return "string"
    return "var"


def format_qml_value(val: Any) -> str:
    """
    Formats Python values into QML-compliant strings.
    """
    if isinstance(val, bool):
        return "true" if val else "false"
    if isinstance(val, str):
        # Escape backslashes, quotes, and newlines
        safe_str = val.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
        return f'"{safe_str}"'
    if val is None:
        return "null"
    return str(val)


def generate_qml_content(data: Dict[str, Any]) -> Tuple[str, int]:
    """
    Builds the Settings.qml file content.
    Returns a tuple containing the formatted string and the total property count.
    """
    flat_data = flatten_dict(data)
    
    lines = [
        "pragma Singleton",
        "import QtQuick",
        "",
        "QtObject {"
    ]

    for key in sorted(flat_data.keys()):
        val = flat_data[key]
        safe_key = sanitise_identifier(key)
        prop_type = get_qml_type(val)
        prop_val = format_qml_value(val)
        lines.append(f"    property {prop_type} {safe_key}: {prop_val}")

    lines.append("}\n")
    return "\n".join(lines), len(flat_data)


def main() -> None:
    """
    Main execution flow.
    """
    # 1. Source verification
    if not SOURCE_CONFIG.exists():
        print(f"ERROR: Source configuration not found: {SOURCE_CONFIG}", file=sys.stderr)
        sys.exit(1)

    # 2. Synchronize local config
    try:
        shutil.copy2(SOURCE_CONFIG, LOCAL_CONFIG)
    except OSError as e:
        print(f"ERROR: Failed to copy config: {e}", file=sys.stderr)
        sys.exit(1)

    # 3. Process Data
    try:
        with LOCAL_CONFIG.open("r", encoding="utf-8") as f:
            config_data = json.load(f)
    except (json.JSONDecodeError, OSError) as e:
        print(f"ERROR: Failed to parse JSON: {e}", file=sys.stderr)
        sys.exit(1)

    # 4. Generate and write QML
    qml_content, property_count = generate_qml_content(config_data)
    
    try:
        OUTPUT_QML.write_text(qml_content, encoding="utf-8")
    except OSError as e:
        print(f"ERROR: Failed to write output: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()