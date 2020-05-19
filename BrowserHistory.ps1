<# Create Collections Directory if not exist - Change this to what you want #>
New-Item -Force $Env:SystemDrive\Collections\WebHistory -ItemType Directory

<# Create shadow copy link, and if the link already exists, remove it, and then try again #>
$temp_shadow_link = "C:\shadowcopy1234123"
$s1 = (Get-WmiObject -List Win32_ShadowCopy).Create("C:\", "ClientAccessible")
$s2 = Get-WmiObject Win32_ShadowCopy | Where-Object { $_.ID -eq $s1.ShadowID }
$d  = $s2.DeviceObject + "\"

if (Test-Path $temp_shadow_link) {
    echo "SHADOW COPY LINK ALREADY EXISTS, DELETING"
    cmd /c rmdir $temp_shadow_link
}

echo "CREATING SHADOW LINK TO COPY FILES FROM"
cmd /c mklink /d $temp_shadow_link $d

<# Find current logged in user. Default is systemprofile #>
$User = tasklist /v /FI "IMAGENAME eq explorer.exe" /FO list | find "User Name:"
$User = $User.Substring(14)
$pos = $User.IndexOf("\")
$leftPart = $User.Substring(0, $pos)
$userextract = $User.Substring($pos+1)
echo "$userextract is the currently logged in user"

<# Collect the things. Edit as you like. This is collecting Firfox, Chromem, and IE #>
$path1 = Get-ChildItem -Path "$temp_shadow_link\Users\$userextract\AppData\Local\Microsoft\Windows\Webcache\*\WebCacheV01.dat" -Force -Recurse -EA SilentlyContinue
$path2 = Get-ChildItem -Path "$temp_shadow_link\Users\$userextract\AppData\Local\Google\Chrome\User Data\Default\*\History" -Recurse -EA SilentlyContinue
$path3 = Get-ChildItem -Path "$temp_shadow_link\Users\$userextract\AppData\Local\Google\Chrome\User Data\Default\*\History-journal" -Recurse -EA SilentlyContinue
$path4 = Get-ChildItem -Path "$temp_shadow_link\Users\$userextract\AppData\Roaming\Mozilla\Firefox\Profiles\*\places.sqlite" -Recurse -EA SilentlyContinue
$path5 = Get-ChildItem -Path "$temp_shadow_link\Users\$userextract\AppData\Roaming\Mozilla\Firefox\Profiles\*\places.sqlite-shm" -Recurse -EA SilentlyContinue
$path6 = Get-ChildItem -Path "$temp_shadow_link\Users\$userextract\AppData\Roaming\Mozilla\Firefox\Profiles\*\places.sqlite-wal" -Recurse -EA SilentlyContinue

Copy-Item "$path1" -Destination "$Env:systemdrive\Collections\WebHistory"
Copy-Item "$path2" -Destination "$Env:systemdrive\Collections\WebHistory"
Copy-Item "$path3" -Destination "$Env:systemdrive\Collections\WebHistory"
Copy-Item "$path4" -Destination "$Env:systemdrive\Collections\WebHistory"
Copy-Item "$path5" -Destination "$Env:systemdrive\Collections\WebHistory"
Copy-Item "$path6" -Destination "$Env:systemdrive\Collections\WebHistory"

<# CLean up and remove the VSS link #>
echo "DELETING SNAPSHOT AND THE LINK TO IT (#CLEANUP), LOOKS LIKE EVERYTHING FINISHED"
$s2.Delete()
cmd /c rmdir $temp_shadow_link
