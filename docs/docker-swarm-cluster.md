# Docker Swarm Cluster

## Overview

This document describes the deployment of a three-node Docker Swarm cluster using Vagrant, Ubuntu 24.04, Ansible, and Docker.

The infrastructure consists of one Manager node and two Worker nodes.

## Infrastructure

| Node | Role | IP Address |
|---|---|---|
| swarm-manager | Manager | 192.168.186.10 |
| swarm-worker1 | Worker | 192.168.186.11 |
| swarm-worker2 | Worker | 192.168.186.12 |

Each virtual machine uses:

- Ubuntu 24.04
- 1 CPU
- 1024 MB RAM
- Docker Engine

## 1. Initialize Docker Swarm

Run the following command on the Manager node:

    sudo docker swarm init --advertise-addr 192.168.186.10

This initializes the Swarm cluster and makes the Manager node the Leader.

## 2. Join Worker Nodes

Generate a Worker join command on the Manager:

    sudo docker swarm join-token worker

Run the generated join command on both Worker nodes.

Do not store or commit the actual join token in the repository.

## 3. Verify Cluster Nodes

Run this command on the Manager:

    sudo docker node ls

Expected result:

- swarm-manager: Ready, Active, Leader
- swarm-worker1: Ready, Active
- swarm-worker2: Ready, Active

## 4. Deploy Nginx Service

Create an Nginx service with one replica:

    sudo docker service create \
      --name web \
      --replicas 1 \
      --publish published=8080,target=80 \
      nginx:alpine

This creates an Nginx service and exposes it on port 8080.

## 5. Check the Service

Check the service status:

    sudo docker service ls

Check the running tasks:

    sudo docker service ps web

## 6. Test HTTP Access

Run the following command on the Manager node:

    curl http://127.0.0.1:8080

The expected response is the default Nginx welcome HTML page.

## 7. Scale the Service

Increase the number of replicas to three:

    sudo docker service scale web=3

Verify the service:

    sudo docker service ls

Expected result:

    web   replicated   3/3

## 8. Verify Task Distribution

Run:

    sudo docker service ps web

The three Nginx tasks should be distributed across the Manager and Worker nodes.

## 9. Inspect the Service

Run:

    sudo docker service inspect web --pretty

Important configuration:

- Service Mode: Replicated
- Replicas: 3
- Endpoint Mode: VIP
- Published Port: 8080
- Target Port: 80
- Publish Mode: Ingress

## 10. Security Notes

- Never commit passwords, private keys, or Swarm join tokens.
- Rotate the Worker join token after joining the Worker nodes.
- Each VM should have its own unique SSH host keys.
- Keep sensitive infrastructure configuration outside the Git repository.

## Final Result

The Docker Swarm cluster is successfully running with:

- 1 Manager node
- 2 Worker nodes
- 3 Nginx replicas
- Docker Swarm routing mesh
- HTTP access through port 8080

The infrastructure is ready for the next stage: deploying applications using Docker Stack.