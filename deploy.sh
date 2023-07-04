#!/bin/bash

# Check if Flask is already running and kill the process if necessary
if pgrep -f "flask run" >/dev/null; then
  pkill -f "flask run"
fi

# Change to the Flask project directory
cd /flask

# Start Flask in the background and store the process ID
nohup flask run --host=0.0.0.0 >/dev/null 2>&1 &
FLASK_PID=$!

# Wait for Flask to start by checking if the server is running
TIMEOUT=30
INTERVAL=1
TIME_PASSED=0
SERVER_UP=false

while [[ "$TIME_PASSED" -lt "$TIMEOUT" ]]; do
  if curl -s http://localhost:5000 >/dev/null; then
    SERVER_UP=true
    break
  fi
  sleep "$INTERVAL"
  TIME_PASSED=$((TIME_PASSED + INTERVAL))
done

# Check if Flask started successfully
if "$SERVER_UP"; then
  echo "Flask application started successfully."
  exit 0
else
  echo "Flask application failed to start within the timeout."
  exit 1
fi
