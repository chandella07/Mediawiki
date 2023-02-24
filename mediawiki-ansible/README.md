Mediawiki-ansible
=================

This role can be used to configure mediawiki application running on RHEL 8 (Azure VM). Role has multiple sub-playbooks in `tasks` folder to configure complete application.

Requirements
------------

This role doesn't have any specific requirement. It uses the standard ansible modules.

Role Variables
--------------

variables are defined in `vars/main.yml`
NOTE: For some variables values are fetched from environment vars.

Dependencies
------------

This role doesn't depend on any other ansible-galaxy role

Example Playbook
----------------

Below is one sample playbook for how to use this role.

    - name: main playbook
      hosts: all
      remote_user: "{{ lookup('env', 'TF_VAR_admin_user') }}"
      become: yes
      gather_facts: no

      roles:
        - role: mediawiki-ansible

Role strcuture
--------------

      mediawiki-ansible
      │   ├── README.md
      │   ├── defaults
      │   │   └── main.yml
      │   ├── files
      │   ├── handlers
      │   │   └── main.yml
      │   ├── meta
      │   │   └── main.yml
      │   ├── tasks
      │   │   ├── firewall.yml
      │   │   ├── generate_ssl_cert.yml
      │   │   ├── install_packages.yml
      │   │   ├── main.yml
      │   │   ├── mariadb.yml
      │   │   ├── mediawiki.yml
      │   │   ├── restart.yml
      │   │   └── selinux.yml
      │   ├── templates
      │   ├── test-playbook.yml
      │   ├── tests
      │   │   ├── inventory
      │   │   └── test.yml
      │   └── vars
      │       └── main.yml

License
-------

BSD

