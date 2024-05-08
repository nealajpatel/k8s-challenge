#!/bin/bash

# List of required CLI tools
required_tools=("terraform" "docker" "kubectl")

# Check if each tool is installed
for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "$tool is not installed. Please install it."
        exit 1
    fi
done

echo "All required tools are installed."
