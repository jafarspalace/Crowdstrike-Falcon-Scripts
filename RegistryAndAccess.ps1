<# Create Collections Directory if not exist - Change this to what you want #>
New-Item -Force $Env:SystemDrive\Collections\RegistryandRecentAccess -ItemType Directory
New-Item -Force $Env:SystemDrive\Collections\RegistryandRecentAccess\JumpList -ItemType Directory

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

<# Collect the things. edit as you like. This is collecting Jumplist, Registry, AmCache, etc#>
$path1 = "$temp_shadow_link\Windows\System32\config"
$path2 = "$temp_shadow_link\Users\$userextract\AppData\Local\Microsoft\Windows"
$path3 = "$temp_shadow_link\Windows\appcompat\Programs"
$path4 = "$temp_shadow_link\Users\$userextract"
$Path5 = "$temp_shadow_link\Users\$userextract\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations"
$Path6 = "$temp_shadow_link\Users\$userextract\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations"

Copy-Item -Path "$path1\SYSTEM" -Destination "$Env:systemdrive\Collections\RegistryandRecentAccess"
Copy-Item -Path "$path1\SOFTWARE" -Destination "$Env:systemdrive\Collections\RegistryandRecentAccess"
Copy-Item -Path "$path4\NTUSER.DAT" -Destination "$Env:systemdrive\Collections\RegistryandRecentAccess"
Copy-Item -Path "$path2\UsrClass.dat" -Destination "$Env:systemdrive\Collections\RegistryandRecentAccess"
Copy-Item -Path "$path3\Amcache.hve" -Destination "$Env:systemdrive\Collections\RegistryandRecentAccess"
Copy-Item -Path "$path5" -Destination "$Env:systemdrive\Collections\RegistryandRecentAccess\JumpList" -Recurse
Copy-Item -Path "$path6" -Destination "$Env:systemdrive\Collections\RegistryandRecentAccess\JumpList" -Recurse

<# Clean up and remove the VSS Link #>
echo "DELETING SNAPSHOT AND THE LINK TO IT, LOOKS LIKE EVERYTHING FINISHED"
$s2.Delete()
cmd /c rmdir $temp_shadow_link