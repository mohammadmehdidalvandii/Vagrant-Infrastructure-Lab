# Docker Stack Application Deployment

## Overview

In this section, we deploy a custom Nginx application across a three-node Docker Swarm cluster using Docker Stack.

The application is deployed with three replicas and is accessible through port `8080`.

## Project Structure

```text
Vagrant-Infrastructure-Lab/
├── app/
│   └── index.html
├── docker/
│   └── stack.yml
└── docs/
    └── docker-stack-deployment.md
```

## 1. Application Preparation

A custom HTML page was created at:

`app/index.html`

The page displays:

- Project name: Vagrant Infrastructure Lab
- Docker Swarm application information
- Infrastructure running status

The application uses inline CSS and does not require additional frontend dependencies.

## 2. Docker Stack Configuration

The deployment configuration was created at:

`docker/stack.yml`

```yaml
version: "3.8"

services:
  web:
    image: nginx:alpine

    ports:
      - "8080:80"

    configs:
      - source: web-content
        target: /usr/share/nginx/html/index.html

    deploy:
      replicas: 3

      restart_policy:
        condition: on-failure

configs:
  web-content:
    file: ../app/index.html
```

### Configuration Explanation

- `image`: Uses the lightweight Nginx Alpine image.
- `ports`: Publishes port 8080 and forwards traffic to container port 80.
- `configs`: Distributes the custom HTML file to the service containers.
- `replicas`: Runs three application replicas.
- `restart_policy`: Restarts containers when they fail.

### Why Docker Configs?

Docker Configs were used instead of bind mounts.

The HTML file only needs to exist on the Manager when deploying the stack. Docker Swarm distributes the configuration to the nodes running the service.

This avoids manually copying the application file to every Worker.

## 3. Transfer Files to Manager

The application and Docker configuration files were transferred from the host machine to the Manager node.

```bash
scp -P 2222 \
-i "D:/Vagrant-Infrastructure-Lab/.vagrant/machines/swarm-manager/vmware_desktop/private_key" \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-r app docker vagrant@127.0.0.1:/home/vagrant/
```

Files were placed in:

```text
/home/vagrant/app/
/home/vagrant/docker/
```

## 4. Validate Stack Configuration

Before deployment, the configuration was validated:

```bash
docker stack config -c ~/docker/stack.yml
```

The command completed successfully and displayed the resolved stack configuration.

## 5. Deploy the Application

The previous test service using port 8080 was removed:

```bash
sudo docker service rm web
```

The application was deployed using:

```bash
sudo docker stack deploy -c ~/docker/stack.yml infrastructure
```

The stack name is:

`infrastructure`

The resulting service name is:

`infrastructure_web`

## 6. Verify Deployment

### Check Stack

```bash
sudo docker stack ls
```

Expected stack:

```text
NAME             SERVICES
infrastructure   1
```

### Check Services

```bash
sudo docker stack services infrastructure
```

Verified deployment:

```text
NAME                 MODE         REPLICAS   IMAGE
infrastructure_web   replicated   3/3        nginx:alpine
```

### Check Running Tasks

```bash
sudo docker stack ps infrastructure
```

All three tasks reached the Running state and were distributed across the cluster:

| Task | Node |
|---|---|
| infrastructure_web.1 | swarm-worker1 |
| infrastructure_web.2 | swarm-worker2 |
| infrastructure_web.3 | swarm-manager |

## 7. HTTP Connectivity Tests

The application was tested through all three node IP addresses.

| Node | Address | Result |
|---|---|---|
| Manager | `192.168.186.10:8080` | Successful |
| Worker 1 | `192.168.186.11:8080` | Successful |
| Worker 2 | `192.168.186.12:8080` | Successful |

The application was also accessed from the Windows host machine.

All tests returned the custom HTML page successfully.

## 8. Docker Swarm Routing Mesh

The service publishes port `8080` using Docker Swarm's ingress routing mesh.

This means requests can be sent to the published port on any Swarm node.

Swarm routes incoming traffic to an available service task, even if that task is running on another node.

This provides a common entry point for accessing the application across the cluster.

## 9. Final Result

The application was successfully deployed using Docker Stack.

Final deployment status:

- Three-node Docker Swarm cluster operational.
- One Docker Stack deployed.
- One Nginx service running.
- Three replicas running successfully.
- Application distributed across all three nodes.
- HTTP access verified from every node.
- HTTP access verified from the Windows host.

## Conclusion

This deployment demonstrates how Docker Stack can be used to deploy and manage a containerized application across a Docker Swarm cluster.

It also demonstrates Docker Configs, service replication, ingress routing, and application verification.

The infrastructure is now ready for the next stage of the project.