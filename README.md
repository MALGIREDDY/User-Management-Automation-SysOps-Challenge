<h1><b>* Linux User Management Automation (Shell Script)*</b></h1>

This project automates onboarding of new users on a Linux system using a single shell script.
It reads a configuration file containing usernames and group assignments, then automatically:

- Creates users & primary groups  
- Adds users to additional groups  
- Creates secure passwords  
- Generates home directories  
- Logs all activity  
- Stores credentials securely  

This is ideal for <b>DevOps / SysOps automation</b>.

<hr/>

<h1><b> Features</b></h1>

- Reads a user list from a users.txt file  
- Creates users and primary groups  
- Adds users to supplementary groups  
- Generates secure random passwords  
-Creates /home/&lt;user&gt; with correct permissions  
- Saves passwords securely  
- Logs all operations  
- Skips invalid/comment lines  
- Handles existing users/groups safely  

<hr/>

<h1><b> Input File Format (users.txt)</b></h1>

<pre>
light; sudo,dev,www-data
saideep; sudo
rahul; dev,www-data
</pre>

<h2><b>Rules</b></h2>

- Format → username; group1,group2,group3  
- Lines beginning with # are ignored  
- Spaces are auto-ignored  

<hr/>

<h1><b> How It Works (High-Level Logic)</b></h1>

1. Read file line-by-line  
2. Skip empty/comment lines  
3. Extract username + groups  
4. Create primary group  
5. Create user account  
6. Add to extra groups  
7. Create /home/user with 700 permissions  
8. Generate secure password:  
<pre>openssl rand -base64 12</pre>  
9. Apply password  
10. Log all actions  
11. Save credentials securely  

<hr/>

<h1><b> Running the Script</b></h1>

<h2><b>Make executable</b></h2>
<pre>chmod +x create_users.sh</pre>

<h2><b>Run with sudo</b></h2>
<pre>sudo bash create_users.sh users.txt</pre>

<hr/>

<h1><b> Project Structure</b></h1>

<pre>
linux-user-management/
│── create_users.sh
│── users.txt
│── README.md
│── user_management.log
│── user_passwords.txt
</pre>


<hr/>

<h1><b> Generated Files</b></h1>

| Location | Description |
|----------|-------------|
| /var/log/user_management.log | All logs |
| /var/secure/user_passwords.txt | Saved passwords |

<hr/>

<h1><b> Security Considerations</b></h1>

- Password file uses chmod 600  
- No passwords printed  
- No hardcoded passwords  
- Home directory → chmod 700  
- Sensitive files stored in /var/secure/  
- Script requires sudo  

<hr/>

<h1><b> Technologies Used</b></h1>

- Bash / Shell Scripting  
- Linux User Management  
- WSL Ubuntu  
- openssl password generation  

<hr/>

<h1><b> Example Log Output</b></h1>

<pre>
2025-11-13 10:28:11 | Created user: light
2025-11-13 10:28:11 | Added to groups: sudo,dev,www-data
2025-11-13 10:28:11 | Password generated and stored securely
2025-11-13 10:28:11 | Home directory created: /home/light
</pre>

<hr/>

<h1><b> Author</b></h1>

<b>M SAIDEEP</b>  
DevOps / SysOps Automation Practice



