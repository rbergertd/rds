#Building a new GPO, importing an existing configuration, and then linking it to the WVD Session Hosts OU.
$LDAPRoot = [ADSI]"LDAP://RootDSE"
$GPLinkTargetDomain = $LDAPRoot.Get("rootDomainNamingContext")
$URI = "http://github.com/rbergertd/rds/raw/master/grouppolicy/GPOBackup.zip"
$WVDOU = "WVD Session Hosts"
$GPLinkTarget = "ou=$WVDOU,"+($GPLinkTargetDomain)
#Create Directory
New-Item -ItemType "directory" -Path "C:\GPOBackup\"
#Download GPO backup folder
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -UseBasicparsing -Uri $URI -OutFile "C:\GPOBackup\GPOBackup.zip"
#Unarchive .zip file
Expand-Archive -LiteralPath C:\GPOBackup\GPOBackup.zip -DestinationPath C:\GPOBackup
#Create OU on Domain
New-ADOrganizationalUnit $WVDOU
#Create GPO, import policy backup, and link to Domain root.
new-gpo -name "ConfigureRDSGraphics" -Comment "Configure the appropriate GPO's for best graphic performance via RDP"
import-gpo -backupid E802E58D-C478-4AB6-8437-830DF35761AA -TargetName "ConfigureRDSGraphics" -Path C:\GPOBackup
new-gplink -name "ConfigureRDSGraphics" -Enforced Yes -LinkEnabled Yes -Target $GPLinkTarget  


#Building a new GPO, importing an existing configuration, and then linking it to the RDS Session Hosts OU.
$URI = "http://github.com/rbergertd/rds/raw/master/grouppolicy/GPOBackup.zip"
#Create Directory
New-Item -ItemType "directory" -Path "C:\GPOBackup\"
#Download GPO backup folder
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -UseBasicparsing -Uri $URI -OutFile "C:\GPOBackup\GPOBackup.zip"
#Unarchive .zip file
Expand-Archive -LiteralPath C:\GPOBackup\GPOBackup.zip -DestinationPath C:\GPOBackup
#Create OU on Domain
New-ADOrganizationalUnit "RDS Session Hosts"
#Create GPO, import policy backup, and link to Specific OU.
new-gpo -name "Configure RDS Graphics" -Comment "Configure the appropriate GPO's for best graphic performance via RDP" | new-gplink -target "ou=RDS Session Hosts,dc=rbdomain,dc=local" -LinkEnabled Yes
import-gpo -backupid E802E58D-C478-4AB6-8437-830DF35761AA -TargetName "Configure RDS Graphics" -Path C:\GPOBackup