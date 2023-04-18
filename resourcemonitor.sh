#!/bin/bash

# Default values
PID=""
INTERVAL=1
FILENAME="data.csv"

# Parse command line arguments
while getopts ":p:i:f:" opt; do
  case ${opt} in
    p )
      PID=${OPTARG}
      ;;
    i )
      INTERVAL=${OPTARG}
      ;;
    f )
      FILENAME=${OPTARG}
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Option -$OPTARG requires an argument." 1>&2
      exit 1
      ;;
  esac
done

# Check if PID is provided
if [ -z "$PID" ]; then
  echo "Please provide a process ID using the -p option."
  exit 1
fi

# Log headers to file
echo "Time,Memory Usage (%),CPU Usage (%)" > "$FILENAME"

# Log CPU and RAM usage in a loop
while true; do
  # Get current time
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")

  # Get CPU usage by process
  cpu=$(ps -p $PID -o %cpu | tail -n 1)

  # Get RAM usage by process
  mem=$(ps -p $PID -o %mem | tail -n 1)

  # Write to file
  echo "$timestamp,$mem,$cpu" >> "$FILENAME"

  # Sleep for the specified interval
  sleep $INTERVAL
done
