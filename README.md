#  Linux User Management Automation (Shell Script)

This project automates the onboarding of new users on a Linux system using a
shell script. It reads a configuration file containing usernames and group
assignments, then automatically creates users, groups, home directories,
secure passwords, and log files.

---

##  Features

- Reads a user list from a `.txt` file  
- Creates users and primary groups  
- Adds users to additional groups  
- Generates secure random passwords  
- Creates home directories with correct permissions  
- Saves credentials securely in `/var/secure/user_passwords.txt`  
- Logs all activity to `/var/log/user_management.log`  
- Handles existing users/groups gracefully  
- Skips invalid or commented lines  
- Provides clean success/error messages  

---

##  Input File Format

Your input file (`users.txt`) should look like:

light; sudo,dev,www-data
siyoni; sudo
manoj; dev,www-data

makefile
Copy code

Format:
username; group1,group2,group3

yaml
Copy code

- Lines beginning with `#` are skipped  
- Spaces are ignored  

---

##  How It Works (High-Level Logic)

1. Read input file line-by-line  
2. Skip blank lines and comments  
3. Extract username and group list  
4. Create primary group (same as username) if missing  
5. Create or update supplementary groups  
6. Create user account  
7. Create and configure `/home/<username>`  
8. Generate 12-character random password using `openssl rand -base64 12`  
9. Set password using `chpasswd`  
10. Log operations to `/var/log/user_management.log`  
11. Store credentials securely (`chmod 600`)  

---

##  Running the Script

### 1 Make the script executable:
```bash
chmod +x create_users.sh
2 Run the script with sudo:
bash
Copy code
sudo bash create_users.sh users.txt
3 Output files:
Location	Description
/var/log/user_management.log	Logs of all operations
/var/secure/user_passwords.txt	Secure storage of generated passwords

 Project Structure
sql
Copy code
linux-user-management/
│── create_users.sh
│── users.txt
│── README.md
 Security Considerations
Password file has strict 600 permissions

Script uses sudo for restricted operations

Passwords never appear in terminal output

Sensitive files stored under /var/secure/

Users get home directories with 700 permissions

No plain-text hardcoded passwords

 Technologies Used
Bash/Shell Scripting

Linux User & Group Management

WSL Ubuntu (if on Windows)

openssl for secure password generation

Example Log Output
text
Copy code
2025-11-13 10:28:11 | Created user: light
2025-11-13 10:28:11 | Added to groups: sudo,dev,www-data
2025-11-13 10:28:11 | Password generated and stored securely
2025-11-13 10:28:11 | Home directory created: /home/light

 Author
Created by [M SAIDEEP]
For DevOps / SysOps learning and automation practice.

yaml

