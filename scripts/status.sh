#!/bin/bash

echo "===================================="
echo "       DOCKER SWARM STATUS"
echo "===================================="

echo ""
echo "[1] SWARM NODES"
sudo docker node ls

echo ""
echo "[2] STACKS"
sudo docker stack ls

echo ""
echo "[3] SERVICES"
sudo docker service ls

echo ""
echo "===================================="
echo "       STATUS CHECK COMPLETED"
echo "===================================="
