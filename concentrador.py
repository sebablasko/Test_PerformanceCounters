import sys
import os
import glob

# Concentrar (sumar) los datos en caso de estar dispersos en archivos separados por partes [p.data] (En caso de usar mas de un socket)
if(len(sys.argv)<2):
	print "Error. Uso: ./concentrador.py patronArchivosAProcesar"
	exit()

filePattern = sys.argv[1]
files = glob.glob(os.getcwd()+"/*"+filePattern+"*")

print files

# Crear el archivo de datos concentrados
salida = open(filePattern+".data", 'w')
for i in range(5):
	salida.write("\n")

# Recolectar los datos de los distintos archivos
diccionarioEventos = {}
for filename in sorted(files):
	archivo = open(filename, 'r')

	#Me salto el inicio inutil del archivo
	for x in range(5):
		next(archivo)

	for line in archivo:
		# Leo hasta que se termine el listado de datos
		if line == "\n":
			break
		registro = filter(lambda x: x!="", line.split(" "))
		# registro = [CantidadContada, CodigoEvento, %]

		# Agregar al diccionario de eventos
		if registro[1] not in diccionarioEventos:
			diccionarioEventos[registro[1]] = []
		diccionarioEventos[registro[1]].append((registro[0],registro[2]))
	archivo.close()

# Reunir los datos en el archivo de salida
for key in sorted(diccionarioEventos):
	total = 0
	for tupla in diccionarioEventos[key]:
		total += int(tupla[0].replace('.',''))
	salida.write(str(total)+"            "+key)
	salida.write("  \n")
salida.close()

print "done"