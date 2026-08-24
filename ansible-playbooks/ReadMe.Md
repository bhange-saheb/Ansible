# Ansible DevOps Automation & Infrastructure

![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?style=for-the-badge\&logo=ansible\&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge\&logo=terraform\&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge\&logo=amazonaws\&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Administration-FCC624?style=for-the-badge\&logo=linux\&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge\&logo=docker\&logoColor=white)

A practical **DevOps automation and infrastructure-as-code project** focused on learning and implementing Ansible for server automation, configuration management, application deployment, cloud infrastructure, and operational tasks.

This repository contains hands-on examples covering **Ansible Ad-Hoc commands, Playbooks, Variables, Facts, Conditionals, Loops, Handlers, Templates, Roles, Ansible Vault, Dynamic Inventory, AWX, Docker Swarm**, and **Terraform-based AWS infrastructure**.

---

---

# 🛠️ Technologies & Tools

| Technology          | Purpose                               |
| ------------------- | ------------------------------------- |
| 🔴 Ansible           | Configuration Management & Automation |
| 🏗️ Terraform         | Infrastructure as Code                |
| ☁️ AWS               | Cloud Infrastructure                  |
| 🐧 Linux             | Server Administration                 |
| 🐳 Docker            | Containerization                      |
| 🌿 Git               | Version Control                       |
| 🔐 Ansible Vault     | Secrets Management                    |
| 🌐 Jinja2            | Configuration Templates               |
| 🤖 AWX               | Ansible Automation Platform           |
| 🔄 Dynamic Inventory | Automated Host Discovery              |

---

# 📚 What This Project Covers

## 1. Ansible Ad-Hoc Commands

Examples of managing servers directly from the Ansible control node.

```bash
ansible -i invfile pvt -m ping
```

Check disk usage:

```bash
ansible -i invfile pvt -m shell -a "df -h"
```

Run commands with high verbosity:

```bash
ansible -i invfile server01:server02 \
  -m shell \
  -a "df -h" \
  -vvvv
```

Execute against all hosts except a particular server:

```bash
ansible -i invfile 'all:!server01' \
  -m shell \
  -a "df -h"
```

---

# 2. 📋 Ansible Facts

Gather detailed information about managed nodes:

```bash
ansible -i invfile all -m setup
```

Facts can be used to make playbooks dynamic and environment-aware.

---

# 3. 🔁 Loops & Iteration

Use `with_items` and loops to perform the same operation against multiple values.

Example:

```yaml
- name: Install packages
  ansible.builtin.apt:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - git
    - curl
```

---

# 4. 🔀 Conditional Execution

Run tasks only when a particular condition is satisfied.

```yaml
- name: Install package on Debian
  ansible.builtin.apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"
```

---

# 5. 📝 Register & Return Codes

Capture command output and return codes using `register`.

```yaml
- name: Check service
  ansible.builtin.shell:
    cmd: systemctl is-active nginx
  register: nginx_status
  changed_when: false

- name: Display status
  ansible.builtin.debug:
    var: nginx_status.rc
```

---

# 6. 📦 Copy & File Management

Manage files and directories remotely.

```yaml
- name: Create application directory
  ansible.builtin.file:
    path: /opt/myapp
    state: directory
    mode: "0755"
```

Copy files:

```yaml
- name: Copy configuration
  ansible.builtin.copy:
    src: nginx.conf
    dest: /etc/nginx/nginx.conf
```

---

# 7. 🔒 Ansible Vault

Protect sensitive information such as credentials and secrets.

Encrypt a file:

```bash
ansible-vault encrypt secrets.yml
```

Encrypt a single value:

```bash
ansible-vault encrypt_string
```

Run a playbook using Vault:

```bash
ansible-playbook -i invfile playbook.yml --ask-vault-pass
```

**Never commit passwords, private keys, API tokens, or cloud credentials to Git.**

---

# 8. 🧩 Roles & Ansible Galaxy

Organize automation into reusable roles.

Typical structure:

```text
roles/
└── nginx/
    ├── tasks/
    │   └── main.yml
    ├── handlers/
    │   └── main.yml
    ├── templates/
    ├── files/
    ├── vars/
    └── defaults/
        └── main.yml
```

