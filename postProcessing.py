import sys
import os
import glob
def promedio(l, div):
	if(len(l)>1):
		return float(str(reduce(lambda q,p: float(str(p).replace(",",""))+float(str(q).replace(",","")), l)/float(div)).replace(",",""))
	else:
		return float(str(l[0]).replace(",",""))

def getDataFileName(archivo):
	return os.path.basename(archivo.name).split("_")[4].split(".")[1]

def getThreadsInDataFileName(archivo):
	return int(os.path.basename(archivo.name).split("_")[2])

def getRepetitionInDataFileName(archivo):
	return int(os.path.basename(archivo.name).split("_")[3].split(".")[0])

diccionarioEventos = {}

files = glob.glob(os.getcwd()+"/*.data")
for filename in sorted(files):
	if(len(sys.argv)<2):
		print "Error, debe ingresar como parametro el numero de repeticiones que incluyo la prueba"
		exit()

	repetitions = sys.argv[1]
	archivo = open(filename, 'r')
	print "processing: "+archivo.name
	threads = getThreadsInDataFileName(archivo)
	repetition = getRepetitionInDataFileName(archivo)

	for line in archivo:
		if "%" in line: 											# Es un registro de evento
			registro = filter(lambda x: x!="", line.split(" "))		# Elimino elementos vacios de la lista
			registro = registro[0:2]								# registro=[TotalApariciones, CodigoEvento]
			registro[0] = int(registro[0].replace(",",""))

			if registro[1] not in diccionarioEventos:
				diccionarioEventos[registro[1]] = {}
			if threads not in diccionarioEventos[registro[1]]:
				diccionarioEventos[registro[1]][threads] = []
			diccionarioEventos[registro[1]][threads].append(registro[0])
	archivo.close()

#import pprint
#pprint.pprint(diccionarioEventos, width=1)

#Concentrar registros en caso de udpmultisocket
if len(os.path.basename(archivo.name).split("_")[4].split("."))>1:
	print "es multisockets"
	for contador in diccionarioEventos:
		for threadsTested in diccionarioEventos[contador]:
			listaNueva = []
			total = 0
			for k in range(len(diccionarioEventos[contador][threadsTested])):
				total = total + diccionarioEventos[contador][threadsTested][k]
				if(k+1)%threadsTested==0:
					listaNueva.append(total)
					total = 0
			diccionarioEventos[contador][threadsTested] = listaNueva
	#pprint.pprint(diccionarioEventos, width=1)


#Hasta aca vamos!

salida = open("FullResults.csv", "w+")
for contador in diccionarioEventos:
	salida.write(contador+"\n")
	for thread in sorted(diccionarioEventos[contador]):
		salida.write(str(thread)+";")
		for val in diccionarioEventos[contador][thread]:
			salida.write(val+";")
		salida.write("\n")
	salida.write("\n\n")
salida.close()


summary = []
for contador in diccionarioEventos:
	actual = [contador]
	for thread in sorted(diccionarioEventos[contador]):
		actual.append(promedio(diccionarioEventos[contador][thread], repetitions))
		actual.append(stddev(diccionarioEventos[contador][thread], repetitions))
	summary.append(actual)

salida = open("SummaryResults.csv", "w+")
salida.write("\n\n")
for tupla in summary:
	for val in tupla:
		salida.write(str(val)+",")
	salida.write("\n")
salida.write("\n\n")
salida.close()