import subprocess
#   This file is executed from system-controls.sh
# workspaces file created in system-controls.sh
# Only needs to be run once or if workspace names change upon i3 configuration change
inFile = open("workspaces")
string_workspaces = inFile.read()
inFile.close()
clean_workspaces = list()
for x in range(0,len(string_workspaces)):
    if(string_workspaces[x] == "\""):
        if(string_workspaces[x+1].isdigit()):
            if(string_workspaces[x+2]==":"):
                temp = string_workspaces[x+1]
                temp += string_workspaces[x+2]
                temp += string_workspaces[x+3]
                clean_workspaces.append(temp)
                print(temp)
# Output to "clean_ws" for final workspace names
outfile = open("clean_ws", 'w')
for ws in clean_workspaces:
    outfile.write(ws)
    outfile.write(" ")