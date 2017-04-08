### Configuring Postfix to fowrad to Gmail
    
Install Postfix and the libsasl2-modules package:

    sudo apt-get install libsasl2-modules postfix

During the Postfix installation, a prompt will appear asking for your General type of mail configuration. Select `Internet Site`.

Enter the fully qualified name of your domain. For example, `fqdn.example.com`.

Once the installation is complete, confirm that the myhostname parameter is configured with your server’s FQDN:

Set the hostname in the `/etc/postfix/main.cf` file:

    myhostname = fqdn.example.com

### Generate an App Password for Postfix

When Two-Factor Authentication (2FA) is enabled, Gmail is preconfigured to refuse connections from applications like Postfix that don’t provide the second step of authentication. While this is an important security measure that is designed to restrict unauthorized users from accessing your account, it hinders sending mail through some SMTP clients as you’re doing here. Follow these steps to configure Gmail to create a Postfix-specific password:

1. Log in to your email, then click the following link: Manage your account access and security settings. Scroll down to “Password & sign-in method” and click 2-Step Verification. You may be asked for your password and a verification code before continuing. Ensure that 2-Step Verification is enabled.

2. Click the following link to Generate an App password for Postfix.

3. Click Select app and choose Other (custom name) from the dropdown. Enter “Postfix” and click Generate.

4. The newly generated password will appear. Write it down or save it somewhere secure that you’ll be able to find easily in the next steps, then click Done.

### Add Gmail Username and Password to Postfix

Usernames and passwords are stored in `sasl_passwd` in the `/etc/postfix/sasl/` directory. In this section, you’ll add your email login credentials to this file and to Postfix.

1. Open or create the `/etc/postfix/sasl/sasl_passwd` file and add the SMTP Host, username, and password information:

Add the following line in the `/etc/postfix/sasl/sasl_passwd` file:

    [smtp.gmail.com]:587 username@gmail.com:password
    
2. Create the hash db file for Postfix by running the `postmap` command:

    sudo postmap /etc/postfix/sasl/sasl_passwd
    
If all went well, you should have a new file named sasl_passwd.db in the /etc/postfix/sasl/ directory.

### Secure Your Postfix Hash Database and Email Password Files

The `/etc/postfix/sasl/sasl_passwd` and the `/etc/postfix/sasl/sasl_passwd.db` files created in the previous steps contain your SMTP credentials in plain text.

To restrict access to these files, change their permissions so that only the root user can read from or write to the file. Run the following commands to change the ownership to root and update the permissions for the two files:

    sudo chown root:root /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db
    sudo chmod 0600 /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db

### generate the CERT

```
mkdir /etc/postfix/ssl
cd /etc/postfix/ssl/
openssl genrsa -des3 -rand /etc/hosts -out smtpd.key 1024
chmod 600 smtpd.key
openssl req -new -key smtpd.key -out smtpd.csr
openssl x509 -req -days 3650 -in smtpd.csr -signkey smtpd.key -out smtpd.crt
openssl rsa -in smtpd.key -out smtpd.key.unencrypted
mv -f smtpd.key.unencrypted smtpd.key
openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650
```

Update `/etc/postfix/main.cf` with the following parameters:

```
# TLS parameters
#smtp_tls_CApath=/etc/postfix/ssl
smtpd_tls_CAfile=/etc/postfix/ssl/cacert.pem
smtpd_tls_cert_file=/etc/postfix/ssl/smtpd.crt
smtpd_tls_key_file=/etc/postfix/ssl/smtpd.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
tls_random_source = dev:/dev/urandom
```

### Configure the Postfix Relay Server

In this section, you will configure the `/etc/postfix/main.cf` file to use Gmail’s SMTP server.

1. Find and modify `relayhost` in `/etc/postfix/main.cf` to match the following example:

    relayhost = [smtp.gmail.com]:587
 
 2. At the end of the file, add the following parameters to enable authentication:
 
 ```
# Enable SASL authentication
smtp_sasl_auth_enable = yes
# Disallow methods that allow anonymous authentication
smtp_sasl_security_options = noanonymous
# Location of sasl_passwd
smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
# Enable STARTTLS encryption
smtp_tls_security_level = encrypt
# Location of CA certificates
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
```

3. Set the SSL cert that was generated in the last section:

```
# TLS parameters

smtpd_tls_CAfile=/etc/postfix/ssl/cacert.pem
smtpd_tls_cert_file=/etc/postfix/ssl/smtpd.crt
smtpd_tls_key_file=/etc/postfix/ssl/smtpd.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
tls_random_source = dev:/dev/urandom
```

4. Save your changes and close the file.

5. Restart Postfix:

    sudo systemctl restart postfix

