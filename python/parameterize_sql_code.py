import os
import sys

file_path = sys.argv[1]

for directory, subdirlist, filelist in os.walk(file_path):
	print(directory)
	for f in filelist:
		print(f)
		with open(file_path+f) as file:
			data = file.read()
			data = data.replace(sys.argv[2], sys.argv[3])
			
		with open(file_path+f,'w') as file1:
			file1.write(data)



