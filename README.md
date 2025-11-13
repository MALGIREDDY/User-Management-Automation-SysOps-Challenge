<h1><font color="blue"><b> Linux User Management Automation (Shell Script)</b></font></h1>

This project automates onboarding of multiple users on a Linux server using a single shell script.  
It is designed for **DevOps**, **SysOps**, **Cloud Engineers**, and **Linux Administrators** who want to automate repetitive user-creation work.

This tool ensures:
- Faster onboarding  
- Zero manual errors  
- Better security practices  
- Professional DevOps workflow  

<hr/>

<h1><font color="blue"><b> About This Project</b></font></h1>

Managing large numbers of user accounts manually is time-consuming and error-prone.  
This automation script provides a:

- Standardized  
- Repeatable  
- Secure  
- Auditable  

workflow for Linux user provisioning.

It reads data from a config file, creates users, groups, secure passwords, home directories, logs everything, and stores credentials safely.

<hr/>

<h1><font color="blue"><b> Features</b></font></h1>

- Creates users automatically  
- Creates primary and secondary groups  
- Generates secure random passwords  
-Creates /home/ directories  
- Configures permissions (700)  
- Logs all actions  
- Stores passwords securely  
- Detects existing users/groups  
- Skips invalid lines  
- Easy to maintain and extend  

<hr/>

<h1><font color="blue"><b> Input File Format (users.txt)</b></font></h1>

<pre>
light; sudo,dev,www-data
siyoni; sudo
manoj; dev,www-data
</pre>

<b>Rules:</b>  
- Format → username; group1,group2  
- Spaces are auto-ignored  
- Lines beginning with # are skipped  

<hr/>

<h1><font color="blue"><b> How the Script Works</b></font></h1>

<b>Workflow Overview:</b>

<b>Password Generation:</b>

<pre>openssl rand -base64 12</pre>

<b>Security Best Practices:</b>

- No hardcoded passwords  
- Password file permissions: 600  
- Home dir permissions: 700  
- sudo required for privileged actions  

<hr/>

## 🏗️ Architecture Diagram

```
users.txt
   ↓
create_users.sh
   ↓
User Creation + Group Assignment
   ↓
Password Generation
   ↓
Home Directory Setup
   ↓
Logs + Password Storage
(user_management.log / user_passwords.txt)
```

<hr/>

<h1><font color="blue"><b> Running the Script</b></font></h1>

<h2><font color="blue"><b>1. Make executable</b></font></h2>
<pre>chmod +x create_users.sh</pre>

<h2><font color="blue"><b>2. Run with sudo</b></font></h2>
<pre>sudo bash create_users.sh users.txt</pre>

<hr/>

<h1><font color="blue"><b> Project Structure</b></font></h1>

<pre>
linux-user-management/
│── create_users.sh
│── users.txt
│── README.md
│── user_management.log
│── user_passwords.txt
</pre>

<hr/>

<h1><font color="blue"><b> Example Log Output</b></font></h1>

<pre>
2025-11-13 10:28:11 | Created user: light
2025-11-13 10:28:11 | Added to groups: sudo,dev,www-data
2025-11-13 10:28:11 | Password generated and stored securely
2025-11-13 10:28:11 | Home directory created: /home/light
</pre>

<hr/>

<h1><font color="blue"><b> Prerequisites</b></font></h1>

- Linux OS (Ubuntu, Debian, CentOS, WSL, etc.)
- sudo access  
- openssl installed (`sudo apt install openssl`)  
- Basic shell scripting knowledge (optional)

<hr/>

<h1><font color="blue"><b> Troubleshooting</b></font></h1>

<b>Permission Denied?</b>  
Run with sudo:

<pre>sudo bash create_users.sh users.txt</pre>

<b>openssl not found?</b>  
<pre>sudo apt install openssl</pre>

<b>Log or secure folders missing?</b>  
Script will auto-create them.

<hr/>

<h1><font color="blue"><b> Contributing</b></font></h1>

Feel free to open issues, suggest improvements, or submit pull requests.

<hr/>

<h1><font color="blue"><b> License</b></font></h1>

This project is open-source and available under the **MIT License**.

<hr/>

<h1><font color="blue"><b> Author</b></font></h1>

<b>Created by: M SAIDEEP</b>  
DevOps / SysOps Automation Projects  
GitHub Profile: https://github.com/MALGIREDDY




