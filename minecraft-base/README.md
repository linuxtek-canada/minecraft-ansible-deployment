## Ansible script to automate installation of latest Minecraft Java Edition Server on new Linux machine.

This project is designed to completely automate the installation of Minecraft Java Edition Server on a Linux machine.

## Introduction

This project is a continuation to automate creating a Minecraft server on VMware vSphere using Packer, Terraform, and Ansible.  Reference Links:

* [Packer Code](https://github.com/linuxtek-canada/packer/tree/master/Debian-11-Bullseye)
* [Terraform Code](https://github.com/linuxtek-canada/Terraform/tree/master/vmware-base)

From testing, the Ansible Playbook can also be used to spin up Minecraft on AWS and GCP instances, OS depending.

## Testing

The script is designed to be as distribution agnostic as possible, but not all use cases can be taken into consideration, or were tested.

**The script was tested to work with:**

* AWS - AMI - Ubuntu Server 20.04 LTS
* AWS - AMI - Amazon Linux 2 (HVM) - Kernel 5.10
* GCP - Debian 11 Bullseye
* VMware vSphere - Debian 11 Bullseye

**The script had problems with:**

* Debian 10 - older package requirements throw errors, such as package issues
* RHEL 8 - [screen has been deprecated](https://access.redhat.com/solutions/4136481#:~:text=The%20screen%20utility%20was%20marked,guide%20to%20help%20users%20switch), would need to switch to using tmux or rcon to send Minecraft console commands.
    
## Usage

1.  Clone this repo.

This can be done in Github at the following URL:  
https://github.com/linuxtek-canada/Ansible

Click the green "Code" button and copy the SSH path to the repository.

Review [this link](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-ssh-urls) for instructions on cloning with SSH URLs.


In the directory where you want to clone the files, run:

``` git clone git@github.com:linuxtek-canada/Ansible.git ```

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

3.  Configure the inventory file.

This project uses a local ```inventory``` file, however Ansible can easily be set up to use a global one. [For reference](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)

For a simple inventory file, all that needs to be entered is the IP address of the remote server to connect to.

If multiple servers will be used, they can be broken down into groups, or a YAML based file can be created.

4.  Ensure you have the latest version of Ansible installed locally

This script requires **Ansible 2.9.8 or later**, to avoid this error:  ["Malformed output discovered from systemd list-unit-files"](https://giters.com/ansible/ansible/issues/74717)
 
5.  Run the Ansible Playbook

If you are using SSH key based authentication, then you should just need to run:

``` ansible-playbook -i ./inventory buildminecraft.yml ```

If you are using username and password based authentication, you will be prompted for the user password, and the root password.