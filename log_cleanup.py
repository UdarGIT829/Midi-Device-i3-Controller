#Use reqex for removal of colon, as it seems the most atomic solution
import re
inputLogFile = open("midi_buf",'r')
inputLines = list()
for line in inputLogFile:
    inputLines.append(line)
inputLogFile.close

junkLines = list()
for line in inputLines:
    if line == "Waiting for data. Press Ctrl+C to end.\n":
        #inputLines.remove(line)
        junkLines.append(line)
    if line == "Source  Event                  Ch  Data\n":
        #inputLines.remove(line)
        junkLines.append(line)

for line in junkLines:
    inputLines.remove(line)

latestState = str(inputLines)
latestState_list = latestState.split()
#Want index 2, 6
stateType,number,value = latestState_list[2], latestState_list[6].replace(",",""), re.sub('[^a-zA-Z0-9 \n\.]', '', latestState_list[8]).replace("n","")

outstate = stateType + ' ' + number + ' ' + value + ' '
outputLogFile = open("new_midi_buf", 'w')
outputLogFile.write(outstate)
#response = str(subprocess.run("i3-msg -t get_workspaces", shell=True, check=True, encoding="utf-8",stderr=subprocess.STDOUT))
