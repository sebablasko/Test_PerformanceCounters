import sys
import os
import glob
import numpy

# Colecta (reune) los distintos resultados de Threads y repeticiones en un unico JSON que contiene los datos del promedio y desviacion estandar para cada prueba de Threads/Sockets

def getTestNameInDataFileName(archivo):
	return archivo.split("_")[1]

def getThreadsInDataFileName(archivo):
	return int(os.path.basename(archivo.name).split("_")[2][0:3])

def getRepetitionInDataFileName(archivo):
	return int(os.path.basename(archivo.name).split("_")[3].split(".")[0][0:3])

def promedio(lista):
	lista = map(lambda x: 0 if type(x) is str else x, lista)
	return numpy.average(lista)

def desviacion(lista):
	lista = map(lambda x: 0 if type(x) is str else x, lista)
	return numpy.std(lista)



# Ingresar datos a estrucutra de diccionario

diccionarioEventos = {}

if(len(sys.argv)<2):
	print "Error. Uso: ./postProcessing.py patronArchivosAProcesar"
	exit()

filePattern = sys.argv[1]
files = glob.glob(os.getcwd()+"/*"+filePattern+"*")
files = filter(lambda x: "p.data" not in x, files)

for filename in sorted(files):
	archivo = open(filename, 'r')
	print "Procesando: " + archivo.name
	threads = getThreadsInDataFileName(archivo)
	repetition = getRepetitionInDataFileName(archivo)
	
	# Salto las lineas de especificacion de perf record
	for x in range(5):
		next(archivo)

	for line in archivo:
		# Leo hasta que se termine el listado de datos
		if line == "\n":
			break

		registro = filter(lambda x: x!="", line.split("  "))
		
		try:
			registro[0] = int(registro[0].replace(".",""))
		except ValueError:
			registro[0] = "NC"

		# Hasta aqui: registro = [CantidadContada, CodigoEvento, %]

		# Agregar al diccionario de eventos
		if registro[1] not in diccionarioEventos:
			diccionarioEventos[registro[1]] = {}
		if threads not in diccionarioEventos[registro[1]]:
			diccionarioEventos[registro[1]][threads] = []
		diccionarioEventos[registro[1]][threads].append(registro[0])
	archivo.close()

#import pprint
#pprint.pprint(diccionarioEventos, width=1)



# Generar diccionario procesado a partir del diccionario de datos

diccionarioProcesado = {}
for evento in sorted(diccionarioEventos):
	if evento not in diccionarioProcesado:
		diccionarioProcesado[evento] = {}
	for thread in sorted(diccionarioEventos[evento]):
		diccionarioProcesado[evento][thread] = (promedio(diccionarioEventos[evento][thread]), desviacion(diccionarioEventos[evento][thread]))

#import pprint
#pprint.pprint(diccionarioProcesado, width=1)


import json
outputFilename = getTestNameInDataFileName(filePattern) + "_summary.JSON"
json.dump(diccionarioProcesado, open(outputFilename ,'w'))
print "Generado: " + outputFilename