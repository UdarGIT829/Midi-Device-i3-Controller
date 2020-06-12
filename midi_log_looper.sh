#!/bin/bash
# Do not run if no MIDI device detected
if ! aconnect -i | grep card; then
	echo "No device found"
else
    #Dump output of workspaces command to file if it doesnt exist. This will mess up if executed before all i3 workspaces are initialized
	FILE=./workspaces
	if [ ! -f "$FILE" ]; then
		i3-msg -t get_workspaces > workspaces
	fi
	    #Cleans "workspaces" output file to "clean_ws"
		python3 workspaces_cleanup.py
	#Display connected MIDI devices for user to easily correct
	IFS=$' '
	ports=$(aconnect -i | grep card)
	unset IFS
	#Assign MIDI device to port to use, I do not have another MIDI device so this will only work if the one you plan to you happens to be detected first
	portsArr=($ports)
	portAt=${portsArr[1]}

	# pre-chop file to make sure it doesnt auto run code
	tail -3 midi_buf | sponge midi_buf

	echo "Using: $portAt"
	function seq_dump() {
		aseqdump -p $1 >> midi_buf &
		P1=$!
		#echo "aseqdump pid=$P1"
	}
	seq_dump $portAt
	# Use inotifywait to wait for event, kinda CPU heavy but this is prefered over always just looping
	while inotifywait -q -q -e modify ./midi_buf
	do
		#Save the amount of lines in midi_buf
		num_lines=($(wc -l midi_buf))

		#Check if lines > 4, if true then kill the outputer to
		#	break the pipe, then strip the file to 30 lines
		# This will result in a log of the last 3 update notices
		# since "aseqdump" give 2 lines of non-update material when initialized
		if [[ $num_lines -gt "4" ]]
			then kill "$P1"; tail -3 midi_buf | sponge midi_buf;python3 log_cleanup.py;./system-controls.sh;seq_dump $portAt
		fi
	done
	# trap will be implemented properly in the future if necessary but the aseqdump does not persist on my system
	trap "kill $P1" SIGQUIT
fi