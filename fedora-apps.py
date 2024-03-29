#!/bin/python3

import re
import subprocess
import os 

dir = os.getcwd()
# gets list of installed programs from dnf 
subprocess.run('dnf repoquery --userinstalled > manully_dnf.txt', shell=True)
#from flatpak
flat =subprocess.run('flatpak list --app | cut -f 1', shell=True, capture_output=True,text=True)


# (.*?)-\d+
pattern = re.compile(r'([a-z]+)+[-\D]+')

list_f =[]
formated_list= []

with open('manully_dnf.txt','r', encoding='UTF-8') as f:
    
    # It gives an error with f36-background expression      
    for line in f:
        match= pattern.match(line)
        try:
            if match.group(0) not in list_f:
                list_f.append(match.group(0))
        except Exception:    
            pass
# removing the - at the end of match from fail regex
for programs in list_f:
    if programs.endswith('-'):
        formated_list.append(programs[:-1])
    else:
        formated_list.append(programs)

with open('data.txt','w+') as output:
    for i in formated_list:
        output.write(i + '\n')

#apending flatpak
with open('data.txt','a') as output:
    output.write('####### Flatpak #########\n')
    output.write(flat.stdout)

#opens the final file 
with open('data.txt','r') as o:
    print(o.read())

# data.txt file will remain in directory 

#removes output of dnf check 
if os.path.exists('manully_dnf.txt'):
    os.remove(dir + '/manully_dnf.txt')
