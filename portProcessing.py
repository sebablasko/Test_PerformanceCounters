import sys
import os
import glob

import pprint
eventos = {}


files = glob.glob(os.getcwd()+"/*.data")

for filename in sorted(files):

	#filename = sys.argv[1]
	archivo = open(filename, 'r')

	print os.path.basename(archivo.name)
	threads = archivo.name.split("_")[1]
	repetition = archivo.name.split("_")[2].split(".")[0]

	for line in archivo:
		if "%" in line:
			registro = line.split(" ")
			registro = filter(lambda x: x!="", registro)
			registro = registro[0:2]

			if registro[1] not in eventos:
				eventos[registro[1]] = {threads : [registro[0]]}
			else:
				eventos[registro[1]][threads].append(registro[0])

pprint.pprint(eventos, width=1)