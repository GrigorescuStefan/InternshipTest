#!/bin/bash

passwdFile=$(find /etc/ -maxdepth 1 -name "passwd") # exista 2 fisiere cu numele passwd in /etc/ si daca nu specificam -maxdepth, nu as fi luat datele bune

checkPasswdFile(){
    if [ -z passwdFile ]; then
      echo "Passwd file was not found!"
    else
      echo "Found passwd file: $passwdFile"
      echo
      cat "$passwdFile"
    fi
}

printHomeDirectory(){
  echo # spatiere dintre exercitii la afisare in terminal
  echo "Home Directory: $HOME"
}

listAllUsernames(){
  echo
  echo "Usernames:"
  cut -d : -f1 $passwdFile
}

countAllUsers(){
  count=$(wc -l $passwdFile | awk '{print $1}')
  echo
  echo "There are $count users!"
}

homeDirectoryOfUser(){
  echo
  read -p "Enter the username you want the home directory of: " user
  userDirectory=$(grep "^$user:" $passwdFile | cut -d : -f6)
  echo "Home directory of $user is $userDirectory"
}

listUsersByUID(){
  echo
  read -p "Enter the lower bound of UIDs: " lowerBound
  read -p "Enter the upper bound of UIDs: " upperBound
  echo "Users with UIDs between $lowerBound and $upperBound:"
  awk -F: '$3 >= '$lowerBound' && $3 <= '$upperBound' { print $1 }' "$passwdFile" # $3 e UID-ul din formatul fisierului /etc/passwd si $1 e numele user-ului
}

listUsersWithStandardShells(){
  echo
  echo "Users with Standard Shells are:"
  awk -F: '$7 == "/bin/bash" || $7 == "/bin/sh" { print $1 }' "$passwdFile"
}

replacedSlashWithCounterpart(){
  outputFile="/changedPasswd.txt"
  echo
  awk '{ gsub("/", "\\\\" ); print }' "$passwdFile" > "$outputFile" # nu inteleg de ce am nevoie de 4 "\" pentru a-l reprezenta odata ca string, dar am nevoie doar de 1 "/"
  cat $outputFile
}

printPrivateIP(){
  echo
  echo "Private IP: $(hostname -I)"
}

printPublicIP(){
  echo
  echo "Public IP: $(curl -s ifconfig.me)" # m-am vazut nevoit sa instalez curl, altfel nu aveam instalat nici curl, wget, ip, ifconfig, nslookup, etc
}

switchUser(){
  sudo -u john bash << EOF
  echo "Current user:"
  whoami
  echo "Home Directory: $HOME"
EOF
}

main(){
  checkPasswdFile
  printHomeDirectory
  listAllUsernames
  countAllUsers
  homeDirectoryOfUser
  listUsersByUID
  listUsersWithStandardShells
  replacedSlashWithCounterpart
  printPrivateIP
  printPublicIP
  switchUser
}

main