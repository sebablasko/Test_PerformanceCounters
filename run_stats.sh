#!/bin/bash

make all

limite_threads=32
clients=4
maxPackages=1000000
repetitions=15

#counters=r500104, r500204, r500404, r500105, r500205, r500405, r500420, r500820, r530451, r530251, r530851, r500108, r500208, r500109, r500209, r50010a, r50020a, r50040a, r50080a, r500f0a, r50010b, r50020b, r50040b, r50080b, r50100b, r501f0b, r530426, r530126, r530326, r530526

echo ""

for ((serverThreads=1 ; $serverThreads<=$limite_threads ; serverThreads=2*serverThreads))
{
	echo $serverThreads" Threads"

	for ((i=1 ; $i<=$repetitions ; i++))		
	{
		#echo $i" repetition"
		newFile=perfStat"_"$serverThreads"_"$i".data"
		perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526 -o $newFile -- ./server $maxPackages $serverThreads &

		pid=$!
		sleep 1

		for ((j=1 ; $j<=$clients ; j++))
		{
			./client $maxPackages 127.0.0.1 > /dev/null &
		}
		wait $pid
	}

}

echo ""

python postProcessing.py
mv SummaryResults.csv SummaryResults_UDPMultiThread.csv
mv FullResults.csv FullResults_UDPMultiThread.csv

rm *.data

for ((serverThreads=1 ; $serverThreads<=$limite_threads ; serverThreads=2*serverThreads))
{
	echo $serverThreads" Threads"

	for ((i=1 ; $i<=$repetitions ; i++))		
	{
		#echo $i" repetition"
		perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526 -o $newFile -- ./dev_null $maxPackages $serverThreads > aux &

		pid=$!
		wait $pid
	}

}

python postProcessing.py
mv SummaryResults.csv SummaryResults_devnull.csv
mv FullResults.csv FullResults_devnull.csv

make clean