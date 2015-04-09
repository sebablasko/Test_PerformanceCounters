#!/bin/bash

make all

limite_threads=2
clients=4
maxPackages=1000000
repetitions=2

#counters=r500104, r500204, r500404, r500105, r500205, r500405, r500420, r500820, r530451, r530251, r530851, r500108, r500208, r500109, r500209, r50010a, r50020a, r50040a, r50080a, r500f0a, r50010b, r50020b, r50040b, r50080b, r50100b, r501f0b, r530426, r530126, r530326, r530526

# echo ""
# echo "Testing UDP MultiThread Transmission"
# for ((serverThreads=1 ; $serverThreads<=$limite_threads ; serverThreads=2*serverThreads))
# {
# 	echo $serverThreads" Threads"

# 	for ((i=1 ; $i<=$repetitions ; i++))		
# 	{
# 		echo $i" repetition"
# 		newFile="perfStat_UDPMultiThread_"$serverThreads"_"$i".data"
# 		perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526 -o $newFile -- ./server $maxPackages $serverThreads 1820 >> /dev/null &
# 		pid=$!
# 		sleep 1

# 		for ((j=1 ; $j<=$clients ; j++))
# 		{
# 			./client $(($maxPackages*10)) 127.0.0.1 1820 > /dev/null &
# 		}
# 		wait $pid
# 	}

# }

# python postProcessing.py
# mv SummaryResults.csv SummaryResults_UDPMultiThread.csv
# mv FullResults.csv FullResults_UDPMultiThread.csv
# rm *.data

# echo ""
# echo "Testing dev_null Transmission"
# for ((serverThreads=1 ; $serverThreads<=$limite_threads ; serverThreads=2*serverThreads))
# {
# 	echo $serverThreads" Threads"

# 	for ((i=1 ; $i<=$repetitions ; i++))		
# 	{
# 		echo $i" repetition"
# 		newFile="perfStat_devNullMultiThread_"$serverThreads"_"$i".data"
# 		perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526 -o $newFile -- ./dev_null $maxPackages $serverThreads >> /dev/null &
# 		pid=$!
# 		wait $pid
# 	}

# }

# python postProcessing.py
# mv SummaryResults.csv SummaryResults_devnull.csv
# mv FullResults.csv FullResults_devnull.csv
# rm *.data

echo ""
echo "Testing UDP SingleThread Transmission"
for ((serverSockets=1 ; $serverSockets<=$limite_threads ; serverSockets=2*serverSockets))
{
	packages=$(($maxPackages/$serverSockets))
	echo $serverSockets" Sockets, each socket receive "$packages" packages"

	for ((i=1 ; $i<=$repetitions ; i++))		
	{
		echo $i" repetition"

		for (( k = 0; k < serverSockets; k++ ))
		{
			newFile="perfStat_UDPMultiSocket_"$serverSockets"_"$i"_"$k".data"
			perf stat -e r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526 -o $newFile -- ./server $packages 1 $(($k+1820)) &
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

make clean