import sys
import os
import glob
def promedio(l):
	return reduce(lambda q,p: float(p)+float(q), l)/len(l)

import pprint
eventos = {}


files = glob.glob(os.getcwd()+"/*.data")

for filename in sorted(files):

	#filename = sys.argv[1]
	archivo = open(filename, 'r')

	threads = os.path.basename(archivo.name).split("_")[1]
	repetition = os.path.basename(archivo.name).split("_")[2].split(".")[0]

	for line in archivo:
		if "%" in line:
			registro = line.split(" ")
			registro = filter(lambda x: x!="", registro)
			registro = registro[0:2]

			if registro[1] not in eventos:
				eventos[registro[1]] = {}
			if threads not in eventos[registro[1]]:
				eventos[registro[1]][threads] = []
			eventos[registro[1]][threads].append(registro[0].replace(",",""))
	archivo.close()

pprint.pprint(eventos, width=1)



salida = open("result.csv", "w+")
for contador in eventos:
	salida.write(contador+"\n")
	for thread in eventos[contador]:
		salida.write(thread+";")
		for val in :eventos[contador][thread]
			salida.write(eventos[contador][thread])
	salida.write("\n\n")
salida.close()
