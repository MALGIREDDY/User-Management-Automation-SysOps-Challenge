# Linux User Management Automation (SysOps Challenge)

This project provides a complete automation solution for onboarding multiple users on a Linux server using a single shell script: **create_users.sh**.

It is designed for **SysOps**, **DevOps**, **Cloud Engineers**, and **Linux Administrators** who want:

- Faster onboarding  
- Zero manual errors  
- Strict security  
- Full logging & auditing  
- Standards-based Linux user provisioning  

---

##  Purpose of the Script

Manual user creation is slow and prone to mistakes.  
This automation script ensures a **secure, repeatable, and auditable** process for:

- Creating users  
- Creating required groups  
- Creating primary group = username  
- Setting up home directories  
- Assigning correct permissions  
- Generating secure passwords  
- Logging all activities  
- Storing credentials safely  

The script reads an input file containing:

```
username; group1,group2,group3
```

It handles **existing users**, **whitespace**, **comments**, and **errors** gracefully — making it ideal for production SysOps workflows.

---

##  Input File Format (users.txt)

### Example:

```
# Admin users
light; sudo,dev,www-data
siyoni; sudo

# Developer
manoj; dev,www-data
```

###  Rules:

- Format: `username; group1,group2,group3`
- Whitespace is automatically ignored
- Lines beginning with # are skipped
- Groups are comma-separated
- Each user gets a primary group with the same name as the username
- One user per line

---

#  How the Script Works (Step-by-Step)

### **1. Read input file line-by-line**
- Skip empty lines  
- Skip lines beginning with `#`  
- Remove extra whitespace  

### **2. Parse username and groups**

Example:

```
light; sudo,dev,www-data
```

- Username - `light`  
- Additional groups - `sudo dev www-data`  
- Primary group - `light` (always created if missing)  

---

### **3. Handle existing users and groups**
- If group already exists - script logs & skips  
- If user already exists - script logs & skips  
- Missing groups are created automatically  

---

### **4. Create the user**
User is created with:

- **Primary group = username**  
- **Secondary groups = from input**  
- Home directory created at `/home/username` if missing  

---

### **5. Setup home directory**

Permissions applied:

- Owner: `username:username`
- Directory permissions: `700`

---

### **6. Generate a secure random password**

```
openssl rand -base64 12
```

---

### **7. Set the password for the user**

Password applied immediately via:

```
chpasswd
```

---

### **8. Store credentials securely**

Stored in:

```
/var/secure/user_passwords.txt
```

File permission:

```
chmod 600
```

---

### **9. Log all actions**

Log file location:

```
/var/log/user_management.log
```

Log file permission:

```
chmod 600
```

The script logs:

- User created  
- Existing user skipped  
- Groups created  
- Groups added  
- Home directory created  
- Password generated  
- Errors  
- Invalid / ignored lines  

---

#  Architecture Workflow

```
users.txt
   ↓
create_users.sh
   ↓
User + Group Creation
   ↓
Home Directory Setup
   ↓
Password Generation
   ↓
Secure Storage + Logging
```

---

#  How to Run the Script

### **1. Make executable**
```
chmod +x create_users.sh
```

### **2. Run with sudo**
```
sudo ./create_users.sh users.txt
```

Root/sudo access is required because the script modifies system users, groups, directories, and passwords.

---

#  Project Structure

```
linux-user-management/
│── create_users.sh
│── users.txt
│── README.md
│── user_management.log
│── user_passwords.txt
```

---

#  Example Log Output

```
2025-11-13 10:28:11 | Processing user: light
2025-11-13 10:28:11 | Created primary group: light
2025-11-13 10:28:11 | Created user: light
2025-11-13 10:28:11 | Added to groups: sudo,dev,www-data
2025-11-13 10:28:11 | Home directory created: /home/light
2025-11-13 10:28:11 | Generated random password for user
2025-11-13 10:28:11 | Stored credentials securely
```

---

#  Security Considerations

- No hardcoded passwords  
- Passwords stored only in `/var/secure/user_passwords.txt`  
- Password file permissions must be `600`  
- Log file contains sensitive data → set to `600`  
- Home directory permissions → `700`  
- Script fully sanitizes whitespace and CRLF characters  
- Root privileges required  
- Prevents accidental misconfigurations by checking existing users/groups  

---

#  Troubleshooting

### **Permission denied?**
Run with sudo:
```
sudo ./create_users.sh users.txt
```

### **openssl missing?**
```
sudo apt install openssl
```

### **Log or secure folder missing?**
Script will auto-create them.

### **Wrong formatting in users.txt?**
- Use correct `username; group1,group2` format  
- Remove extra semicolons or invalid characters  

--- 

#  Author

**Created by:** M SAIDEEP  
GitHub Profile: **https://github.com/MALGIREDDY**


