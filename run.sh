#!/bin/bash

# Prueba para recoger información de los performance counters estudiando varios escenarios:
#	1.- Lectura concurrente desde DevNull
#	2.- Lectura concurrente desde 1 socket
#	3.- Lectura distribuida desde N sockets
# Extra!
#	4.- Lectura concurrente desde 1 socket con Reuseport
#	5.- Lectura distribuida desde N sockets usando solucion modulo (Pendiente...)

make all
total_threads_list="1 2 4 6 8 16 24 36 48"
total_clients=4
repetitions=3
MAX_PACKS=1000000
num_port=1820
filePrefix="perfStat_"

counters="r53003c,r5300c0,r53022e,r53012e,r5300c4,r5300c5,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10200,r10000,r10100,r100,r200,r10201,r10001,r201,r10002,r10102,r10202,r102,r202,r10103,r10003,r10203,r103,r203,r10004,r10005,r10006,r10106,r10206,r106,r206,r530300,r5308d1,r5302d1,r15302d1,r1d301d1,r5304d1,r530152,r5302e8,r5301e8,r5302c2,r5304c2,r10d301c2,r5301c2,r1d301c2,r5301c5,r5302c5,r53104f,r1f33fb1,r1f73fb1,r7308b1,r7310b1,r1f31fb1,r1d340b1,r7304b1,r5301b1,r1f71fb1,r1733fb1,r5302b1,r5340b1,r7380b1,r1731fb1,r5320b1,r53016c,r5301d5,r5304c0,r5302c0,r10d300c0,r530287,r530187,r530887,r530f87,r530487,r530408,r532008,r530108,r530208,r531008,r5304f1,r5307f1,r5302f1,r5308c7,r5301c7,r5302c7,r5310c7,r5304c7,r530806,r530406,r5302cc,r5303cc,r5301cc,r530163,r530263,r5301b2,r5302fd,r5310fd,r5301fd,r5304fd,r5320fd,r5340fd,r5308fd,r5301e0,r530189,r531089,r530489,r534089,r530789,r532089,r530889,r537f89,r533089,r530289,r5301f6,r5301e6,r5302e6,r530149,r538049,r531049,r530249,r530449,r53020b,r53010b,r53010e,r1f3010e,r1d3010e,r53020e,r173010e,r530224,r534024,r53c024,r532024,r530c24,r53aa24,r53ff24,r538024,r533024,r530824,r531024,r530324,r530424,r530124,r530119,r530413,r530113,r530213,r530713,r5301a7,r5304b4,r5301b4,r5302b4,r5310b0,r5304b0,r5301b0,r5340b0,r5302b0,r5380b0,r5308b0,r530203,r530205,r53011e,r530120,r5302c3,r5304c3,r5301c3,r530210,r534010,r531010,r532010,r538010,r530110,r530810,r530410,r5301ae,r5301c4,r5302c4,r530182,r5301a8,r15301a8,r1d301a8,r5304f2,r5301f2,r530ff2,r5308f2,r5302f2,r530185,r538085,r531085,r530285,r530485,r53044e,r53014e,r53024e,r5310f4,r5304f4,r5301d4,r5302f7,r5301f7,r5304f7,r534012,r530212,r531012,r532012,r530112,r530812,r530412,r530460,r530160,r530260,r530860,r53010c,r530118,r5301a6,r5301d0,r530107,r1d70114,r530114,r530214,r5320f0,r5340f0,r5308f0,r5310f0,r5301f0,r5302f0,r5380f0,r5304f0,r530117,r530704,r53014c,r53080f,r53010f,r53800f,r53040f,r53100f,r53200f,r53020f,r53ff26,r534026,r530f26,r53f026,r530826,r532026,r538026,r530226,r530426,r530126,r531026,r530188,r531088,r530488,r534088,r532088,r530788,r530888,r537f88,r533088,r530288,r5320c8,r5301e5,r5302b3,r5301b3,r5304b3,r15302b3,r15301b3,r15304b3,r5308cb,r5302cb,r5380cb,r5304cb,r5310cb,r5340cb,r5301cb,r530480,r530180,r530280,r530380,r534027,r530f27,r53f027,r532027,r530e27,r538027,r530827,r53e027,r530127,r531027,r530227,r5302b8,r5304b8,r5301b8,r530851,r530251,r530451,r530151,r5301a2,r5380a2,r5304a2,r5340a2,r5302a2,r5310a2,r5320a2,r5308a2,r5302d2,r5308d2,r5301d2,r530fd2,r5304d2,r2d3003c,r53013c,r530228,r530828,r530f28,r530428,r530128,r5301ec,r5301db,r5000ff,r500260,r500160,r500460,r500102,r500261,r500461,r500161,r500262,r500162,r500462,r500166,r500466,r500266,r500067,r502063,r500263,r501063,r500163,r500863,r500463,r500465,r500165,r500265,r502064,r500164,r501064,r500264,r500864,r500464,r501003,r500403,r504003,r500803,r500103,r502003,r500203,r500400,r500200,r500100,r500401,r500201,r500101,r501004,r500204,r500104,r500804,r500404,r500205,r500105,r500405,r500408,r500308,r500208,r500108,r500f0a,r50040a,r50020a,r50080a,r50010a,r50010b,r50080b,r50020b,r501f0b,r50100b,r50040b,r500409,r500209,r500309,r500109,r500224,r500424,r500225,r500425,r500125,r500421,r500121,r500221,r500122,r500422,r500222,r500433,r500234,r500434,r500834,r500134,r502034,r501034,r500423,r500123,r500223,r500420,r500220,r500820,r500120,r501020,r502020,r500026,r500829,r500429,r500229,r501029,r502029,r500129,r500730,r500130,r500230,r500430,r50022e,r50072e,r50042e,r50012e,r50072d,r50022d,r50012d,r50042d,r500828,r500428,r500228,r501028,r502028,r500128,r50012b,r50042b,r50072b,r50022b,r50042c,r50012c,r50022c,r50072c,r50042a,r50012a,r50022a,r500731,r500131,r500231,r500431,r500132,r500732,r500432,r500232,r50012f,r50202f,r50102f,r50072f,r50022f,r50042f,r50382f,r50082f,r500143,r500243,r500842,r500242,r500241,r500141,r500441,r501041,r503841,r502041,r500841,r500741,r500240,r500140,r500440,r501040,r503840,r502040,r500840,r500740,r501006,r500406,r500106,r500806,r502006,r500206,r501007,r500407,r500807,r500107,r502007,r502407,r500207,r500480,r500280,r500180,r500880,r500481,r500281,r500881,r500181,r500082,r500483,r500883,r500183,r500283,r500284,r500184,r500884,r500484,r500085,r500086"
#counters="r500104,r500204,r500404,r500105,r500205,r500405,r500420,r500820,r530451,r530251,r530851,r500108,r500208,r500109,r500209,r50010a,r50020a,r50040a,r50080a,r500f0a,r50010b,r50020b,r50040b,r50080b,r50100b,r501f0b,r530426,r530126,r530326,r530526,r5304b4,r5301b4,r5302b4,r5304b3,r5301b3,r5302b3,r5301b8,r5302b8,r5304b8,r530151,r500143,r500243,r500141,r500241,r500441,r500841,r501041,r502041,r500741,r503841,r500140,r500240,r500440,r500840,r501040,r502040,r500740,r503840,r500106,r500206,r500406,r500806,r501006,r502006,r500107,r500207,r500407,r500807,r501007,r502007,r502407,r500132,r500232,r500432,r500732"
#counters="r538288,r53a088,r53c488,r534188,r538888,r538188,r539088,r5301c4,r5340c4,r5310c4,r5308c4,r5320c4,r5302c4,r538489,r53c189"

