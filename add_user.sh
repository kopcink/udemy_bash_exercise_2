#!/bin/bash

if [[ "$UID" -ne 0 ]]
then
    echo "You need to execute the script with root privileges." >&2
    exit 1
fi

if [[ "$#" -eq 0 ]]
then
    echo "USAGE: $(basename ${0}) USERNAME [COMMENT...]" >&2
    exit 1
fi

USERNAME=${1}
shift
COMMENT=${@}

PASSWORD=$(echo "${RANDOM}${RANDOM}$(date +%N)" | sha256sum | cut -c1-12)

useradd -ms /bin/bash -c "${COMMENT}" "${USERNAME}" &> /dev/null

if [[ "$?" -ne 0 ]]
then
    echo "The script was not able to create a user ${USERNAME}." >&2
    exit 1
fi

echo "${USERNAME}:${PASSWORD}" | chpasswd &> /dev/null
passwd -e "${USERNAME}" &> /dev/null

echo
echo "========================="
echo "Username: $USERNAME"
echo "Initial password: $PASSWORD"
echo "Host: $HOSTNAME"
echo "========================="
