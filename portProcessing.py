import sys
filename = sys.argv[1]
archivo = open(filename, 'r')

for line in archivo:
	if "%" in line:
		records = line.split(" ")
		records = filter(lambda x: x!="", records)
		print records
