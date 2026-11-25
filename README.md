# Vagrant Infrastructure Lab

## Project Description

Vagrant Infrastructure Lab is a DevOps project designed to build and manage a three-node infrastructure using Vagrant, VMware, Ansible, and Docker Swarm.

The project automates the provisioning of three Ubuntu 24.04 virtual machines, installs Docker across all nodes using Ansible, and configures a Docker Swarm cluster with one Manager and two Worker nodes.

A custom HTML application is deployed using Docker Stack and served through Nginx with three replicas.

**Technologies:**
- Vagrant
- VMware Workstation
- Ubuntu 24.04
- Ansible
- Docker
- Docker Swarm
- Docker Stack
- Nginx
- Bash

**Infrastructure:**

| Node | Role | IP Address |
|---|---|---|
| swarm-manager | Manager | 192.168.186.10 |
| swarm-worker1 | Worker | 192.168.186.11 |
| swarm-worker2 | Worker | 192.168.186.12 |

## How to Run

### 1. Prerequisites

Install the following tools:

- VMware Workstation
- Vagrant 2.4.9
- Vagrant VMware Desktop Plugin
- Vagrant VMware Utility
- Git

Install the VMware plugin:

```bash
vagrant plugin install vagrant-vmware-desktop
```

### 2. Clone the Repository

```bash
git clone https://github.com/mohammadmehdidalvandii/Vagrant-Infrastructure-Lab.git

cd Vagrant-Infrastructure-Lab
```

### 3. Start Virtual Machines

```bash
vagrant up
```

### 4. Connect to the Manager

```bash
vagrant ssh swarm-manager
```

### 5. Configure Ansible

Copy the Ansible directory to the Manager from the host machine:

```bash
scp -r ansible vagrant@192.168.186.10:/home/vagrant/
```

On the Manager:

```bash
cd ~/ansible
```

Verify connectivity:

```bash
ansible all -i inventory.ini -m ping
```

Update package indexes:

```bash
ansible-playbook -i inventory.ini update.yml
```

Install Docker on all nodes:

```bash
ansible-playbook -i inventory.ini docker.yml
```

### 6. Initialize Docker Swarm

On the Manager:

```bash
sudo docker swarm init --advertise-addr 192.168.186.10
```

Retrieve the Worker join command:

```bash
sudo docker swarm join-token worker
```

Execute the generated join command on both Worker nodes.

Verify the cluster:

```bash
sudo docker node ls
```

### 7. Deploy the Application

From the host machine, copy the application and Docker configuration:

```bash
scp -r app docker vagrant@192.168.186.10:/home/vagrant/
```

On the Manager:

```bash
sudo docker stack deploy -c ~/docker/stack.yml infrastructure
```

Verify deployment:

```bash
sudo docker stack services infrastructure
```

### 8. Access the Application

Open the application in your browser:

```text
http://192.168.186.10:8080
```

### 9. Operational Scripts

Copy scripts to the Manager from the host machine:

```bash
scp -r scripts vagrant@192.168.186.10:/home/vagrant/
```

On the Manager:

```bash
chmod +x ~/scripts/*.sh
```

Check infrastructure status:

```bash
~/scripts/status.sh
```

Scale the application:

```bash
~/scripts/scale.sh 5
```

Check application health:

```bash
~/scripts/health.sh
```

### 10. Stop Infrastructure

Stop all virtual machines:

```bash
vagrant halt
```

Remove all virtual machines:

```bash
vagrant destroy -f
```

---

**Author:** [Mohammad Mehdi Dalvandi](https://github.com/mohammadmehdidalvandii)

**Repository:** [Vagrant Infrastructure Lab](https://github.com/mohammadmehdidalvandii/Vagrant-Infrastructure-Lab)