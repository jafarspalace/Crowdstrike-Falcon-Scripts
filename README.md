# Crowdstrike-Falcon-Scripts

Windows Powershell scripts to be run with Crowdstrike Falcon Real-Time Response. These scripts are intended to bring back only raw data, and to not parse any data locally on the host. This is intentional and the data can be parsed locally with whatever tools preferred.

These scripts look up the logged in user via explorer.exe process, since Falcon runs under "SystemProfile". 

These scripts also mount a Volume Shadow Copy of the local disk to copy from, to get around locked file issues when pulling certain files like Registry, Web History, etc.
