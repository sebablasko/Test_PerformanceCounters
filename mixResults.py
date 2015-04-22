import json
import os
from pprint import pprint

def getSummaryResultsFromRecord(eventCode, filename):
	SummaryResultsFile = open(filename,'r')
	for line in SummaryResultsFile:
		if line.split(',')[0] == eventCode:
			SummaryResultsFile.close()
			return line.replace("\n","")
	SummaryResultsFile.close()
	return ""

def saveRegistrosToPlot(titulo, datos, filename):
	fullFilename = "plots/" + filename + ".dat"
	archivo = open(fullFilename,'w+')
	for val in datos:
		archivo.write(val)
		archivo.write(" ")
		archivo.write(datos[val].replace(","," "))
	archivo.close()


# Crear carpeta para guardar fuentes de datos para graficos
directory = "plots"
if os.path.exists(directory):
	os.makedirs(directory)

# cargar datos de eventos y contadores desde json
with open('events.json') as data_file:
	events = json.load(data_file)

# iterar sobre archivos rescatando y recolectando datos
allFiles = ["SummaryResults_devnull.csv","SummaryResults_UDPMultiThread.csv","SummaryResults_UDPMultiSocket.csv"]
for event in events:
	print(tituloGrafico + " (" + str(len(event["Codes"])) + ")")
	for code in event["Codes"]:
		print("\t" + code + "\t" + event["Codes"][code])
		tituloGrafico = code + ": " + event["Codes"][code]
		registros = {}
		for summaryFile in allFiles:
			record = getSummaryResultsFromRecord(code,summaryFile)
			recordResults = record[record.find(",")+1:]
			print("\t\t"+summaryFile+"\t"+recordResults)
			registros[summaryFile] = recordResults
		saveRegistrosToPlot(tituloGrafico, registros, code)
