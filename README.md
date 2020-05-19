# Crowdstrike-Falcon-Scripts

Windows Powershell scripts to be run with Crowdstrike Falcon Real-Time Response. These scripts are intended to bring back only raw data, and not to parse any data locally on the host. This is intentional. The data can be parsed on a forensics system with whatever tools preferred.

Some scripts look up the logged in user via explorer.exe process (where necessary), since Falcon runs under "SystemProfile". 

Some scripts also mount a Volume Shadow Copy of the local disk to copy from, to get around locked file issues when pulling certain files like Registry, Web History, etc.
