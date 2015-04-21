import sys
import os
import glob
def promedio(l, div):
	if(len(l)>1):
		return float(str(reduce(lambda q,p: float(str(p).replace(",",""))+float(str(q).replace(",","")), l)/float(div)).replace(",",""))
	else:
		return float(str(l[0]).replace(",",""))

files = glob.glob(os.getcwd()+"/*.data")
eventos = {}

for filename in sorted(files):
	if(len(sys.argv)<2):
		print "Error, debe ingresar como parametro el numero de repeticiones que incluyo la prueba"
		exit()
	repetitions = sys.argv[1]
	archivo = open(filename, 'r')
	threads = int(os.path.basename(archivo.name).split("_")[2])
	repetition = os.path.basename(archivo.name).split("_")[3].split(".")[0]

	for line in archivo:
		if "%" in line: 									# Es un registro de evento
			registro = line.split(" ")
			registro = filter(lambda x: x!="", registro)
			registro = registro[0:2]						#registro=[TotalApariciones, CodigoEvento]

			if registro[1] not in eventos:
				eventos[registro[1]] = {}
			if threads not in eventos[registro[1]]:
				eventos[registro[1]][threads] = []
			eventos[registro[1]][threads].append(registro[0].replace(".",""))
	archivo.close()

#Concentrar registros en caso de udpmultisocket
if len(os.path.basename(archivo.name).split("_")[4].split("."))>1:
	for contador in eventos:
		for thread in sorted(eventos[contador]):
			nuevaLista = []
			totalParcial = 0
			for k in range(1, 1+len(eventos[contador][thread])):
				totalParcial = totalParcial + int(eventos[contador][thread][k-1])
				if k%int(repetitions)==0:
					nuevaLista.append(totalParcial)
					totalParcial = 0
			eventos[contador][thread] = nuevaLista

import pprint
pprint.pprint(eventos, width=1)

#salida = open("FullResults.csv", "w+")
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
		actual.append(promedio(eventos[contador][thread], repetitions))
		actual.append(stddev(eventos[contador][thread], repetitions))
	summary.append(actual)

salida = open("SummaryResults.csv", "w+")
salida.write("\n\n")
for tupla in summary:
	for val in tupla:
		salida.write(str(val)+",")
	salida.write("\n")
salida.write("\n\n")
salida.close()