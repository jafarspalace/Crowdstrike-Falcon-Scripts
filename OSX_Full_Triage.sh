#!/bin/zsh
set -x #echo on

#Find currently logged in User
var=$(users)

#making initial files and directories
mkdir /Users/$var/.FalconCollect
mkdir /Users/$var/.FalconCollect/Collection
chmod 777 /Users/$var/.FalconCollect
chmod 777 /Users/$var/.FalconCollect/Collection

#bash history for user
touch /Users/$var/.FalconCollect/Collection/bash_history.txt
cat /Users/$var/.zsh_history > /Users/$var/.FalconCollect/Collection/bash_history.txt

# Simple expect to get the return for sysdiagnose to run - run without footprint
expect <<- DONE
  set timeout -1
  spawn sysdiagnose -b -q -f /Users/$var/.FalconCollect/Collection

  # Look for  prompt
  expect "*?ontinue*"
  # send blank line (\r) to make sure we get back to gui
  send -- "\r"
  expect eof
DONE

#collect 7 days worth of logs and compressed
#sudo log collect --last 7d --output /Users/$var/.FalconCollect/Collection

#Copy LaunchAgent and LauncDaemons Plists

#Copy KnowledgeC.db and interaction.db
zip -q -1 -r /Users/$var/.FalconCollect/Collection/knowledgedb.zip /Users/$var/Library/Application\ Support/Knowledge/knowledgeC.db /Users/$var/Library/Application\ Support/Knowledge/knowledgeC.db-shm /Users/$var/Library/Application\ Support/Knowledge/knowledgeC.db-wal
zip -q -1 -r /Users/$var/.FalconCollect/Collection/interactiondb.zip /private/var/db/CoreDuet/People/interactionC.db /private/var/db/CoreDuet/People/interactionC.db-shm /private/var/db/CoreDuet/People/interactionC.db-wal

#URL History for Google Chrome - need to do Firefox and Safari
zip -q -1 -r /Users/$var/.FalconCollect/Collection/urlhistory.zip /Users/$var/Library/Application\ Support/Google/Chrome/Default/History /Users/$var/Library/Application\ Support/Google/Chrome/Default/History-journal /Users/$var/Library/Application\ Support/Google/Chrome/Default/Current\ Session /Users/$var/Library/Application\ Support/Google/Chrome/Default/Current Tabs

#copy fsevents
sudo cp -r /.fseventsd /Users/$var/.FalconCollect/Collection
sudo cp -r /System/Volumes/Data/.fseventsd /Users/$var/.FalconCollect/Collection/.fseventsd_system_volume_data
sudo chmod 777 /Users/$var/.FalconCollect/Collection/.fseventsd
sudo chmod 777 /Users/$var/.FalconCollect/Collection/.fseventsd_system_volume_data

#additional for insider related - neeed to add more!
zip -q -1 -r /Users/$var/.FalconCollect/Collection/cloudquicklookdb.zip /Users/$var/Library/Application\ Support/Quick\ Look/cloudthumbnails.db /Users/$var/Library/Application\ Support/Quick\ Look/cloudthumbnails.db-wal /Users/$var/Library/Application\ Support/Quick\ Look/cloudthumbnails.db-shm
zip -q -1 -r /Users/$var/.FalconCollect/Collection/zoomdb.zip /Users/$var/Library/Application\ Support/zoom.us/
sudo cp /Users/rjafarkhani/Library/Preferences/MobileMeAccounts.plist /Users/$var/.FalconCollect/Collection/MobileMeAccounts.plist
sudo cp -r /Users/rjafarkhani/Library/Messages/ /Users/$var/.FalconCollect/Collection/Chat
sudo chmod 777 /Users/$var/.FalconCollect/Collection/Chat

#gather everything together and best compression - can see if the time trade off is really worth it
zip -q -9 -r /Users/$var/.FalconCollect/LightTriageCollection.zip /Users/$var/.FalconCollect/Collection/

#Change permmissions so we can remove stuff without prompts
sudo chmod -R 777 /Users/$var/.FalconCollect/Collection

#clean up
rm -r /Users/$var/.FalconCollect/Collection
