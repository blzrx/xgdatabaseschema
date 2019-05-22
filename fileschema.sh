There are some files under a structure that the device uses to restore the configuration, instead of using plain text commands like the 90% of the networking devices out there the backup uses scripts and files that helps to restore the configuration to certain point.

the main folder is /conf/ which has inside the /backupdata/ folder, this one holds the folder called /device.backup/ which holds the files used to the configuration restoration.

The whole directory structure goes like this:

├── conf
│   └── backupdata
│       └── device.backup
│           ├── app_series
│           ├── cccversion
│           ├── conf
│           │   ├── certificate
│           │   │   ├── aacerts
│           │   │   ├── ApplianceCertificate.pem
│           │   │   ├── cacerts
│           │   │   │   └── <A ton of certificates that i will snip to mantain this readable>
│           │   │   ├── caprivate
│           │   │   │   ├── Default.key
│           │   │   │   ├── SecurityAppliance_SSL_CA_decrypted.key
│           │   │   │   └── SecurityAppliance_SSL_CA.key
│           │   │   ├── certs
│           │   │   ├── client
│           │   │   ├── crls
│           │   │   │   ├── <Nothing interesting to see here>
│           │   │   ├── csrs
│           │   │   ├── index.txt
│           │   │   ├── internalcas
│           │   │   │   ├── <Nothing interesting to see here>
│           │   │   ├── internalcerts
│           │   │   │   ├── <Nothing interesting to see here>
│           │   │   ├── licensing
│           │   │   │   ├── <Another lot of PEM and KEY files>
│           │   │   ├── ocspcerts
│           │   │   ├── old_ca_list
│           │   │   ├── openvpn
│           │   │   │   ├── <Nothing interesting to see here, there are the certs for the ssl vpn>
│           │   │   ├── private
│           │   │   │   ├── <Nothing interesting to see here>
│           │   │   ├── serial
│           │   │   ├── sslvpn
│           │   │   │   ├── AAM
│           │   │   │   │   ├── CA.pem
│           │   │   │   │   └── crssl.p12
│           │   │   │   └── keys
│           │   │   │       └── dh1024.pem
│           │   │   ├── tmclient.pem
│           │   │   └── u2dclient.pem
│           │   ├── httpclient
│           │   │   ├── customizeimages
│           │   │   │   └── default
│           │   │   │       ├── <Image files used by the frontend to display error messages>
│           │   │   └── deniedmessage
│           │   │       ├── <A ton of symlinks for messages displayed by the device>
│           │   ├── iview_images
│           │   │   ├── custom
│           │   │   └── default
│           │   │       └── logo.png
│           │   └── sysfiles
│           │       ├── heartbeatd
│           │       │   ├── c<Nothing interesting to see here>
│           │       ├── spx
│           │       │   ├── db
│           │       │   │   ├── <Some stores>
│           │       │   ├── template
│           │       │   │   ├── <Some SPX templates>
│           │       │   └── template_mta
│           │       │       ├── <Same as above but for MTA>
│           │       └── waf
│           │           ├── assets
│           │           │   └── Default Template
│           │           │       └── default_stylesheet.css
│           │           └── template
│           │               └── Default Template
│           │                   └── default_template.html
│           ├── copernicus
│           ├── db.dump
│           ├── db.dump_pre
│           ├── displayversion
│           ├── fullsyncsupported
│           ├── fwversion
│           ├── interfacelist
│           ├── interfacelistsequence
│           ├── ips_cat_corp_ver
│           ├── noofinterfaces
│           ├── same_appliance
│           └── version

Aside a few files, the interesting one or at least the one who holds the configuration itself is the db.dump file, which is used to recreate the tables that hold the configuration for the device.

This is a normal PSQL dump, it holds the data for like 405 tables used by the firewall to compose the configuration, there are a preparation script called db.dump_pre which prepares the whole database with some pre-requisites to restore the backup.