echo "Evaluando Performance Counters"




#	1.- Lectura concurrente desde DevNull
echo "Testing Dev_Null MultiThread Transmission"
testName="DevNullMultiThread"

for serverThreads in $total_threads_list
do
	echo $testName": "$serverThreads" Threads"

	for ((i=1 ; $i<=$repetitions ; i++))
	{
		echo "rep "$i

		#Nombre archivo
		newFile=$filePrefix""$testName

		if (($serverThreads >= 0 & $serverThreads < 10)); then newFile=$newFile"_00"$serverThreads"t"; fi
		if (($serverThreads >= 10 & $serverThreads < 100)); then newFile=$newFile"_0"$serverThreads"t"; fi
		if (($serverThreads >= 100)); then newFile=$newFile"_"$serverThreads"t"; fi

		if (($i >= 0 & $i < 10)); then newFile=$newFile"_00"$i"r.data"; fi
		if (($i >= 10 & $i < 100)); then newFile=$newFile"_0"$i"r.data"; fi
		if (($i >= 100)); then newFile=$newFile"_"$i"r.data"; fi

		#Lanzar Servidor con Perf
		perf stat -e $counters -o $newFile -- ./dev_null --packets $MAX_PACKS --threads $serverThreads >> /dev/null &
		pid=$!
		sleep 1

		wait $pid
	}
