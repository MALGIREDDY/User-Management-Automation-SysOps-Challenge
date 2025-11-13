Linux User Management Automation (Shell Script)

This project automates onboarding of new users on a Linux system using a single shell script.
It reads a configuration file containing usernames and group assignments, then automatically:

Creates users & primary groups

Adds users to additional groups

Creates secure passwords

Generates home directories

Logs all activity

Stores credentials securely

This is ideal for DevOps / SysOps automation, especially for multiple-user onboarding.

🔥 Features

✔ Reads a user list from a users.txt file

✔ Creates users and primary groups

✔ Adds users to supplementary groups

✔ Generates secure random passwords

✔ Creates /home/<user> with secure permissions

✔ Saves passwords in /var/secure/user_passwords.txt

✔ Logs operations in /var/log/user_management.log

✔ Skips invalid or commented lines

✔ Handles existing users/groups safely

✔ Clean, user-friendly output

📄 Input File Format (users.txt)
light; sudo,dev,www-data
siyoni; sudo
manoj; dev,www-data

Rules

Format → username; group1,group2,group3

Lines starting with # are ignored

Spaces are ignored automatically

⚙️ How It Works (High-Level Logic)

Read input file line-by-line

Ignore empty lines & comments

Extract username and group list

Ensure primary group exists

Create user account if missing

Add user to supplementary groups

Create /home/<username> with 700 permissions

Generate secure password:

openssl rand -base64 12


Apply password using chpasswd

Log all operations

Save credentials under /var/secure/ with 600 permissions

🏃 Running the Script
Make executable
chmod +x create_users.sh

Run with sudo
sudo bash create_users.sh users.txt

📁 Project Structure
linux-user-management/
│── create_users.sh
│── users.txt
│── README.md

📜 Generated Files
Location	Description
/var/log/user_management.log	All activity logs
/var/secure/user_passwords.txt	Secure password storage
🔐 Security Considerations

Password file permission: chmod 600

No passwords printed on screen

No hardcoded passwords

Home directories use strict 700 mode

Sensitive files stored under /var/secure/

Requires sudo privileges

🛠 Technologies Used

Bash / Shell Scripting

Linux User Management

WSL Ubuntu (optional)

openssl for password generation

📝 Example Log Output
2025-11-13 10:28:11 | Created user: light
2025-11-13 10:28:11 | Added to groups: sudo,dev,www-data
2025-11-13 10:28:11 | Password generated and stored securely
2025-11-13 10:28:11 | Home directory created: /home/light

👨‍💻 Author

Created by: M SAIDEEP
DevOps / SysOps Automation Projects
