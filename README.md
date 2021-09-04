# jumpstart-my-macbook

Jumpstart my MacBook Using Ansible

To setup run the following command :

```
curl -s https://raw.githubusercontent.com/ajitabhpandey/jumpstart-my-macbook/master/start.sh | /bin/bash
```

To directly install using ansible:

```
ansible-playbook -v -i ./hosts playbook.yml --ask-become-pass
```

If the playbook breaks in between for some reason and you want to restart the same and skip some tags use something as below:

```
ansible-playbook -v -i ./hosts playbook.yml --skip-tags install --ask-become-pass
```

In the above example, I am assuming that you want to skip all the tasks with the install tag. Multiple tags can be specified with a comma.

The list of software installed through homebrew is maintained as variables. To see, or modify this list look at [groups_var/macbook.yml](https://raw.githubusercontent.com/ajitabhpandey/jumpstart-my-macbook/master/master/group_vars/macbook.yml).

_NOTE_ - VirtualBox installtion may give failures as Oracle needs to be accepted as provider by visiting the System Preferences -> Security & Privacy -> General. After that another attempt from command line using

```
brew cask install virtualbox
```

#### Uninstall

If you want to undo all the changes that the script did, run the following -

```
start.sh uninstall
```
