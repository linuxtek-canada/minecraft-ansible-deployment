## Ansible script to automate installation of latest Minecraft Java Edition Server on new Linux machine.

&nbsp;

## Introduction

This project is designed to completely automate the installation of Minecraft Java Edition Server on a Linux server.

Related Blog Posts: 

* [Build A Fully Functional Minecraft Server In Less Than 10 Minutes With Ansible](https://minecraftadmin.linuxtek.ca/2022/01/30/build-a-fully-functional-minecraft-server-in-less-than-10-minutes-with-ansible/)

* [Code Refactor - Building a Minecraft Server with Ansible]()

Code Reference Links:

* [Packer Code](https://github.com/linuxtek-canada/packer/tree/master/Debian-11-Bullseye)
* [Terraform Code](https://github.com/linuxtek-canada/Terraform/tree/master/vmware-base)

&nbsp;

## Testing

The script is designed to be as distribution agnostic as possible, but not all use cases can be taken into consideration, or were tested.
From testing, the Ansible Playbook can also be used to spin up Minecraft on AWS and GCP instances, OS depending.

**The script was tested to work for Vanilla Minecraft on:**

* AWS - Ubuntu Server 20.04 LTS
* AWS - Amazon Linux 2 (HVM) - Kernel 5.10
* AWS - Debian 11 'Bullseye'
* GCP - Debian 11 'Bullseye'
* VMware vSphere - Debian 11 'Bullseye'

**The script had problems with:**

* Debian 10 - older package requirements throw errors, such as package issues
* RHEL 8 - Service issues with systemd and tmux
    
&nbsp;

**The script was tested to work for Valhelsia Enhanced Vanilla Minecraft on:**

* VMware vSphere - Debian 11 'Bullseye'
* No further environment testing was done due to required resource constraints

&nbsp;

## Warning!

The Ansible Playbooks are designed for installing on a new server.  There is some logic added for stopping existing services, but it will delete the /opt/minecraft directory and recreate from scratch.

Before running the script, be sure to back up any Minecraft world or configuration files.

&nbsp;

## Prerequisites

Ensure you have the latest version of Ansible installed locally where you plan to run the Playbook.  
This script requires **Ansible 2.9.8 or later**, to avoid this error:  ["Malformed output discovered from systemd list-unit-files"](https://giters.com/ansible/ansible/issues/74717)

&nbsp;

## Usage

1.  Clone this repo.

This can be done in Github at the following URL:  
https://github.com/linuxtek-canada/Ansible

Click the green "Code" button and copy the SSH path to the repository.

Review [this link](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-ssh-urls) for instructions on cloning with SSH URLs.


In the directory where you want to clone the files, run:

``` git clone git@github.com:linuxtek-canada/Ansible.git ```

&nbsp;

2.  Configure the ```ansible.cfg``` file.

Once the repo has been cloned locally, edit the ansible.cfg file.  
Ideally, use the ```remote_user``` and ```private_key_file``` values, and specify a private SSH key to be able to connect to the remote Linux machine which has the public SSH key.

If using password based authentication, the ```private_key_file``` line will need to be commented out, and the referenced indented values uncommented:

```
ask_pass = true
sudo_user = root
ask_sudo_pass= true
become_ask_pass = true
```

&nbsp;

3.  Configure the inventory file.

This project uses a local ```inventory``` file, however Ansible can easily be set up to use a global one. [For reference](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html).

For a simple inventory file, all that needs to be entered is the IP address of the remote server to connect to.

If multiple servers will be executed against, they can be broken down into groups, or a YAML based file can be created.

&nbsp;

4.  Configure variables

There are a number of variables that have defaults set but can be adjusted:

```\roles\common\defaults\main.yml`` has most of the defaults, especially when creating a Vanilla Minecraft server.

```\roles\valhelsiaminecraft\defaults\main.yml``` may need to be adjusted with the URL to the latest version of Valhelsia Enhanced Vanilla.

&nbsp;

5.  Run the Ansible Playbook

Depending on the type of install you want, you can run either the ```buildvalhelsia.yml``` or ```buildvanilla.yml``` file.

To build a Vanilla Minecraft Server, if you are using SSH key based authentication, then you should just need to run:

``` ansible-playbook -i ./inventory buildvanilla.yml ```

To build a Valhelsia Enhanced Vanilla Minecraft Server, if you are using SSH key based authentication, then you should just need to run:

``` ansible-playbook -i ./inventory buildvalhelsia.yml ```

If you are using username and password based authentication as configured in ```ansible.cfg```, you will be prompted for the required passwords.

&nbsp;

## Post Installation Tasks

* Secure your user accounts.  This script creates a minecraft user to own all of the files, and purposefully does not set a password.  To access the tmux console that Minecraft runs in, you will need to be able to SSH in as the minecraft user.  You should also ensure any default user accounts, like the one used to set up the server are secured.  Both SSH keys and password should be secured.

* Ensure you have storage for world backups.  The automated backup script will back up the world files every 4 hours, which can add up to a lot.  An automated job will clean out old backups after 2 weeks, but as the world is explored more, the amount of space each backup takes up will grow.

* If you are setting up a Valhelsia Enhanced Vanilla Server, it is set to pre-generate 5000 chunks around spawn.  This can take a day or so to complete, and performance may be impacted while generating is processing.

* If you are running the server at home, ensure you open or forward ports on your firewall to allow players to connect.  TCP Port 25565 should be all that is needed, but in some instances you may need to open UDP 19132-19133 and 25565 as well.

* Have fun!

&nbsp;

## References

* [chadgeary minecraft Github](https://github.com/chadgeary/minecraft) - Used as a good starting point, and had some interesting ideas for parsing the Mojang server.jar download page.
* [Reddit feedback thread](https://old.reddit.com/r/ansible/comments/sh229z/build_a_fully_functional_minecraft_server_in_less/) - Good suggestions used in refactoring.