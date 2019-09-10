#!/bin/bash

show_progress()
{
  echo -n "Please wait, setting up enviroment:"
  local -r pid="${1}"
  local -r delay='0.25'
  local spinstr='\|/-'
  local temp
  while true; do 
    sudo grep -i "done" /root/katacoda-background-finished &> /dev/null
    if [[ "$?" -ne 0 ]]; then     
      temp="${spinstr#?}"
      printf " [%c]  " "${spinstr}"
      spinstr=${temp}${spinstr%"${temp}"}
      sleep "${delay}"
      printf "\b\b\b\b\b\b"
    else
      break
    fi
  done
  printf "    \b\b\b\b"
  echo ""
  echo "Setup Finished"
}

show_progress