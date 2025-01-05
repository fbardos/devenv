#!/bin/bash
# #############################################################
# ENTRYPOINT for devenv
# #############################################################
echo -e "=============================================================="
echo -e "                                                              "
echo -e " /\$\$\$\$\$\$\$                       /\$\$\$\$\$\$\$\$                     "
echo -e "| \$\$__  \$\$                     | \$\$_____/                     "
echo -e "| \$\$  \ \$\$  /\$\$\$\$\$\$  /\$\$    /\$\$| \$\$       /\$\$\$\$\$\$\$  /\$\$    /\$\$"
echo -e "| \$\$  | \$\$ /\$\$__  \$\$|  \$\$  /\$\$/| \$\$\$\$\$   | \$\$__  \$\$|  \$\$  /\$\$/"
echo -e "| \$\$  | \$\$| \$\$\$\$\$\$\$\$ \  \$\$/\$\$/ | \$\$__/   | \$\$  \ \$\$ \  \$\$/\$\$/ "
echo -e "| \$\$  | \$\$| \$\$_____/  \  \$\$\$/  | \$\$      | \$\$  | \$\$  \  \$\$\$/  "
echo -e "| \$\$\$\$\$\$\$/|  \$\$\$\$\$\$\$   \  \$/   | \$\$\$\$\$\$\$\$| \$\$  | \$\$   \  \$/   "
echo -e "|_______/  \_______/    \_/    |________/|__/  |__/    \_/    "
echo -e "                                                              "
echo -e "=============================================================="
echo -e "                                                              "

### Create ssh keys if not already present ####################
# grep .pub is needed, otherwise will match inserted config file from Dockerfile
if [ -n "$(ls -A .ssh | grep .pub 2>/dev/null)" ]
then
  echo -e "[STARTUP] Check SSH: .ssh is already present. Skip."
else
  echo -e "[STARTUP] Check SSH: Key is missing. Generate SSH key."
  ssh-keygen -q -t ed25519 -C $DEVENV_ID_MAIL -f ~/.ssh/ed25519
fi

echo -e "[STARTUP] Start ssh-agent"
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)" > /dev/null 2>&1
echo -e "[STARTUP] Going to ask for containers ssh key passphrase..."
ssh-add ~/.ssh/ed25519

### git config ################################################
echo -e "[STARTUP] Set git user..."
git config --global user.name $DEVENV_ID_NAME
git config --global user.email $DEVENV_ID_MAIL

### Finally start bash ########################################
bash -i
