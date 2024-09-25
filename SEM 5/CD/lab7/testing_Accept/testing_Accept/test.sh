#!/bin/bash

# Check if the required commands are available
for cmd in unzip make; do
  if ! command -v $cmd &> /dev/null; then
    echo "$cmd could not be found, please install it first."
    exit 1
  fi
done

# Define variables
ZIP_PATTERN="CS[0-9][0-9]B[0-9][0-9][0-9].zip"
INPUT_DIR="./inputs"
OUTPUT_DIR="./outputs"
REFERENCE_DIR="./ref_outputs" 
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# Ensure the input directory exists
if [ ! -d "$INPUT_DIR" ]; then
  echo "Input directory '$INPUT_DIR' does not exist."
  exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Find and process the zip file
for ZIP_FILE in $ZIP_PATTERN; do
  if [ ! -f "$ZIP_FILE" ]; then
    echo "No zip file matching pattern '$ZIP_PATTERN' found."
    exit 1
  fi

  # Unzip the file in the current directory
  unzip "$ZIP_FILE" 

  # Extract the directory name from the zip file
  DIR_NAME=$(basename "$ZIP_FILE" .zip)
  if [ ! -d "$DIR_NAME" ]; then
    echo "Directory '$DIR_NAME' not found after unzipping."
    exit 1
  fi

  # Move files out of the extracted directory to the base directory
  mv ./$DIR_NAME/* ./



  # Run make to build the executable
  if ! make; then
    echo "Failed to build the executable using 'make'."
    exit 1
  fi

  # Ensure the executable exists
  if [ ! -f "a.out" ]; then
    echo "Executable 'a.out' not found."
    exit 1
  fi

  # Run a.out with each input file and store the output
  for i in {1..24}; do
    INPUT_FILE="$INPUT_DIR/inp$i.txt"
    OUTPUT_FILE="$OUTPUT_DIR/out$i.txt"
    
    if [ ! -f "$INPUT_FILE" ]; then
      echo "Input file '$INPUT_FILE' does not exist."
      continue
    fi
    
    ./a.out < "$INPUT_FILE" > "$OUTPUT_FILE" 2>&1
  done
 
 for i in {1..24}; do
    OUTPUT_FILE="$OUTPUT_DIR/out$i.txt"
    REFERENCE_FILE="$REFERENCE_DIR/out$i.txt"
    
    if [ ! -f "$REFERENCE_FILE" ]; then
      echo "Reference file '$REFERENCE_FILE' does not exist."
      continue
    fi
    
    if diff -r -w "$OUTPUT_FILE" "$REFERENCE_FILE" > /dev/null; then
      echo -e "${GREEN}File '$OUTPUT_FILE' matches '$REFERENCE_FILE': Same${RESET}"
    else
      echo -e "${RED}File '$OUTPUT_FILE' differs from '$REFERENCE_FILE': Different${RESET}"
    fi
  done
  # Clean up by removing all files in the base directory (except the remaining input and output files)
  # find . -maxdepth 1 ! -name "$(basename "$ZIP_FILE")" ! -name "testcases" ! -name "output" -exec rm -rf {} +
  echo "Cleaning up..."
  rm -f l7.y l7.l l7.tab.c l7.tab.h lex.yy.c Makefile a.out
  rm -rf "$DIR_NAME"
done

