#!/usr/bin/env bash

# Stop the script if a command fails
set -e

# Find the main project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Define project folders
RAW_DIR="$PROJECT_DIR/raw"
RESULTS_DIR="$PROJECT_DIR/results"
FIGURES_DIR="$PROJECT_DIR/figures"
SCRIPTS_DIR="$PROJECT_DIR/scripts"

# Create folders if they do not exist
mkdir -p "$RAW_DIR"
mkdir -p "$RESULTS_DIR"
mkdir -p "$FIGURES_DIR"
mkdir -p "$SCRIPTS_DIR"

# Create an input summary
SUMMARY_FILE="$RESULTS_DIR/input_summary.txt"

{
    echo "CAPSTONE PROJECT INPUT SUMMARY"
    echo "================================"
    echo
    echo "Project directory:"
    echo "$PROJECT_DIR"
    echo
    echo "Input files:"
    ls -lh "$RAW_DIR"
    echo
    echo "Number of files:"
    find "$RAW_DIR" -maxdepth 1 -type f | wc -l
} > "$SUMMARY_FILE"

echo "Project setup completed."
echo "Input summary saved to:"
echo "$SUMMARY_FILE"