Roles make large automation projects easier to maintain and reuse.

---

# 9. 🎨 Jinja2 Templates

Generate dynamic configuration files using Jinja2.

Example:

```jinja2
server {
    listen {{ nginx_port }};
    server_name {{ server_name }};
}
```

Templates can consume variables and Ansible facts to generate environment-specific configurations.

---

# 10. ⚙️ Handlers & Notifications

Handlers are useful when a service should restart only after a configuration change.

```yaml
- name: Update nginx configuration
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify:
    - Restart nginx
```

Handler:

```yaml
- name: Restart nginx
  ansible.builtin.service:
    name: nginx
    state: restarted
```

---

# 11. 🛡️ Error Handling

Use `block`, `rescue`, and `always` for controlled error handling.

```yaml
- block:

    - name: Execute deployment
      ansible.builtin.command:
        cmd: /opt/deploy.sh

  rescue:

    - name: Deployment failed
      ansible.builtin.debug:
        msg: "Deployment failed"

  always:

    - name: Deployment completed
      ansible.builtin.debug:
        msg: "Deployment process finished"
```

---

# 12. 👤 Become & Privilege Escalation

Run tasks with elevated privileges:

```bash
ansible-playbook -i invfile playbook.yml --become
```

Run a task as a specific user:

```yaml
- name: Run application as ansibleadmin
  become: true
  become_user: ansibleadmin
  ansible.builtin.command:
    cmd: whoami
```

---

# 13. 🔄 Serial Deployment

Control how many hosts are updated at the same time.

```yaml
- hosts: webservers
  serial: 1

  tasks:
    - name: Deploy application
      ansible.builtin.shell:
        cmd: /opt/deploy.sh
```

Using `serial: 1` allows hosts to be processed one at a time, which can help reduce deployment risk.

---

# 14. 🏷️ Tags

Run selected tasks without executing the entire playbook.

```yaml
- name: Install Nginx
  ansible.builtin.apt:
    name: nginx
    state: present
  tags:
    - nginx
```

Run:

```bash
ansible-playbook -i invfile site.yml --tags nginx
```

---

# 15. 📁 Fetch Files

Retrieve files from managed servers back to the Ansible control node.

```yaml
- name: Fetch application log
  ansible.builtin.fetch:
    src: /var/log/application.log
    dest: ./logs/
    flat: true
```

---

# 16. 🐳 Docker & Docker Swarm

The project also explores Docker Swarm configuration and automation.

Typical automation tasks include:

```text
Docker installation
       ↓
Docker configuration
       ↓
Swarm initialization
       ↓
Worker/Manager configuration
       ↓
Application deployment
```

---

# 17. 🌐 Dynamic Inventory

Dynamic inventory allows Ansible to discover infrastructure automatically rather than relying only on static host lists.

This is particularly useful for cloud environments where servers can be created and destroyed dynamically.

---

# 18. 🤖 AWX

The project also covers **AWX**, providing a graphical and centralized approach to running and managing Ansible automation.

Typical workflow:

```text
Git Repository
      ↓
     AWX
      ↓
Inventory
      ↓
Playbook
      ↓
Managed Servers
```

---

# ☁️ Terraform & AWS Infrastructure

The project also contains Terraform configuration for AWS infrastructure.

The Terraform configuration includes components such as:

```text
AWS Provider
     │
     ▼
    VPC
     │
 ┌───┴────┐
 ▼        ▼
Public   Private
Subnet   Subnet
 │        │
 ▼        ▼
Routing  Routing
 │
 ▼
 EC2
 │
 ▼
Security Groups
```

The repository includes Terraform configuration for:

* AWS Provider
* VPC
* Public Subnets
* Private Subnets
* Public Routing
* Private Routing
* EC2
* Security Groups
* VPC Peering
* Terraform Variables
* Terraform Outputs
* Local values
* Generated Ansible inventory
* Local execution

---

# Getting Started

## Prerequisites

Install:

* Linux
* Python 3
* Ansible
* Git
* SSH
* Terraform (for AWS infrastructure)

Verify Ansible:

```bash
ansible --version
```

Verify Terraform:

```bash
terraform version
```

---

# Clone the Repository

```bash
git clone https://github.com/bhange-saheb/Ansible.git
```

Move into the project:

