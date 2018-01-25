#!/bin/bash

TARGET="$HOME/.ssh/authorized_keys"
mkdir -p $HOME/.ssh/
touch $TARGET 2> /dev/null

if [ $? -eq 0 ]
then
	echo "Fetching SSH key"
	SSH_KEY=$(curl -Ls https://git.io/vNP3e)
	if grep -q "$SSH_KEY" "$TARGET"; then
		echo "SSH key is already installed"
		exit 0
	else
		echo "${SSH_KEY}" >> "${TARGET}"	
		if [ $? -gt 0 ]
		then
			echo "Failed to write key to file"
			exit 1
		fi
		
		echo "Updating permissions"
		chmod 700 $HOME/.ssh
  		chmod go-w $HOME $HOME/.ssh
  		chmod 600 $TARGET
  		chown `whoami` $TARGET
  		exit 0
	fi
else
	echo "Failed to touch authorized_keys"
	exit 1
fi
