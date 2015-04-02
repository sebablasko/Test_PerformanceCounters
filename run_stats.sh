#!/bin/bash

make all

limite_threads=2
clients=4
maxPackages=1000000
repetitions=3

counters=r500104, r500204, r500404, r500105, r500205, r500405, r500420, r500820, r530451, r530251, r530851, r500108, r500208, r500109, r500209, r50010a, r50020a, r50040a, r50080a, r500f0a, r50010b, r50020b, r50040b, r50080b, r50100b, r501f0b, r530426, r530126, r530326, r530526

echo ""

for ((serverThreads=1 ; $serverThreads<=$limite_threads ; serverThreads=2*serverThreads))
{
	echo $serverThreads" Threads"

	for ((i=1 ; $i<=$repetitions ; i++))		
	{
		#echo $i" repetition"
		newFile=perfStat"_"$serverThreads"_"$i".data"
		perf stat -e r500104, r500204, r500404, r500105, r500205, r500405, r500420, r500820, r530451, r530251, r530851, r500108, r500208, r500109, r500209, r50010a, r50020a, r50040a, r50080a, r500f0a, r50010b, r50020b, r50040b, r50080b, r50100b, r501f0b, r530426, r530126, r530326, r530526 -o $newFile ./server $maxPackages $serverThreads &

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

make clean