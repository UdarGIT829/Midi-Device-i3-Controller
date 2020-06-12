# Midi Device i3 Controller
This is a program meant to use Linux's MIDI capabilities, to map system controls to the various hardware components on a MIDI device. 

## Purpose
I have been using Linux operating systems since graduating High School and I immediately fell in love with the freedom to control my computer experience.
 During my time in grade school I was also interested in music, particularly in electronic music and production. After purchasing my first MIDI device and discovering that 
 even the best computers that I had access to at home could not run the software I wanted to use to make music, I gave up on trying to make music.




A handful of years later, nearing the close of my time in University I was cleaning my room and dusted off my old "AKAI MPK mini", it was the MIDI controller I had bought so
 long ago. I had dreamed for a long time of using my old MIDI devices to control my computer in various clever ways, this time however I decided I would learn whatever
 it took to make that dream come true. After experimenting with device files that detect input I eventually found that Linux's MIDI system was very responsive and easy
 to digest, as it was served in text form through the command line. 




After testing every button on my device and taking note of the output on my computer, I set out to write some scripts to interpret this information and run commands
 based on the outputs of my MIDI device.
---
## Process
The first issue I had to overcome was that the command I used to display MIDI information displayed every new state change detected. To be clear; when a note(or drumpad) 
 is pressed and depressed two events are displayed respectively, and when a dial is turned each new value is displayed (potentially spanning from 0-127). The issue here
 is that if the command is outputted to a log file, the log will increase in size infinitely taking up far too much space, so my intention was to only keep the most recent
 state change. I accomplished this using the python script "log_cleanup.py".




The next issue I had to overcome was to interpret the most recent MIDI state and respond with a command if necessary, as not all notes and dials will be mapped to a system control.
 This was not difficult, as I used arrays in bash to categorize the state as a note or control(the MIDI term for a dial), the note/control number, and the value of the control(as I was only detecting depresses of notes).
 Once I had an idea of the most easily accessible drumpads and dials I assigned volume, brightness, and i3 workspaces to these controls. 
 I accomplished this in the bash script "system-controls.sh", and handled information digestion about i3 workspaces in the python script "workspaces_cleanup.py".





The final issue to overcome was making sure that my system of scripts would run when a MIDI input was detected. For this I used a library called 'inotifywait', this is a program
 that waits for a defined event allowing for loops that do not eat up system resources until the event is detected. Additionally I would use this loop to execute the scripts
 that I had written upon a change to the file that would recieve any new MIDI state. This culminated in the bash script "midi_log_looper.sh".
---
## Conclusion
As I made this program originally for personal use, after much exasperation of searching on the internet for help and guidance I decided that I would make this program available
 to the public under an opensource licence. The only changed I plan on making to this program would be adding new controls to the hardware dials on my current MIDI device, however
 because this program was successful I plan on purchasing a used MIDI device to assign more complicated controls. One idea I had was to use commands to guide a mouse cursor
 along various curves for graphic art purposes, and another idea was to control variables of a complex mathematics visualization program like an oscillator.




I hope you can find some use from this program, especially if you were feeling some buyer's remorse after seeing your musical equipment that you wouldn't use otherwise. If not
 I would offer you this advice, we live in an electronic world and Linux is so widely used in industries so any device that can connect to your computer can probably become 
 an extension of the device controls we are so accustomed to today such as trackpads, keyboards, even joysticks.
