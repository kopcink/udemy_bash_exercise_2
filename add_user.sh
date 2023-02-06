#!/bin/bash

if [[ "$UID" -ne 0 ]]
then
    echo "You need to execute the script with root privileges."
    exit 1
fi

if [[ "$#" -eq 0 ]]
then
    echo "USAGE: $(basename ${0}) USERNAME [COMMENT...]"
    exit 1
fi

USERNAME=${1}
shift
COMMENT=${@}

read -p "Provide an initial password: " PASSWORD

useradd -ms /bin/bash -c "${COMMENT}" "${USERNAME}"

if [[ "$?" -ne 0 ]]
then
    echo "The script was not able to create a user ${USERNAME}."
    exit 1
fi

echo "${USERNAME}:${PASSWORD}" | chpasswd
passwd -e "${USERNAME}"

echo
echo "========================="
echo "Username: $USERNAME"
echo "Initial password: $PASSWORD"
echo "Host: $HOSTNAME"
echo "========================="
