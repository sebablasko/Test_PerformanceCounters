#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <getopt.h>

//Definiciones
#define BUF_SIZE 512

//Variables
int first_pack = 0;
struct timeval dateInicio, dateFin;
pthread_mutex_t lock;
int mostrarInfo = 0;
int MAX_PACKS = 0;
int NTHREADS = 0;
double segundos;


void print_usage(){
    printf("Uso: ./dev_null [--verbose] --packets <num> --threads <num>\n");
}

void print_config(){
    printf("Detalles de la prueba:\n");
    printf("\tPaquetes a leer:\t%d de %d bytes\n", MAX_PACKS, BUF_SIZE);
    printf("\tThreads que leeran concurrentemente:\t%d\n", NTHREADS);
}

void parseArgs(int argc, char **argv){
	int c;
	int digit_optind = 0;
	while (1){
		int this_option_optind = optind ? optind : 1;
        int option_index = 0;

		static struct option long_options[] = {
			{"packets", required_argument, 0, 'd'},
			{"threads", required_argument, 0, 't'},
			{"verbose", no_argument, 0, 'v'},
			{0, 0, 0, 0}
		};

         c = getopt_long (argc, argv, "vd:t:",
         long_options, &option_index);
 
         if (c == -1)
         	break; 

         switch (c){
			case 'v':
				printf ("Modo Verboso\n");
				mostrarInfo = 1;
				break;

			case 'd':
				MAX_PACKS = atoi(optarg);
				break;

			case 't':
				NTHREADS = atoi(optarg);
				break;

			default:
				printf("Error: La función getopt_long ha retornado un carácter desconocido. El carácter es = %c\n", c);
				print_usage();
				exit(1);
         }
	}
}

void llamadaHilo(int dev_fd){
	char buf[BUF_SIZE];
	int lectura;

	int paquetesParaAtender = MAX_PACKS/NTHREADS;
	int i;
	for(i = 0; i < paquetesParaAtender; i++) {
		lectura = read(dev_fd, buf, BUF_SIZE);
		if(first_pack==0) { 
			pthread_mutex_lock(&lock);
			if(first_pack == 0) {
				if(mostrarInfo)	printf("got first pack\n");
				first_pack = 1;
				//Medir Inicio
				gettimeofday(&dateInicio, NULL);
			}
			pthread_mutex_unlock(&lock);
		}
	}
}

int main(int argc, char **argv){

	// Paso 1.- Parsear Argumentos
	parseArgs(argc, argv);

	// Paso 2.- Validar Argumentos
	if(MAX_PACKS < 1 || NTHREADS < 1){
		printf("Error en el ingreso de parametros\n");
		print_usage();
		exit(1);
	}

	if(mostrarInfo)	print_config();
	if(mostrarInfo)	printf("El pid es %d\n", getpid());	

	// Paso 3.- Preparar los Threads
	pthread_t pids[NTHREADS];
	pthread_mutex_init(&lock, NULL);

	// Paso 4.- Abrir el dispositivo
	int dev_fd;
	dev_fd = open("/dev/null", 0);
	if(dev_fd < 0){
		fprintf(stderr, "Error al abrir el dispositivo");
		exit(1);
	}

	// Paso 5.- Lanzar Threads
	int i;
	for(i=0; i < NTHREADS; i++) 
		pthread_create(&pids[i], NULL, llamadaHilo, dev_fd);

	// Paso 6.- Esperar Threads y medir fin
	for(i=0; i < NTHREADS; i++) 
		pthread_join(pids[i], NULL);
	gettimeofday(&dateFin, NULL);

	// Final.- Compilar Resultados
	segundos=(dateFin.tv_sec*1.0+dateFin.tv_usec/1000000.)-(dateInicio.tv_sec*1.0+dateInicio.tv_usec/1000000.);
	if(mostrarInfo){
		printf("Tiempo Total = %g\n", segundos);
		printf("QPS = %g\n", MAX_PACKS*1.0/segundos);
	}else{
		printf("%g, \n", segundos);
	}
	exit(0);	
}