done
# Colectar Data de las pruebas
echo "colentando repeticiones y pruebas"
python colector.py $filePrefix""$testName



#	2.- Lectura concurrente desde 1 socket
echo "Testing UDP MultiThread Transmission"
testName="UDPMultiThread"

for serverThreads in $total_threads_list
do
	echo $testName": "$serverThreads" Threads"

	for ((i=1 ; $i<=$repetitions ; i++))
	{
		echo "rep "$i

		#Nombre archivo
		newFile=$filePrefix""$testName

		if (($serverThreads >= 0 & $serverThreads < 10)); then newFile=$newFile"_00"$serverThreads"t"; fi
		if (($serverThreads >= 10 & $serverThreads < 100)); then newFile=$newFile"_0"$serverThreads"t"; fi
		if (($serverThreads >= 100)); then newFile=$newFile"_"$serverThreads"t"; fi

		if (($i >= 0 & $i < 10)); then newFile=$newFile"_00"$i"r.data"; fi
		if (($i >= 10 & $i < 100)); then newFile=$newFile"_0"$i"r.data"; fi
		if (($i >= 100)); then newFile=$newFile"_"$i"r.data"; fi

		#Lanzar Servidor con Perf
		perf stat -e $counters -o $newFile -- ./serverTesis --packets $MAX_PACKS --port $num_port --threads $serverThreads >> /dev/null &
		pid=$!
		sleep 1

		for ((j=1 ; $j<=$total_clients ; j++))
		{
			#Lanzar Cliente
			./clientTesis --intensive --packets $(($MAX_PACKS*10)) --ip 127.0.0.1 --port $num_port > /dev/null &
		}

		wait $pid
		kill $(pgrep 'clientTesis')
	}
done
# Colectar Data de las pruebas
echo "colentando repeticiones y pruebas"
python colector.py $filePrefix""$testName



#	3.- Lectura distribuida desde N sockets
echo "Testing UDP SingleThread MultiSocket Transmission"
testName="UDPSingleThreadMultiSocket"

