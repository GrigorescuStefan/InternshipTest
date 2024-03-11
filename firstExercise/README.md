# Initial Declarations
```bash
passwdFile=$(find /etc/ -maxdepth 1 -name "passwd")
```
**I added this declaration, for the file I want to search in, for 2 reasons:**  
1. If i search without `maxdepth 1` I get 2 results and as I am only using one, I need to filter the other.
```bash
root@4715eac64a61:/# find /etc/ -name "passwd"
/etc/pam.d/passwd
/etc/passwd
```
2. Adding a variable instead of using the string `/etc/passwd` helps with debugging as well as making sure I don't have a typo anywhere that could lead to more issues.

# 1. File name check and reading contents

In this function i am checking to see whether the file exists, and if it does i am simply displaying its inputs in the terminal.
```bash
checkPasswdFile(){
    if [ -z passwdFile ]; then
      echo "Passwd file was not found!"
    else
      echo "Found passwd file: $passwdFile"
      echo
      cat "$passwdFile"
    fi
}
```

# 2. Print the home directory
In this function i am simply display the home directory, and the first echo is to format the output a bit, it will come in handy at later functions.
```bash
printHomeDirectory(){
  echo 
  echo "Home Directory: $HOME"
}
```

# 3. List all usernames from the passwd file
In this function i am displaying only a portion of the contents from the `/etc/passwd`. The first field being the username, i simply have to display them, the flag `-d` representing the delimiter
```bash
listAllUsernames(){
  echo
  echo "Usernames:"
  cut -d : -f1 $passwdFile
}
```

# 4. Count the number of users
In this function i am atributing to the variable `count` the command `wc` , which counts the words. The flag `-l` takes the new lines into consideration as the main file has a new user on each new line.
```bash
countAllUsers(){
  count=$(wc -l $passwdFile | awk '{print $1}')
  echo
  echo "There are $count users!"
}
```

# 5. Find the home directory of a specific user
In this function i am taking user input with the command `read` and i am storing it into the `user` variable. Using the `grep` command which searches the main file for the name of the user. I need to mention that the `^` symbol only takes the first element of each line into consideration to check, and it prints the home directory of the user found to the terminal.
```bash
homeDirectoryOfUser(){
  echo
  read -p "Enter the username you want the home directory of: " user
  userDirectory=$(grep "^$user:" $passwdFile | cut -d : -f6)
  echo "Home directory of $user is $userDirectory"
}
```

# 6. List users with specific UID range
In this function i set 2 variables for the upper and lower bounds of the UIDs of the users. Using the `awk` function i search through the whole main file and check to see if the 3rd field, which corresponds to the UID is within the set bounds. If it is, i can print the username to the terminal.
```bash
listUsersByUID(){
  echo
  read -p "Enter the lower bound of UIDs: " lowerBound
  read -p "Enter the upper bound of UIDs: " upperBound
  echo "Users with UIDs between $lowerBound and $upperBound:"
  awk -F: '$3 >= '$lowerBound' && $3 <= '$upperBound' { print $1 }' "$passwdFile"
}
```

# 7. Find users with standard shells 
The functionality here is similar to the one at #6, the only difference is the strings i use to check for the standard shells `/bin/bash` and `/bin/sh`. The `-F` flag is for the field separator `:`
```bash
listUsersWithStandardShells(){
  echo
  echo "Users with Standard Shells are:"
  awk -F: '$7 == "/bin/bash" || $7 == "/bin/sh" { print $1 }' "$passwdFile"
}
```
# 8. Replace the “/” character with “\” character in the entire /etc/passwd file and redirect the content to a new file
In this function i declared my outputFile. I am using the `gsub` functionality (global substitution) to check for the string `/` and replace it with `\`. I have to mention that i don't understand why i need 4 `\` . I suppose it has something to do that with the fact that usually `\n` is used to delimiter new lines and in bash I need multiple symbols to separate the "make sure here it's new line" from "it's just a normal string".
```bash
replacedSlashWithCounterpart(){
  outputFile="/changedPasswd.txt"
  echo
  awk '{ gsub("/", "\\\\" ); print }' "$passwdFile" > "$outputFile" 
  cat $outputFile
}
```

# 9. Print the private IP
Pretty simple functionality. I only had to call the `hostname` command with the appropiate IP flag.
```bash
printPrivateIP(){
  echo
  echo "Private IP: $(hostname -I)"
}
```

# 10. Print the public IP
So far I have managed with the basic functionalities brought by that docker container with the Ubuntu image, however here I had some problems. I found myself forced to install `curl`. I did not find an "out of the box" method. Any method I knew wasn't in the standard package so I installed curl to be able to call `ifconfig.me' to return my public IP.
```bash
root@4715eac64a61:/# wget
bash: wget: command not found
root@4715eac64a61:/# ip
bash: ip: command not found
root@4715eac64a61:/# ifconfig
bash: ifconfig: command not found
root@4715eac64a61:/# nslookup
bash: nslookup: command not found
root@4715eac64a61:/# dig
bash: dig: command not found
```

```bash
printPublicIP(){
  echo
  echo "Public IP: $(curl -s ifconfig.me)"
}
```
# 11. Switch to john user & 12. Print the home directory
For this case, the functionality is combined. I found it easier to display switch to the other user and print the values representative to him. The command `EOF` is used to declare that after the user switch, the next couple of commands are executed afterwards, instead of waiting for me, as the `root` user to return.
```bash
switchUser(){
  sudo -u john bash << EOF
  echo "Current user:"
  whoami
  echo "Home Directory: $HOME"
EOF
}
```

# Global call
After I declared all functions, i decided to create a `main` function that i can call, and by itself it can run sequentially all the functions i created.
```bash
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
```























