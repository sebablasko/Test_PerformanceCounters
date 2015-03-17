#!/bin/bash

make all

limite_threads=4
clients=4
maxPackages=1000000
repetitions=3

#Contadores a revisar:
#cycles :
#cpu-cycles:
#ref-cycles:
#r10000013c:
#cache-references:
#cache-misses:
#L1-dcache-loads:
#L1-dcache-load-misses:
#L1-dcache-stores:
#L1-dcache-store-misses
#L1-icache-loads
#L1-icache-load-misses
#cpu-migrations
#r530263,
#530163
#r53012e
#r53022e
#r530324
#r53aa24
#r530126
#r530426
#r534026
#r531026
#r530428
#r530128

echo ""

for ((serverThreads=1 ; $serverThreads<=$limite_threads ; serverThreads=2*serverThreads))
{
	echo $serverThreads" Threads"

	for ((i=1 ; $i<=$repetitions ; i++))		
	{
		echo $i" repetition"
		perf record -e cycles,cpu-cycles,ref-cycles,r10000013c,cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-icache-loads,L1-icache-load-misses,cpu-migrations,r530263,r530163,r53012e,r53022e,r530324,r53aa24,r530126,r530426,r534026,r531026,r530428,r530128 ./server $maxPackages $serverThreads &

		pid=$!
		sleep 1

		for ((j=1 ; $j<=$clients ; j++))
		{
			./client $maxPackages 127.0.0.1 > /dev/null &
		}
		wait $pid

		newFile=perf"{_}"$serverThreads"_"$i".data"
		mv perf.data $newFile
	}

}

echo ""

make clean