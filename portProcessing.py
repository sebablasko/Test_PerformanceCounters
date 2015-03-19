import sys
import os
import glob
eventos = {}


files = glob.glob(os.getcwd()+"/*.data")

for filename in files:

	#filename = sys.argv[1]
	archivo = open(filename, 'r')

	threads = filename.split("_")[1]
	repetition = filename.split("_")[2]

	for line in archivo:
		if "%" in line:
			registro = line.split(" ")
			registro = filter(lambda x: x!="", registro)
			registro = registro[0:2]

			if registro[1] not in eventos:
				eventos[registro[1]] = {threads : [registro[0]]}

print eventos