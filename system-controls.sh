#!/bin/bash
    #Input from the file into an array of usable workspace names
    #Uses both alsa and pulse
while read line; do echo $line; done < ./clean_ws
ws_array=($line)
#echo ${ws_array[1]}
    #Call them like this
while read state; do echo $state; done < ./new_midi_buf
state_array=($state)
#Check state type
    #If Control change
if [ "${state_array[0]}" == "Control" ]; then
    #Use dial 4 to control brightness
    if [ "${state_array[1]}" == "4" ]; then
        num=${state_array[2]}
        Bquotient=$( bc <<< "scale=2;$num/127" )
        #Outputting to LVDS-1 of my thinkpad's default display
        xrandr --output LVDS-1 --brightness $Bquotient
        echo -ne "Brightness: $Bquotient                                                                                 "\\r
    fi
    #Use dial 8 to control volume
    if [ "${state_array[1]}" == "8" ]; then
        num=${state_array[2]}
        product=$(( num*100 ))
        quotient=$( bc <<< "$product/127" )
        amixer -q -D pulse sset Master $quotient%
        echo -ne "echo "$(amixer -D pulse get Master| grep %)""\\r|tr '\n' '\t'
    fi
fi
    #If Note played, Note released is always 127 velocity
if [ "${state_array[0]}" == "Note" ]; then
    if [ "${state_array[2]}" == "127" ]; then
        #Check which note played, drum pads are: 45, 46, 47, 48, 49, 50, 51, 52
            #Deals with workspace changing
        if [ "${state_array[1]}" == "45" ]; then
            i3-msg workspace -q ${ws_array[0]}
        fi
        if [ "${state_array[1]}" == "46" ]; then
            i3-msg workspace -q ${ws_array[1]}
        fi
        if [ "${state_array[1]}" == "47" ]; then
            i3-msg workspace -q ${ws_array[2]}
        fi
        if [ "${state_array[1]}" == "48" ]; then
            i3-msg workspace -q ${ws_array[3]}
        fi
        if [ "${state_array[1]}" == "49" ]; then
            i3-msg workspace -q ${ws_array[4]}
        fi
        if [ "${state_array[1]}" == "50" ]; then
            i3-msg workspace -q ${ws_array[5]}
        fi
        if [ "${state_array[1]}" == "51" ]; then
            i3-msg workspace -q ${ws_array[6]}
        fi
            #Deals with marking, unmarking and marked windows; Pad bank 2 has different notes which are used here
        if [ "${state_array[1]}" == "52" ]; then
            i3-msg [con_mark="Marked"] focus
        fi
        if [ "${state_array[1]}" == "43" ]; then
            i3-msg mark Marked
        fi
        if [ "${state_array[1]}" == "39" ]; then
            i3-msg unmark Marked
        fi
    fi
fi