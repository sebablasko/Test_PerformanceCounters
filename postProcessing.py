import sys
import os
import glob
def promedio(l):
	return reduce(lambda q,p: float(p.replace(",",""))+float(q.replace(",","")), l)/len(l)

eventos = {}

files = glob.glob(os.getcwd()+"/*.data")

for filename in sorted(files):

	#filename = sys.argv[1]
	archivo = open(filename, 'r')

	threads = int(os.path.basename(archivo.name).split("_")[2])
	repetition = os.path.basename(archivo.name).split("_")[3].split(".")[0]

	for line in archivo:
		if "%" in line:
			registro = line.split(" ")
			registro = filter(lambda x: x!="", registro)
			registro = registro[0:2]

			if registro[1] not in eventos:
				eventos[registro[1]] = {}
			if threads not in eventos[registro[1]]:
				eventos[registro[1]][threads] = []
			eventos[registro[1]][threads].append(registro[0].replace(".",""))
	archivo.close()

#import pprint
#pprint.pprint(eventos, width=1)

salida = open("FullResults.csv", "w+")
for contador in eventos:
	salida.write(contador+"\n")
	for thread in sorted(eventos[contador]):
		salida.write(str(thread)+";")
		for val in eventos[contador][thread]:
			salida.write(val+";")
		salida.write("\n")
	salida.write("\n\n")
salida.close()


summary = []
for contador in eventos:
	actual = [contador]
	for thread in sorted(eventos[contador]):
		actual.append(promedio(eventos[contador][thread]))
	summary.append(actual)

salida = open("SummaryResults.csv", "w+")
salida.write("\n\n")
for tupla in summary:
	for val in tupla:
		salida.write(str(val)+",")
	salida.write("\n")
salida.write("\n\n")
salida.close()