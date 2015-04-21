#!/bin/bash

make all

limite_threads=16
clients=4
maxPackages=1000000
repetitions=15

#counters=r500104, r500204, r500404, r500105, r500205, r500405, r500420, r500820, r530451, r530251, r530851, r500108, r500208, r500109, r500209, r50010a, r50020a, r50040a, r50080a, r500f0a, r50010b, r50020b, r50040b, r50080b, r50100b, r501f0b, r530426, r530126, r530326, r530526

echo ""
echo "Testing UDP MultiThread Transmission"
for ((serverThreads=1 ; $serverThreads<=$limite_threads ; serverThreads=2*serverThreads))
{
	echo $serverThreads" Threads"

	for ((i=1 ; $i<=$repetitions ; i++))		
	{
		echo $i" repetition"
		#newFile="perfStat_UDPMultiThread_"$serverThreads"_"$i".data"
		if (($i >= 0 & $i < 10)); then newFile="perfStat_UDPMultiThread_"$serverThreads"_00"$i".data"; fi
		if (($i >= 10 & $i < 100)); then newFile="perfStat_UDPMultiThread_"$serverThreads"_0"$i".data"; fi
		if (($i >= 100)); then newFile="perfStat_UDPMultiThread_"$serverThreads"_"$i".data"; fi
		#perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526 -o $newFile -- ./server $maxPackages $serverThreads 1820 >> /dev/null &
		perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526,r5304b4,r5301b4,r5302b4,r5304b3,r5301b3,r5302b3,r5301b8,r5302b8,r5304b8,r530451,r530251,r530851,r530151,r500143,r500243,r500141,r500241,r500441,r500841,r501041,r502041,r500741,r503841,r500140,r500240,r500440,r500840,r501040,r502040,r500740,r503840,r500106,r500206,r500406,r500806,r501006,r502006,r500107,r500207,r500407,r500807,r501007,r502007,r502407,r500132,r500232,r500432,r500732 -o $newFile -- ./server $maxPackages $serverThreads 1820 >> /dev/null &
		pid=$!
		sleep 1

		for ((j=1 ; $j<=$clients ; j++))
		{
			./client $(($maxPackages*10)) 127.0.0.1 1820 > /dev/null &
		}
		wait $pid
	}

}

# python postProcessing.py $repetitions
# mv SummaryResults.csv SummaryResults_UDPMultiThread.csv
# mv FullResults.csv FullResults_UDPMultiThread.csv
# rm *.data

echo ""
echo "Testing dev_null Transmission"
for ((serverThreads=1 ; $serverThreads<=$limite_threads ; serverThreads=2*serverThreads))
{
	echo $serverThreads" Threads"

	for ((i=1 ; $i<=$repetitions ; i++))		
	{
		echo $i" repetition"
		#newFile="perfStat_devNullMultiThread_"$serverThreads"_"$i".data"
		if (($i >= 0 & $i < 10)); then newFile="perfStat_devNullMultiThread_"$serverThreads"_00"$i".data"; fi
		if (($i >= 10 & $i < 100)); then newFile="perfStat_devNullMultiThread_"$serverThreads"_0"$i".data"; fi
		if (($i >= 100)); then newFile="perfStat_devNullMultiThread_"$serverThreads"_"$i".data"; fi
		#perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526 -o $newFile -- ./dev_null $maxPackages $serverThreads >> /dev/null &
		perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526,r5304b4,r5301b4,r5302b4,r5304b3,r5301b3,r5302b3,r5301b8,r5302b8,r5304b8,r530451,r530251,r530851,r530151,r500143,r500243,r500141,r500241,r500441,r500841,r501041,r502041,r500741,r503841,r500140,r500240,r500440,r500840,r501040,r502040,r500740,r503840,r500106,r500206,r500406,r500806,r501006,r502006,r500107,r500207,r500407,r500807,r501007,r502007,r502407,r500132,r500232,r500432,r500732 -o $newFile -- ./dev_null $maxPackages $serverThreads >> /dev/null &
		pid=$!
		wait $pid
	}

}

# python postProcessing.py $repetitions
# mv SummaryResults.csv SummaryResults_devnull.csv
# mv FullResults.csv FullResults_devnull.csv
# rm *.data

echo ""
echo "Testing UDP SingleThread Multisocket Transmission"
for ((serverSockets=1 ; $serverSockets<=$limite_threads ; serverSockets=2*serverSockets))
{
	packages=$(($maxPackages/$serverSockets))
	echo $serverSockets" Sockets, each socket receive "$packages" packages"

	for ((i=1 ; $i<=$repetitions ; i++))		
	{
		echo $i" repetition"

		for (( k = 0; k < serverSockets; k++ ))
		{
			#newFile="perfStat_UDPMultiSocket_"$serverSockets"_"$i"_"$k".data"
			if (($i >= 0 & $i < 10)); then newFile="perfStat_UDPMultiSocket_"$serverSockets"_00"$i; fi
			if (($k >= 0 & $k < 10)); then newFile=$newFile"_00"$k".data"; fi

			if (($i >= 10 & $i < 100)); then newFile="perfStat_UDPMultiSocket_"$serverSockets"_0"$i; fi
			if (($k >= 10 & $k < 100)); then newFile=$newFile"_0"$k".data"; fi

			if (($i >= 100)); then newFile="perfStat_UDPMultiSocket_"$serverSockets"_"$i; fi
			if (($k >= 100)); then newFile=$newFile"_"$k".data"; fi
			#perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526 -o $newFile -- ./server $packages 1 $(($k+1820)) &
			perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526,r5304b4,r5301b4,r5302b4,r5304b3,r5301b3,r5302b3,r5301b8,r5302b8,r5304b8,r530451,r530251,r530851,r530151,r500143,r500243,r500141,r500241,r500441,r500841,r501041,r502041,r500741,r503841,r500140,r500240,r500440,r500840,r501040,r502040,r500740,r503840,r500106,r500206,r500406,r500806,r501006,r502006,r500107,r500207,r500407,r500807,r501007,r502007,r502407,r500132,r500232,r500432,r500732 -o $newFile -- ./server $packages 1 $(($k+1820)) &
			echo "Server listening at port "$(($k+1820))
		}

		pid=$!
		sleep 1

		for (( k = 0; k < serverSockets; k++ ))
		{
			for ((j=0 ; $j<$clients ; j++))
			{
				./client $(($maxPackages*10)) 127.0.0.1 $(($k+1820)) &
				echo "client writting at port "$(($k+1820))
			}
		}
		wait $pid
		sleep 1
	}

}

# python postProcessing.py $repetitions
# mv SummaryResults.csv SummaryResults_UDPMultiSocket.csv
# mv FullResults.csv FullResults_UDPMultiSocket.csv
#rm *.data

make clean