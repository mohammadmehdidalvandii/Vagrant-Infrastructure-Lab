#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./scale.sh <number-of-replicas>"
    exit 1
fi

if ! [[ "$1" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Please enter a positive integer."
    exit 1
fi

REPLICAS=$1
SERVICE="infrastructure_web"

echo "Scaling $SERVICE to $REPLICAS replicas..."

sudo docker service scale "$SERVICE=$REPLICAS"

echo "Scaling command completed."