for serverSockets in $total_threads_list
do
	packages=$(($MAX_PACKS/$serverSockets))

	echo $testName": "$serverSockets" sockets consumiendo "$packages" paquetes cada uno"

	for ((i=1 ; $i<=$repetitions ; i++))
	{
		echo "rep "$i

		#Nombre archivo
		newFile=$filePrefix""$testName

		if (($serverSockets >= 0 & $serverSockets < 10)); then newFile=$newFile"_00"$serverSockets"s"; fi
		if (($serverSockets >= 10 & $serverSockets < 100)); then newFile=$newFile"_0"$serverSockets"s"; fi
		if (($serverSockets >= 100)); then newFile=$newFile"_"$serverSockets"s"; fi

		if (($i >= 0 & $i < 10)); then newFile=$newFile"_00"$i"r"; fi
		if (($i >= 10 & $i < 100)); then newFile=$newFile"_0"$i"r"; fi
		if (($i >= 100)); then newFile=$newFile"_"$i"r"; fi

		#Lanzar Servidores con Perf
		pids=""
		patronAUnir=$newFile
		for (( k = 0; k < serverSockets; k++ ))
		{
			if (($k >= 0 & $k < 10)); then newFileMultiSocket=$newFile"_00"$k"p.data"; fi
			if (($k >= 10 & $k < 100)); then newFileMultiSocket=$newFile"_0"$k"p.data"; fi
			if (($k >= 100)); then newFileMultiSocket=$newFile"_"$k"p.data"; fi

			perf stat -e $counters -o $newFileMultiSocket -- ./serverTesis --packets $MAX_PACKS --port $(($k+$num_port)) --threads 1 >> /dev/null &
			pids="$pids $!"
		}		
		sleep 1

		for (( k = 0; k < serverSockets; k++ ))
		{
			for ((j=1 ; $j<=$total_clients ; j++))
			{
				#Lanzar Cliente
				./clientTesis --intensive --packets $(($MAX_PACKS*10)) --ip 127.0.0.1 --port $(($k+$num_port)) > /dev/null &
			}
		}

		for pid in $pids
		do
			wait $pid
		done
        kill $(pgrep 'clientTesis')

        # Unir partes
        echo "concentrando resultados"
        python concentrador.py $patronAUnir
	}
done
# Colectar Data de las pruebas
echo "colentando repeticiones y pruebas"
python colector.py $filePrefix""$testName



#	4.- Lectura concurrente desde 1 socket con Reuseport
echo "Testing UDP SingleThread MultiSocket con Reuseport Transmission"
testName="UDPReuseportSingleThreadMultiSocket"

for serverSockets in $total_threads_list
do
	packages=$(($MAX_PACKS/$serverSockets))

	echo $testName": "$serverSockets" sockets con Reuseport consumiendo "$packages" paquetes cada uno"

	for ((i=1 ; $i<=$repetitions ; i++))
	{
		echo "rep "$i

		#Nombre archivo
		newFile=$filePrefix""$testName

		if (($serverSockets >= 0 & $serverSockets < 10)); then newFile=$newFile"_00"$serverSockets"s"; fi
		if (($serverSockets >= 10 & $serverSockets < 100)); then newFile=$newFile"_0"$serverSockets"s"; fi
		if (($serverSockets >= 100)); then newFile=$newFile"_"$serverSockets"s"; fi

		if (($i >= 0 & $i < 10)); then newFile=$newFile"_00"$i"r"; fi
		if (($i >= 10 & $i < 100)); then newFile=$newFile"_0"$i"r"; fi
		if (($i >= 100)); then newFile=$newFile"_"$i"r"; fi

		#Lanzar Servidores con Perf
		pids=""
		patronAUnir=$newFile
		for (( k = 0; k < serverSockets; k++ ))
		{
			if (($k >= 0 & $k < 10)); then newFileMultiSocket=$newFile"_00"$k"p.data"; fi
			if (($k >= 10 & $k < 100)); then newFileMultiSocket=$newFile"_0"$k"p.data"; fi
			if (($k >= 100)); then newFileMultiSocket=$newFile"_"$k"p.data"; fi

			perf stat -e $counters -o $newFileMultiSocket -- ./serverTesis --packets $MAX_PACKS --port $num_port --threads 1 --reuseport >> /dev/null &
			pids="$pids $!"
		}		
		sleep 1

		for ((j=1 ; $j<=$total_clients ; j++))
		{
			#Lanzar Cliente
			./clientTesis --intensive --packets $(($MAX_PACKS*10)) --ip 127.0.0.1 --port $num_port > /dev/null &
		}

		for pid in $pids
		do
			wait $pid
		done
        kill $(pgrep 'clientTesis')

        # Unir partes
        echo "concentrando resultados"
        python concentrador.py $patronAUnir
	}
done
# Colectar Data de las pruebas
echo "colentando repeticiones y pruebas"
python colector.py $filePrefix""$testName


make clean