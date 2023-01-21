#!/bin/bash
# -*- coding: UTF8 -*-
#
# Copied from https://github.com/danyboy666/Generate-PSX-m3u-playlist/blob/master/generate_psx_m3u.sh 
# Modified by Christian Haitian
#
# Name : generate_psx_m3u.sh
# Usage : Copy script in working dir and execute.
# Simple script to generate an .m3u playlist file for every title found in the folder
# This will take care of multi disc as well as single disk.
#
# Copyright (C) 2018 Walter White - All Rights Reserved
# Permission to copy and modify is granted under the GNU GPL v3 license
#
# Modified by Rocky5
# cleanup, better screen logging & m3u placement.

directory="storage/roms"

# Clean previous m3u files
rm -f -v /$directory/psx/*.m3u > /dev/null
rm -f -v /$directory/psx/*/*.m3u > /dev/null
rm -f -v /$directory/psx/*.M3U > /dev/null
rm -f -v /$directory/psx/*/*.M3U > /dev/null
# Clear the screen
printf "\033c" >> /dev/tty1
# Process psx games in the root of the psx folder if they exist
printf "Processing files\n" >> /dev/tty1
sleep .5
cd /$directory/psx
if [ $(ls -1 *.cue 2>/dev/null | wc -l) != 0 ]
then
  for c in *.cue
  do
        title=$(echo "$c" | sed s'/.cue//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

        echo "$c" >> "$title".m3u
        printf "Added $title\n" >> /dev/tty1
  done
fi

if [ $(ls -1 *.chd 2>/dev/null | wc -l) != 0 ]
then
  for h in *.chd
  do
        title=$(echo "$h" | sed s'/.chd//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

        echo "$h" >> "$title".m3u
        printf "Added $title\n" >> /dev/tty1
  done
fi

if [ $(ls -1 *.CUE 2>/dev/null | wc -l) != 0 ]
then
  for c in *.CUE
  do
        title=$(echo "$c" | sed s'/.CUE//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

        echo "$c" >> "$title".m3u
        printf "Added $title\n" >> /dev/tty1
  done
fi

if [ $(ls -1 *.CHD 2>/dev/null | wc -l) != 0 ]
then
  for h in *.CHD
  do
        title=$(echo "$h" | sed s'/.CHD//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

        echo "$h" >> "$title".m3u
        printf "Added $title\n" >> /dev/tty1
  done
fi

# Process psx games in sub folders of the psx folder if they exist
printf "\nProcessing sub folders\n" >> /dev/tty1
sleep .5
for f in /$directory/psx/*/
do

 cd "$f"
 subdir=$(basename "$f")

 if [ $(ls -1 *.cue 2>/dev/null | wc -l) != 0 ]
 then
   printf "Added $subdir\n" >> /dev/tty1
   for c in *.cue
   do
         title=$(echo "$c" | sed s'/.cue//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

         echo "./$subdir/$c" >> "../$title".m3u
   done
 fi

 if [ $(ls -1 *.chd 2>/dev/null | wc -l) != 0 ]
 then
   printf "Added $subdir\n" >> /dev/tty1
    for h in *.chd
    do
         title=$(echo "$h" | sed s'/.chd//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

         echo "./$subdir/$h" >> "../$title".m3u
   done
 fi

 if [ $(ls -1 *.CUE 2>/dev/null | wc -l) != 0 ]
 then
   printf "Added $subdir\n" >> /dev/tty1
   for c in *.CUE
   do
         title=$(echo "$c" | sed s'/.CUE//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

         echo "./$subdir/$c" >> "../$title".m3u
   done
 fi

 if [ $(ls -1 *.CHD 2>/dev/null | wc -l) != 0 ]
 then
   printf "Added $subdir\n" >> /dev/tty1
   for h in *.CHD
   do
         title=$(echo "$h" | sed s'/.CHD//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

         echo "./$subdir/$h" >> "../$title".m3u
   done
 fi
done

# Clear the screen
printf "\033c" >> /dev/tty1

#choice hide extensions and subfolder

IFS=$'\n' listsort=($(sort <<<"${list[*]}")); unset IFS

text_viewer -w -y -t "Generation completed!" -m "\nWould you like to hide the other extensions and subfolders?\n\nGames detected: "$totf"\n\n ${listsort[*]}"
response=$?

case $response in

  0) ;;

  21) #hide subfolder

if  grep -q '<string name="psx.FolderViewMode" value=..*$' /storage/.config/emulationstation/es_settings.cfg

	then
         sed -i 's/	<string name="psx.FolderViewMode" value=..*$/	<string name="psx.FolderViewMode" value="never" \/>/g' /storage/.config/emulationstation/es_settings.cfg ; 
	else
         sed -i '/<\/config>/i \        \<string name="psx.FolderViewMode" value="never" \/>' /storage/.config/emulationstation/es_settings.cfg ; 
fi

#hide other extension

if  grep -q '<string name="psx.HiddenExt" value=..*$' /storage/.config/emulationstation/es_settings.cfg

	then
         sed -i 's/	<string name="psx.HiddenExt" value=..*$/	<string name="psx.HiddenExt" value="bin;cue;img;mdf;pbp;toc;cbn;ccd;chd;iso" \/>/g' /storage/.config/emulationstation/es_settings.cfg ; 
	else
         sed -i '/<\/config>/i \        \<string name="psx.HiddenExt" value="bin;cue;img;mdf;pbp;toc;cbn;ccd;chd;iso" \/>' /storage/.config/emulationstation/es_settings.cfg ; 
fi
     ;;

esac

# Print all m3u files that were created to the screen
printf "\nEmulationstation will now be restarted." >> /dev/tty1
sleep 3
printf "\033c" >> /dev/tty1
systemctl restart emulationstation
