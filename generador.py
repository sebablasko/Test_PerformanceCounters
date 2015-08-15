import json
import sys
import os
import textwrap
import numpy as np
import matplotlib.pyplot as plt

# Genera los archivos fuente para producir los graficos con GNUPlot, para ello, lee los archivos JSON disponibles generados en el colector.py y guarda los resultados en la carpeta plots

if(len(sys.argv)<2):
	print "Error. Uso: ./generador.py archivosAUnir"
	exit()

archivos = sys.argv[1:]
listadoPruebas = map(lambda x: x.split("_")[0], archivos)

print archivos

# Retorna un diccionario con el resumen de los datos de un determinado evento (Promedio y desviacion para cada prueba para cada eval de Threads.)
def getSummaryDataOfEvent(datos, evento):
	ret = {}
	for prueba in listadoPruebas:
		#ret[prueba] = datos[prueba][evento]
		ret[prueba] = {int(k):v for k,v in datos[prueba][evento].items()}
	return ret

# Retorna un diccionario con los detalles de un registro de codigo de evento
def getDetailsOfEvent(eventCode):
	with open('eventos.json') as data_file:
		events = json.load(data_file)
	for event in events:
		if eventCode in event["Codes"]:
			ret = event
			aux = event["Codes"][eventCode]
			del ret["Codes"]
			ret["Code"] = eventCode
			ret["CodeSpecification"] = aux
			return ret

def morphEventCode(code):
	return "0x"+code[1:]

def saveRegistrosToPlot(nombreEvento, datosPlot):
	fullFilename = "plots/" + nombreEvento + ".dat"
	archivo = open(fullFilename,'w+')
	archivo.close()


# Generar Diccionario con todo el pool de datos resumidos (para cada prueba, para cada evaluacion de threads/sockets guarda: promedio, desviacion)
summary = {}
for i in range(len(archivos)):
	summary[listadoPruebas[i]] = json.load(open(archivos[i]))

import pprint
# pprint.pprint(getSummaryDataOfEvent(summary, "r5340c4"), width=1)
# pprint.pprint(getDetailsOfEvent(morphEventCode("r5340c4")), width=1)


# Crear carpeta para guardar fuentes de datos para graficos
directory = "plots"
if not os.path.exists(directory):
	os.makedirs(directory)



def graficar(poolResultadosDict, evento):
	# Obtener datos para trabajar
	detallesEvento = getDetailsOfEvent(morphEventCode(evento))
	valoresGraficar = getSummaryDataOfEvent(poolResultadosDict, evento)
	pprint.pprint(detallesEvento, width=1)
	pprint.pprint(valoresGraficar, width=1)

	# Generar elementos del grafico
	figura = plt.figure(dpi=72)
	figura.suptitle(detallesEvento["Code"] + ": " + textwrap.fill(detallesEvento['Description'], 80), fontsize=14, fontweight='bold')

	# Seccion de grafico
	subFigura = figura.add_subplot(111)
	figura.subplots_adjust(top=0.8)

	# Recuperar numero de threads/sockets
	threads = []
	for nombrePrueba in valoresGraficar:
		threads = sorted(valoresGraficar[nombrePrueba].keys())
		break
	# Recuperar numero de pruebas
	pruebas = []
	pruebas = valoresGraficar.keys()

	# Cada grupo es una prueba con N threasd/sockets para las X pruebas
	n_groups = len(threads)
	xGroupsPositions = np.arange(n_groups)

	# Datos del grafico
	bar_width = 0.22
	opacity = 0.9
	error_config = {'ecolor': '0.3'}
	colores = ['r', 'b', 'g', 'gold', 'c']

	# itero en los datos
	pruebaIndex = 0
	for nombrePrueba in listadoPruebas:
		means = []
		std = []
		for thread in sorted(valoresGraficar[nombrePrueba]):
			means.append(valoresGraficar[nombrePrueba][thread][0])
			std.append(valoresGraficar[nombrePrueba][thread][1])
		# grafico
		print nombrePrueba, means
		subFigura.bar(bar_width*2 + xGroupsPositions + bar_width*pruebaIndex, means, bar_width,
                 alpha=opacity,
                 color=colores[pruebaIndex],
                 yerr=std,
                 error_kw=error_config,
                 label=nombrePrueba)
		pruebaIndex += 1

	# Rotular el subplot
	subFigura.set_title(textwrap.fill(detallesEvento['CodeSpecification'], 90), fontsize=11, y=1.07, bbox={'facecolor':'white', 'alpha':0.4, 'pad':10})
	subFigura.set_xlabel('Numero de Threads/Sockets')
	subFigura.set_ylabel('Tiempo [s]')
	subFigura.set_xticks(bar_width*2 + xGroupsPositions + bar_width*len(pruebas)/2)
	subFigura.set_xticklabels(threads)
	subFigura.legend(loc='best',fontsize=10,fancybox=True).get_frame().set_alpha(0.5)
	subFigura.text(0.993, 1.049, "PMU: " + detallesEvento["PMU name"],
                fontsize=9,
                transform=subFigura.transAxes,
                verticalalignment='top', horizontalalignment='right',
                bbox={'facecolor':'white', 'alpha':0.4, 'pad':6})
	subFigura.grid(True)
	plt.autoscale()
	#plt.show()
	figura.savefig('plots/'+evento+'.png')
	plt.close(figura)


# Reviso cada uno de los codigos de eventos registrados en JSON
for event in summary[listadoPruebas[0]]:
	#print event
	#pprint.pprint(summary, width=1)
	print event
	graficar(summary, event)
	#break
	print ""