```bash
cd Ansible
```

Go to the Ansible playbooks:

```bash
cd ansible-playbooks
```

---

# 🔑 Configure Inventory

Create or update your inventory:

```text
[webservers]
server01
server02

[dbservers]
server03

[all:vars]
ansible_user=ansibleadmin
```

Test connectivity:

```bash
ansible -i invfile all -m ping
```

Expected result:

```text
server01 | SUCCESS => {
    "ping": "pong"
}
```

---

# ▶️ Running a Playbook

```bash
ansible-playbook -i invfile playbook.yml
```

With privilege escalation:

```bash
ansible-playbook -i invfile playbook.yml --become
```

With a specific user:

```bash
ansible-playbook \
  -i invfile \
  playbook.yml \
  -u ansibleadmin
```

---

# 🔍 Debugging & Verbosity

Use verbose mode when troubleshooting:

```bash
ansible-playbook -i invfile playbook.yml -vvvv
```

Enable Ansible logging:

```bash
export ANSIBLE_LOG_PATH=~/ansible.log
```

Enable Ansible debug output:

```bash
export ANSIBLE_DEBUG=True
```

For execution-performance analysis, Ansible supports callback plugins such as `timer`, `profile_tasks`, and `profile_roles`.

---

# 🗂️ Project Structure

```text
Ansible/
│
├── ansible-playbooks/
│   │
│   ├── playbooks/
│   │
│   ├── 1.provider.tf
│   ├── 2.vpc.tf
│   ├── 3.public-subnets.tf
│   ├── 4.private-subnets.tf
│   ├── 5.public-routing.tf
│   ├── 6.private-routing.tf
│   ├── 7.ec2.tf
│   ├── 8.sg.tf
│   ├── 9.vpc-peering.tf
│   ├── 10.locals.tf
│   ├── 11.localfile_ansible_inventory.tf
│   ├── 12.localfile_ansible_inventory_yaml.tf
│   ├── 13.null-local-exec.tf
│   ├── 14.outputs.tf
│   ├── 15.terraform.tfvars
│   ├── 16.variables.tf
│   │
│   ├── publicservers.tpl
│   ├── publicservers_yaml.tpl
│   └── ReadMe.Md
│
└── README.md
```

The structure above reflects the files present in the referenced commit.

---

# Learning Objectives

This project is designed to build practical knowledge of:

* Infrastructure Automation
* Configuration Management
* Linux Administration
* Ansible Ad-Hoc Commands
* Ansible Playbooks
* Ansible Facts
* Variables
* Loops
* Conditionals
* Registers
* Error Handling
* Handlers
* Templates
* Roles
* Ansible Vault
* Privilege Escalation
* Tags
* Dynamic Inventory
* Docker Swarm
* AWX
* Terraform
* AWS Infrastructure
* Infrastructure as Code

---

# 🔐 Security Notes

Before using this project in production:

1. Do not commit AWS credentials.
2. Do not commit SSH private keys.
3. Do not commit passwords.
4. Use Ansible Vault for secrets.
5. Protect your Terraform state.
6. Use least-privilege IAM policies.
7. Restrict SSH access.
8. Review security-group rules before deploying.
9. Use separate inventories for development and production.

---

# 🌟 Future Improvements

Planned improvements can include:

* [ ] Add more Ansible roles
* [ ] Add Molecule testing
* [ ] Add Ansible Lint
* [ ] Add GitHub Actions CI
* [ ] Add Docker deployment playbooks
* [ ] Add Kubernetes automation
* [ ] Add AWS provisioning workflows
* [ ] Add monitoring automation
* [ ] Add centralized logging
* [ ] Add DevSecOps scanning
* [ ] Add production-ready inventory structure
* [ ] Add automated documentation

---

GitHub:
https://github.com/bhange-saheb

---

# ⭐ Support

If this project helps you learn **Ansible, DevOps, Infrastructure as Code, or AWS automation**, consider giving the repository a ⭐ on GitHub.


---

### DevOps Mindset

```text
Automate Everything
        ↓
Infrastructure as Code
        ↓
Repeatable Deployments
        ↓
Reliable Infrastructure
        ↓
Continuous Improvement
```

**Build → Automate → Deploy → Monitor → Improve**
