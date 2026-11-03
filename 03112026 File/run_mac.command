#!/bin/bash
# Double-click to start the proposal builder on a Mac.
# Keep this window open while you use the app. Errors are shown here.
cd "$(dirname "$0")"
fail() { echo; echo "The proposal builder could not start. The error is shown above."; read -p "Press Enter to close."; exit 1; }
command -v python3 >/dev/null || { echo "Python 3 was not found. Install it from https://www.python.org/downloads/"; fail; }
if [ ! -x .venv/bin/python ]; then
  echo "Setting up for the first time. This takes a few minutes..."
  rm -rf .venv; python3 -m venv .venv || fail
fi
# install again whenever requirements.txt changes (new versions of the app)
if ! cmp -s requirements.txt .venv/installed.txt; then
  ./.venv/bin/python -m pip install --upgrade pip
  ./.venv/bin/python -m pip install -r requirements.txt || fail
  cp requirements.txt .venv/installed.txt
fi
./.venv/bin/python app.py || fail
