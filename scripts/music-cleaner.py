#!/bin/python3

import os

os.chdir('/home/mahalo/Downloads/VideoDownloader')
og_names =(os.listdir())

for n in og_names:
    file_name, extension = os.path.splitext(n)
    final_format=''
    
    if "(" in  str(file_name):
        start_of_segment=(file_name.index('('))
        
        formated= file_name[0:start_of_segment]
        final_format=(formated + extension) 
        os.rename(n, final_format)     

    elif "[" in  str(file_name): 
        start_of_segment=(file_name.index('['))

        formated= file_name[0:start_of_segment]
        final_format=(formated + extension) 
        os.rename(n, final_format)     


    elif "{" in  str(file_name): 
        start_of_segment=(file_name.index('{'))

        formated= file_name[0:start_of_segment]
        final_format=(formated + extension) 
        os.rename(n, final_format)     

print("Working on" , os.getcwd())
print("All Done")

