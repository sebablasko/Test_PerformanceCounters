import sys
filename = sys.argv[1]
archivo = open(filename, 'r')

threads = filename.split("_")[1]
repetition = filename.split("_")[2]

eventos = {}

for line in archivo:
	if "%" in line:
		registro = line.split(" ")
		registro = filter(lambda x: x!="", registro)
		registro = registro[0:2]

		if registro[1] not in eventos:
			eventos[registro[1]] = {threads : []}

print eventos