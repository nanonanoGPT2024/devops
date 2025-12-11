# Materi Pembelajaran: Ansible - Configuration Management

> **Level**: Intermediate  
> **Durasi**: 4-5 jam  
> **Prerequisites**: Linux, SSH basics

---

## 📚 Daftar Isi

1. [Configuration Management](#config-management)
2. [Ansible Fundamentals](#ansible-fundamentals)
3. [Playbooks](#playbooks)
4. [Roles](#roles)
5. [Best Practices](#best-practices)
6. [Real Examples](#examples)

---

## 1. Configuration Management

### Why Ansible?

**Ansible** = Automate server configuration & application deployment

**Benefits**:
- ✅ Agentless (SSH-based)
- ✅ Simple YAML syntax
- ✅ Idempotent (safe to run multiple times)
- ✅ Large module library

### Ansible vs Others

| Tool | Agent | Language | Use Case |
|------|-------|----------|----------|
| Ansible | No | YAML | Config management |
| Chef | Yes | Ruby | Enterprise config |
| Puppet | Yes | DSL | Enterprise config |
| SaltStack | Yes | YAML | Speed & scale |

---

## 2. Ansible Fundamentals

### Installation

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y ansible

# Using pip
pip3 install ansible

# Verify
ansible --version
```

### Inventory File

```ini
# inventory.ini
[webservers]
web1.example.com
web2.example.com

[databases]
db1.example.com

[production:children]
webservers
databases

[production:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

### Ad-Hoc Commands

```bash
# Ping all hosts
ansible all -i inventory.ini -m ping

# Check disk space
ansible webservers -i inventory.ini -a "df -h"

# Install package
ansible webservers -i inventory.ini -m apt -a "name=nginx state=present" --become

# Copy file
ansible all -i inventory.ini -m copy -a "src=/local/file dest=/remote/file"

# Restart service
ansible webservers -i inventory.ini -m service -a "name=nginx state=restarted" --become
```

---

## 3. Playbooks

### Basic Playbook

```yaml
# playbook.yml
---
- name: Setup web servers
  hosts: webservers
  become: yes
  
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
    
    - name: Install Nginx
      apt:
        name: nginx
        state: present
    
    - name: Start Nginx
      service:
        name: nginx
        state: started
        enabled: yes
    
    - name: Copy index.html
      copy:
        src: files/index.html
        dest: /var/www/html/index.html
      notify: Reload Nginx
  
  handlers:
    - name: Reload Nginx
      service:
        name: nginx
        state: reloaded
```

```bash
# Run playbook
ansible-playbook -i inventory.ini playbook.yml

# Check mode (dry run)
ansible-playbook -i inventory.ini playbook.yml --check

# Limit to specific hosts
ansible-playbook -i inventory.ini playbook.yml --limit web1.example.com
```

### Variables

```yaml
# With variables
---
- name: Deploy application
  hosts: webservers
  vars:
    app_name: myapp
    app_version: "1.0.0"
    app_port: 8080
  
  tasks:
    - name: Create app directory
      file:
        path: "/opt/{{ app_name }}"
        state: directory
    
    - name: Deploy application
      template:
        src: templates/app.conf.j2
        dest: "/opt/{{ app_name }}/config.conf"
```

### Templates (Jinja2)

```jinja2
{# templates/app.conf.j2 #}
app_name: {{ app_name }}
version: {{ app_version }}
port: {{ app_port }}
environment: {{ ansible_hostname }}

{% if ansible_distribution == "Ubuntu" %}
os: ubuntu
{% endif %}
```

### Loops

```yaml
- name: Install multiple packages
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - git
    - curl
    - vim

- name: Create multiple users
  user:
    name: "{{ item.name }}"
    groups: "{{ item.groups }}"
  loop:
    - { name: 'alice', groups: 'sudo' }
    - { name: 'bob', groups: 'developers' }
```

### Conditionals

```yaml
- name: Install Apache on Ubuntu
  apt:
    name: apache2
    state: present
  when: ansible_distribution == "Ubuntu"

- name: Install Apache on CentOS
  yum:
    name: httpd
    state: present
  when: ansible_distribution == "CentOS"
```

---

## 4. Roles

### Create Role Structure

```bash
ansible-galaxy init myrole
```

```
myrole/
├── defaults/       # Default variables
│   └── main.yml
├── files/          # Static files
│   └── index.html
├── handlers/       # Handlers
│   └── main.yml
├── meta/           # Role metadata
│   └── main.yml
├── tasks/          # Tasks
│   └── main.yml
├── templates/      # Jinja2 templates
│   └── config.j2
├── tests/          # Test playbooks
│   └── test.yml
└── vars/           # Variables
    └── main.yml
```

### Example Role

```yaml
# roles/nginx/tasks/main.yml
---
- name: Install Nginx
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Copy config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Reload Nginx

- name: Start Nginx
  service:
    name: nginx
    state: started
    enabled: yes

# roles/nginx/handlers/main.yml
---
- name: Reload Nginx
  service:
    name: nginx
    state: reloaded

# roles/nginx/defaults/main.yml
---
nginx_port: 80
nginx_user: www-data
```

### Use Role

```yaml
# site.yml
---
- name: Setup web servers
  hosts: webservers
  become: yes
  
  roles:
    - nginx
    - { role: app, app_version: "2.0" }
```

---

## 5. Best Practices

### Directory Structure

```
ansible-project/
├── inventory/
│   ├── production
│   └── staging
├── group_vars/
│   ├── all.yml
│   └── webservers.yml
├── host_vars/
│   └── web1.yml
├── roles/
│   ├── nginx/
│   └── app/
├── playbooks/
│   ├── site.yml
│   └── deploy.yml
├── ansible.cfg
└── requirements.yml
```

### ansible.cfg

```ini
[defaults]
inventory = ./inventory/production
remote_user = ubuntu
host_key_checking = False
retry_files_enabled = False
gathering = smart

[privilege_escalation]
become = True
become_method = sudo
become_user = root
```

### Vault for Secrets

```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Encrypt existing file
ansible-vault encrypt vars.yml

# Run playbook with vault
ansible-playbook site.yml --ask-vault-pass

# Use password file
ansible-playbook site.yml --vault-password-file ~/.vault_pass
```

---

## 6. Real Examples

### Complete LAMP Stack

```yaml
---
- name: Setup LAMP Stack
  hosts: webservers
  become: yes
  
  vars:
    mysql_root_password: "{{ vault_mysql_password }}"
    db_name: myapp
    db_user: appuser
  
  tasks:
    # Apache
    - name: Install Apache
      apt:
        name: apache2
        state: present
        update_cache: yes
    
    - name: Start Apache
      service:
        name: apache2
        state: started
        enabled: yes
    
    # MySQL
    - name: Install MySQL
      apt:
        name:
          - mysql-server
          - python3-pymysql
        state: present
    
    - name: Set MySQL root password
      mysql_user:
        name: root
        password: "{{ mysql_root_password }}"
        login_unix_socket: /var/run/mysqld/mysqld.sock
    
    - name: Create database
      mysql_db:
        name: "{{ db_name }}"
        state: present
        login_user: root
        login_password: "{{ mysql_root_password }}"
    
    - name: Create database user
      mysql_user:
        name: "{{ db_user }}"
        password: "{{ vault_db_password }}"
        priv: "{{ db_name }}.*:ALL"
        state: present
        login_user: root
        login_password: "{{ mysql_root_password }}"
    
    # PHP
    - name: Install PHP
      apt:
        name:
          - php
          - php-mysql
          - libapache2-mod-php
        state: present
    
    - name: Restart Apache
      service:
        name: apache2
        state: restarted
```

### Docker Deployment

```yaml
---
- name: Deploy application with Docker
  hosts: app_servers
  become: yes
  
  vars:
    app_name: myapp
    app_image: "registry.example.com/myapp:{{ app_version }}"
    app_port: 8080
  
  tasks:
    - name: Install Docker
      apt:
        name:
          - docker.io
          - python3-docker
        state: present
        update_cache: yes
    
    - name: Start Docker service
      service:
        name: docker
        state: started
        enabled: yes
    
    - name: Pull Docker image
      docker_image:
        name: "{{ app_image }}"
        source: pull
    
    - name: Stop old container
      docker_container:
        name: "{{ app_name }}"
        state: stopped
      ignore_errors: yes
    
    - name: Remove old container
      docker_container:
        name: "{{ app_name }}"
        state: absent
      ignore_errors: yes
    
    - name: Start new container
      docker_container:
        name: "{{ app_name }}"
        image: "{{ app_image }}"
        state: started
        restart_policy: always
        ports:
          - "{{ app_port }}:8080"
        env:
          DB_HOST: "{{ db_host }}"
          DB_NAME: "{{ db_name }}"
```

---

## 📝 Ansible Commands

```bash
# Run playbook
ansible-playbook site.yml

# Check syntax
ansible-playbook site.yml --syntax-check

# Dry run
ansible-playbook site.yml --check

# List tasks
ansible-playbook site.yml --list-tasks

# List hosts
ansible-playbook site.yml --list-hosts

# Start at specific task
ansible-playbook site.yml --start-at-task="Install Nginx"

# Tags
ansible-playbook site.yml --tags "deploy"
ansible-playbook site.yml --skip-tags "database"

# Verbose output
ansible-playbook site.yml -v
ansible-playbook site.yml -vvv  # Very verbose
```

---

## 🎯 Next Steps

1. **Practice**: Automate server setups
2. **Learn**: Ansible Tower/AWX for enterprise
3. **Explore**: Dynamic inventory (AWS, GCP)
4. **Build**: Complete automation workflows

---

**Configuration Management mastered! ⚙️**
