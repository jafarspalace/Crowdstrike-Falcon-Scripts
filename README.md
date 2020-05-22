# Crowdstrike Falcon Live Response Scripts

A Series of Windows Powershell scripts to be run with Crowdstrike Falcon Real-Time Response. These scripts are intended to bring back only raw data, and not to parse any data locally on the host. This is intentional. The data can be pulled back and parsed on a forensics system with whatever tools preferred.

Some scripts look up the logged in user via explorer.exe process (where necessary), since Falcon runs under "SystemProfile". 

Scripts leverage mounting a Volume Shadow Copy of the local harddisk to get around locked file issues associated to system files such as the registry.

Credit to Jesse Davis (@secabstraction) for the creation of Export-MFT for exporting out the raw MFT via powershell. This saved me a bunch of time. I have included his script in fulltriage.ps1. The output path can be changed to place the MFT output into a path of your choosing.

To run FullTriage.ps1 on Falcon:
runscript -CloudFile="RunTriage" -CommandLine="RunTriage ; Triage-Nomft ; Export-MFT"

All other scripts you can run without passing any arguments.

Use at your own risk. I'm not responsible for any mishaps that occur.
