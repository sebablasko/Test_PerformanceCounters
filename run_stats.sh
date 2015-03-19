#!/bin/bash

make all

limite_threads=4
clients=4
maxPackages=1000000
repetitions=2

#Contadores a revisar:
##NAME - description

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

##CACHE_LOCK_CYCLES - Cache locked
#r530263: Cycles L1D locked
#r530163: Cycles L1D and L2

##L3_LAT_CACHE - Last level cache accesses
#r53012e: Last level cache miss
#r53022e: Last level cache reference

##L2_RQSTS - L2 requests
#r530324: L2 requests
#r53aa24: All L2 misses

##L2_DATA_RQSTS - All L2 data requests
#r53ff26: All L2 data requests
#r530f26: L2 data demand requests
#r530826: L2 data demand loads in M state
#r530426: L2 data demand loads in E state
#r530226: L2 data demand loads in S state
#r530126: L2 data demand loads in I state (misses)
#r53f026: All L2 data prefetches
#r538026: L2 data prefetches in M state
#r534026: L2 data prefetches in E state
#r532026: L2 data prefetches in the S state
#r531026: L2 data prefetches in the I state (misses)

##L1D_WB_L2 - L1D writebacks to L2
#r530f28: All L1 writebacks to L2
#r530828: L1 writebacks to L2 in M state
#r530428: L1 writebacks to L2 in E state
#r530228: L1 writebacks to L2 in S state
#r530128: L1 writebacks to L2 in I state (misses)

##L2_WRITE - L2 demand lock/store RFO
#r534027: L2 demand lock RFOs in E state
#r53e027: All demand L2 lock RFOs that hit the cache
#r531027: L2 demand lock RFOs in I state (misses)
#r538027: L2 demand lock RFOs in M state
#r53f027: All demand L2 lock RFOs
#r532027: L2 demand lock RFOs in S state
#r530e27: All L2 demand store RFOs that hit the cache
#r530127: L2 demand store RFOs in I state (misses)
#r530827: L2 demand store RFOs in M state
#r530f27: All L2 demand store RFOs
#r530227: L2 demand store RFOs in S state

##Interfaces a destacar:
###GQ = Global Queue
###Quickpath

##UNC_GQ_DATA_FROM - Cycles GQ data is imported
#r500104: Cycles GQ data is imported from Quickpath interface
#r500204: Cycles GQ data is imported from Quickpath memory interface
#r500404: Cycles GQ data is imported from LLC
#r500804: Cycles GQ data is imported from Cores 0 and 2
#r501004: Cycles GQ data is imported from Cores 1 and 3

##UNC_QHL_REQUESTS - Quickpath Home Logic local read requests
#r501020: Quickpath Home Logic local read requests
#r502020: Quickpath Home Logic local write requests
#r500420: Quickpath Home Logic remote read requests
#r500120: Quickpath Home Logic IOH read requests
#r500220: Quickpath Home Logic IOH write requests
#r500820: Quickpath Home Logic remote write requests

##UNC_GQ_CYCLES_NOT_EMPTY - Cycles GQ read tracker is busy
#r500101: Cycles GQ read tracker is busy
#r500201: Cycles GQ write tracker is busy
#r500401: Cycles GQ peer probe tracker is busy


echo ""

for ((serverThreads=1 ; $serverThreads<=$limite_threads ; serverThreads=2*serverThreads))
{
	echo $serverThreads" Threads"

	for ((i=1 ; $i<=$repetitions ; i++))		
	{
		echo $i" repetition"
		newFile=perfStat"_"$serverThreads"_"$i".data"
		perf stat -e r500101,r501020,r530f27,r500401 -n -o $newFile ./server $maxPackages $serverThreads &

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