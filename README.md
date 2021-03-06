## Crowdstrike Falcon Live Response Scripts

 Windows Powershell script to be run with Crowdstrike Falcon Real-Time Response. Script is intended to bring back only raw data, and not to parse any data locally on the host. This is intentional. The data can be pulled back and parsed on a forensics system with whatever tools preferred.

Script looks up the logged in user via explorer.exe process (where necessary), since Falcon runs under "SystemProfile". 

Script leverages mounting a Volume Shadow Copy of the local harddisk to get around locked file issues associated to system files such as the registry.

This is still a work in progress and there are numerous other forensic artifacts that can be collected. Feel free to add.

Credit to Jesse Davis (@secabstraction) for the creation of Export-MFT for exporting out the raw MFT via powershell. This saved me a bunch of time. I have included his script in fulltriage.ps1. The output path can be changed to place the MFT output into a path of your choosing. Link to original Export-MFT https://gist.github.com/secabstraction/4044f4aadd3ef21f0ca9

### To run FullTriage.ps1 on Falcon:
```
runscript -CloudFile="RunTriage" -CommandLine="RunTriage ; Triage-Nomft ; Export-MFT"
```
To run only one fuction at a time, Just pass only one of the functions. You would do this if you did not want to export the MFT for example.


FullTriage.ps1 will also compress everything into ```C:\Collections\FullCollection.zip``` and remove all other files.

You will then need to pull these files back manually as usual.

Use at your own risk. I'm not responsible for any mishaps that occur.

Future Consideration will be to maybe create additional functions to make this run more modular, but doesn't really seem necessary at the moment.
