import json
from pprint import pprint

def getSummaryResultsFromRecord(eventCode, filename):
	SummaryResultsFile = open(filename,'r')
	for line in SummaryResultsFile:
		if line.split(',')[0] == eventCode:
			SummaryResultsFile.close()
			return line.replace("\n","")
	SummaryResultsFile.close()
	return ""

allFiles = ["SummaryResults_devnull.csv","SummaryResults_UDPMultiThread.csv","SummaryResults_UDPMultiSocket.csv"]

with open('events.json') as data_file:
	events = json.load(data_file)

for event in events:
	print(event["Name"] + ": " + event["Description"] + " (" + str(len(event["Codes"])) + ")")
	for code in event["Codes"]:
		print("\t" + code + "\t" + event["Codes"][code])
		for summaryFile in allFiles:
			record = getSummaryResultsFromRecord(code,summaryFile)
			recordResults = record[record.find(",")+1:]
			print("\t\t"+summaryFile+"\t"+recordResults)