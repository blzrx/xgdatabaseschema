# XG Database Schema


This is my work doing a database reversal using the newest XG firewall feature that lets you encrypt and decrypt your own backup using a user-defined password, the work here is doing a database "relationship" of object, these objects are referenced by the Firewall Software over the GUI or the CLI to configure the device, the database used is PostgreSQL, since is your own backup, you can do everything you want.

To decrypt your backup you need a Linux box with openssl and basic compression tools (tar).

#Decrypt:

openssl enc -d -aes-256-cbc -in inputfile -out decrypted.tgz -md md5 -pass pass:passwordthatyousetonthefirewall

#Decompress:

tar -xvzf decrypted.tgz

#Recompress: (you must compress the whole conf directory, if you dont, the backup will not work)

tar -zcvf encrypted.tgz conf/

#Encrypt:

openssl enc -aes-256-cbc -md md5 -in encrypted.tgz -out backup.conf


at this point openssl will ask for a password, be sure to remember this, since you will need it when you load the backup.conf on the appliance.
