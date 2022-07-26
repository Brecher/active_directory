<<<<<<< HEAD
# 01 Installing the Domain Controller

1. Use 'sconfig' to:
    - Change the hostname
    - Change the IP address to static
    - Change the DNS server to our own IP address

2. Install the  Active Directory Windows Feauture

```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

```
Get-NetIPAddress
```

# Joining workstation to the domain


```
AddComputer -Domainname COVEN.local -Credential COVEN\Admnistrator -Force -Restart
```
=======
# 01 Installing the Domain Controller

1. Use 'sconfig' to:
    - Change the hostname
    - Change the IP address to static
    - Change the DNS server to our own IP address

2. Install the  Active Directory Windows Feauture

```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

>>>>>>> 40076ed820b249eaaf8de90da4cc5d6b02313379
