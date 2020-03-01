#!/bin/bash

readonly SCRIPT_DIR="$(cd "$(dirname "${0}")" && pwd)"

ansible-galaxy install -r "${SCRIPT_DIR}/requirements.yml"

