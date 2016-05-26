/**
 *Title: Sopa de letras
 *Description: juego de la sopa de letras en C
 *@Author: David Santamaría Martín, David Arreba Corral
 *@Date: 3 Mayo 2016
 */

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>

#define DIM 15
#define TCHAR 11
#define N_TEMA 5
#define N_PAL 5
#define CHAR_MIN 65
#define CHAR_MAX 90
#define ZERO 48

typedef struct {
  char    palabra[TCHAR];
  int     fila_inicial;
  int     columna_inicial;
  int     fila_final;
  int     columna_final;
  int     direccion;
  bool    encontrada;
} Palabra;

//FILE *archivotemas;
//archivotemas=fopen("sopa.txt","r");

void    rellenaTemas(Palabra[N_TEMA][N_PAL]);	//rellena la matriz temas con 25 strcpy
void    compuebaTemas(Palabra[DIM][DIM]);
void    crearSopa(int[DIM][DIM]);
void    imprimirSopa(int[DIM][DIM]);
int     solicitaOpcionMenu(char[N_TEMA][TCHAR]);
void    introduceN(int *);
void    colocaPalabras(int[DIM][DIM], Palabra[N_TEMA][N_PAL], int);
void    colocaPalabra(int[DIM][DIM], Palabra[N_TEMA][N_PAL], int, int,
		      int);
int     buscaAleatorio(int max, int min);
void    rellenaMatriz(int[DIM][DIM]);
bool    esPosibleColocarPalabra(int, int, char[TCHAR], int, int[DIM][DIM]);
void    coincidePal(int[DIM][DIM], Palabra[N_TEMA][N_PAL], int, int,
		    int, int, int, int[N_PAL]);
void    transcurso(int[DIM][DIM], Palabra[N_TEMA][N_PAL], int);
int     dirUsuario(int, int, int, int);
void    rellenaTemasporfichero(Palabra[N_TEMA][N_PAL],
			       char[N_TEMA][TCHAR]);
void    damelasolucion(Palabra[N_TEMA][N_PAL], int);
void    imprimeAciertos(Palabra[N_TEMA][N_PAL], int);

/**
 *nombre: clean_stdin
 *descripcion: limpia el buffer de teclado
 *return: 1 si ha completado la operación
 *Author: David Santamaría Martín y David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: por determinar
*/

int clean_stdin() {
  while(getchar() != '\n') ;
  return 1;
}

int main() {
  srand(time(NULL));
  Palabra temas[N_TEMA][N_PAL];
  char    nombretemas[N_TEMA][TCHAR];
  int     sopa[DIM][DIM];
  int     opcion;
  rellenaTemasporfichero(temas, nombretemas);
  opcion = solicitaOpcionMenu(nombretemas);
  crearSopa(sopa);
  transcurso(sopa, temas, opcion);
  return 0;
}

/**
 *nombre: solicitaOpcionMenu
 *descripcion: muestra el menú y pide al usuario un tema
 *return: tema elegido
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/
int solicitaOpcionMenu(char nt[N_TEMA][TCHAR]) {
  int     opcion;
  bool    sacarla = false;
  do {
    printf("Elige un tema\n");
    printf("1 - %s\n", nt[0]);
    printf("2 - %s\n", nt[1]);
    printf("3 - %s\n", nt[2]);
    printf("4 - %s\n", nt[3]);
    printf("5 - %s\n", nt[4]);
    printf("0 - Salir\n");
    introduceN(&opcion);
    if(opcion < 0 || opcion > 5) {
      printf("Valor incorrecto\n");
      sacarla = false;
    } else {
      sacarla = true;
    }
  } while(!sacarla);
  return opcion - 1;
}

/**
 *nombre: crearSopa
 *descripción: genera la matriz sopa de letras
 *parametro mat[DIM][DIM]: matriz de la sopa de letras
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void crearSopa(int mat[DIM][DIM]) {
  int     i = 0, j = 0;
  for(i = 0; i < DIM; i++) {
    for(j = 0; j < DIM; j++) {
      mat[i][j] = ZERO;
    }
  }
}

/**
 *nombre: imprimirSopa
 *descripción: muestra la sopa de letras en la pantalla
 *parametro sopa[DIM][DIM]: matriz de la sopa de letras
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void imprimirSopa(int sopa[DIM][DIM]) {
  int     i = 0, j = 0;
  printf("  *-1-2-3-4-5-6-7-8-9-101112131415*\n");
  for(i = 0; i < DIM; i++) {
    if(i < 9)
      printf(" %d|", i + 1);
    if(i > 8)
      printf("%d|", i + 1);
    for(j = 0; j < DIM; j++) {
      printf("%2c", sopa[i][j]);
    }
    printf("|\n");
  }
  printf("  *------------------------------*\n");
}

/**
 *nombre: rellenaTemas
 *descripción: genera la matriz con los temas
 *parametro tms[DIM][DIM]: estructura que contendrá las palabras de los temas
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void rellenaTemas(Palabra tms[N_TEMA][N_PAL]) {
  strcpy(tms[0][0].palabra, "AUDI");
  strcpy(tms[0][1].palabra, "MERCEDES");
  strcpy(tms[0][2].palabra, "FORD");
  strcpy(tms[0][3].palabra, "OPEL");
  strcpy(tms[0][4].palabra, "RENAULT");
  strcpy(tms[1][0].palabra, "ROJO");
  strcpy(tms[1][1].palabra, "VERDE");
  strcpy(tms[1][2].palabra, "AZUL");
  strcpy(tms[1][3].palabra, "AMARILLO");
  strcpy(tms[1][4].palabra, "NARANJA");
  strcpy(tms[2][0].palabra, "CIRCULO");
  strcpy(tms[2][1].palabra, "TRIANGULO");
  strcpy(tms[2][2].palabra, "CUADRADO");
  strcpy(tms[2][3].palabra, "ROMBO");
  strcpy(tms[2][4].palabra, "ELIPSE");
  strcpy(tms[3][0].palabra, "MADRID");
  strcpy(tms[3][1].palabra, "BARCELONA");
  strcpy(tms[3][2].palabra, "ZARAGOZA");
  strcpy(tms[3][3].palabra, "BILBAO");
  strcpy(tms[3][4].palabra, "BURGOS");
  strcpy(tms[4][0].palabra, "INGLATERRA");
  strcpy(tms[4][1].palabra, "ARGELIA");
  strcpy(tms[4][2].palabra, "ITALIA");
  strcpy(tms[4][3].palabra, "FRANCIA");
  strcpy(tms[4][4].palabra, "MARRUECOS");
}

/**
 *nombre: rellenaTemasporfichero
 *descripción: carga los temas desde el archivo sopa.txt
 *entrada: struct que contiene los temas y vector con los nombres de los temas
 *autores: David Santamaría Martín, David Arreba Corral
 *fecha: 24 mayo 2016
 *Version: 1.000000000000000000000000000000000000001
*/

void rellenaTemasporfichero(Palabra t[N_TEMA][N_PAL],
			    char nt[N_TEMA][TCHAR]) {
  FILE   *archivotemas;
  int     i = 0;
  archivotemas = fopen("sopa.txt", "r");
  if(archivotemas != NULL) {
    while(!feof(archivotemas) && i < N_TEMA) {
      fscanf(archivotemas, "%[^,],%[^,],%[^,],%[^,],%[^,],%[^\n]\n", nt[i],
	     t[i][0].palabra, t[i][1].palabra, t[i][2].palabra,
	     t[i][3].palabra, t[i][4].palabra);
      i++;
    }
    fclose(archivotemas);
  }
}

/**
 *nombre: compruebaTemas
 *descripción: imprime los temas para que el usuario pueda visualizarlos
 *parametro tms[DIM][DIM][TCHAR]: matriz de los temas
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void compruebaTemas(Palabra tms[DIM][DIM]) {
  int     i, j;
  for(i = 0; i < 5; i++) {
    printf(" %d - ", i);
    for(j = 0; j < 5; j++) {
      printf("%s ", tms[i][j].palabra);
    }
  }
}

/**
 *nombre: buscaAleatorio
 *descripción: genera lnúmeros aleatorios entre max y min
 *parametro max: límite superior del rango
 *parametro min: límite inferior del rango
 *return aleatorio: el número aleatorio generado
 *Author: Carlos Pardo Aguilar
 *Date: 3 Mayo 2016
 *Version: 2.0
 **/

int buscaAleatorio(int max, int min) {
  int     aleatorio;
  aleatorio = (rand() % (max - min)) + min;
  return aleatorio;
}

/**
 *nombre: colocaPalabras
 *descripción: pone las palabras en la sopa de letras
 *parametro sopa[DIM][DIM]: matriz de la sopa de letras
 *parametro palabra[N_TEMA][N_PAL][TCHAR]: palabra del tema
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void colocaPalabras(int sopa[DIM][DIM], Palabra palabra[N_TEMA][N_PAL],
		    int opcion) {
  int     j;
  int     dir;
  for(j = 0; j < 5; j++) {
    dir = buscaAleatorio(4, 1);
    colocaPalabra(sopa, palabra, dir, j, opcion);
  }
}

/**
 *nombre: colocaPalabra (ojo, sin S al final)
 *descripción: pone las palabras en la matriz en una dirección aleatoria
 *parametro sopa[DIM][DIM]: matriz de la sopa de letras
 *parametro palabra[TCHAR]: la palabra que será colocada
 *parametro dir: la dirección de colocación
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void colocaPalabra(int sopa[DIM][DIM], Palabra palabra[N_TEMA][N_PAL],
		   int dir, int k, int opcion) {
  int     fila, col, i, j;
  do {
    fila = buscaAleatorio(DIM - 1, 0);
    col = buscaAleatorio(DIM - 1, 0);
  } while(!esPosibleColocarPalabra
	  (fila, col, palabra[opcion][k].palabra, dir, sopa));
  palabra[opcion][k].fila_inicial = fila;
  palabra[opcion][k].columna_inicial = col;
  switch (dir) {
    case 1:
      for(i = col, j = 0; i < (col + (int)strlen(palabra[opcion][k].palabra)); i++) {	//derecha
	sopa[fila][i] = (int)palabra[opcion][k].palabra[j];
	j++;
      }
      palabra[opcion][k].fila_final = fila;
      palabra[opcion][k].columna_final =
	  col + (int)strlen(palabra[opcion][k].palabra) - 1;
      break;
    case 2:
      for(i = col, j = 0; i > (col - (int)strlen(palabra[opcion][k].palabra)); i--) {	//izquierda
	sopa[fila][i] = (int)palabra[opcion][k].palabra[j];
	j++;
      }
      palabra[opcion][k].fila_final = fila;
      palabra[opcion][k].columna_final =
	  col - (int)strlen(palabra[opcion][k].palabra) + 1;
      break;
    case 3:
      for(i = fila, j = 0; i < (fila + (int)strlen(palabra[opcion][k].palabra)); i++) {	//abajo
	sopa[i][col] = (int)palabra[opcion][k].palabra[j];
	j++;
      }
      palabra[opcion][k].fila_final =
	  fila + (int)strlen(palabra[opcion][k].palabra) - 1;
      palabra[opcion][k].columna_final = col;
      break;
    case 4:
      for(i = fila, j = 0; i > (fila - (int)strlen(palabra[opcion][k].palabra)); i--) {	//arriba
	sopa[i][col] = (int)palabra[opcion][k].palabra[j];
	j++;
      }
      palabra[opcion][k].fila_final =
	  fila - (int)strlen(palabra[opcion][k].palabra) + 1;
      palabra[opcion][k].columna_final = col;
      break;
  }
  //palabra[opcion][k].fila_final = fila;
  //palabra[opcion][k].columna_final = col;
  palabra[opcion][k].direccion = dir;
}

/**
 *nombre: esPosibleColocarPalabra
 *descripción: comprueba si la palabra se puede colocar en la posicion y dirección dadas
 *parametro fila: la fila donde se va a poner
 *parametro col: la columna donde se va a poner
 *parametro palabra[TCHAR]: la palabra
 *parametro dir: la direccion en la que va a ir
 *parametro sopichuela: la sopa
 *return: true si cabe, false en caso contrario
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

bool esPosibleColocarPalabra(int fila, int col, char palabra[TCHAR],
			     int dir, int sopichuela[DIM][DIM]) {
  bool    resultado = true;
  int     i, j;
  switch (dir) {
    case 1:			//derecha
      if(col + (int)strlen(palabra) > DIM) {
	resultado = false;
      } else {
	for(i = col, j = 0; i <= col + (int)strlen(palabra); i++, j++) {
	  if(sopichuela[fila][i] != ZERO) {
	    if(palabra[j] != sopichuela[fila][i]) {
	      resultado = false;
	    }
	  }
	}
      }
      break;
    case 2:			//izquierda
      if(col - (int)strlen(palabra) < 0) {
	resultado = false;
      } else {
	for(i = col, j = 0; i >= col - (int)strlen(palabra); i--, j++) {
	  if(sopichuela[fila][i] != ZERO) {
	    if(palabra[j] != sopichuela[fila][i]) {
	      resultado = false;
	    }
	  }
	}
      }
      break;
    case 3:			//abajo
      if(fila + (int)strlen(palabra) > DIM) {
	resultado = false;
      } else {
	for(i = fila, j = 0; i <= fila + (int)strlen(palabra); i++, j++) {
	  if(sopichuela[i][col] != ZERO) {
	    if(palabra[j] != sopichuela[i][col]) {
	      resultado = false;
	    }
	  }
	}
      }
      break;
    case 4:			//arriba
      if(fila - (int)strlen(palabra) < 0) {
	resultado = false;
      } else {
	for(i = fila, j = 0; i >= fila - (int)strlen(palabra); i--, j++) {
	  if(sopichuela[i][col] != ZERO) {
	    if(palabra[j] != sopichuela[i][col]) {
	      resultado = false;
	    }
	  }
	}
      }
      break;
  }
  return resultado;
}

/**
 *nombre: rellenaMatriz
 *descripción: rellena los huecos vacíos de la matroz con letras aleatorias
 *parametro sopa[DIM][DIM]: matriz de la sopa de letras
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void rellenaMatriz(int sopa[DIM][DIM]) {
  int     i, j;
  for(i = 0; i <= DIM; i++) {
    for(j = 0; j <= DIM; j++) {
      if(sopa[i][j] == ZERO) {
	sopa[i][j] = buscaAleatorio(CHAR_MAX, CHAR_MIN);
      }
    }
  }
}

/**
 *nombre: introduceN
 *descripción: pide al usuario un número
 *parametro *n: número en cuestión pasado por referencia
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void introduceN(int *n) {
  char    enter;
  int     leidos;
  bool    sacarla = false;
  do {
    leidos = scanf("%d%c", n, &enter);
    if(leidos != 2 || enter != '\n') {
      printf("debes introducir un número.\n ");
      clean_stdin();
    } else {
      sacarla = true;
    }
  } while(!sacarla);
}

/**
 *nombre: coincidePal
 *descripción: comprueba si la palabra coincide
 *parametro sopa: la sopa de letras
 *parametro temas: las palabras del tema
 *parametro opcion: la opcion elegida en el menú
 *parametro iF: inicio de fila
 *parametro iC: inicio de columna
 *parametro fF: fin de fila
 *parametro fC: fin de columna
 *parametro palaEncontrada: la palabra pedida al usuario
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void coincidePal(int sopa[DIM][DIM],
		 Palabra temas[N_TEMA][N_PAL],
		 int opcion, int iF, int iC, int fF,
		 int fC, int palEncontrada[N_PAL]) {

  int     i, j, dir, cebollazo;
  bool    rec = false;
  bool    norec = true;
  char    pal[TCHAR];
  dir = dirUsuario(iF, fF, iC, fC);
  cebollazo = dir;
  switch (dir) {
    case 1:			//Derecha
      for(i = iC, j = 0; i <= fC; ++i, ++j) {
	pal[j] = (char)sopa[iF][i];
      } pal[j + 1] = '\0';
      break;
    case 2:			//Izquierda
      for(i = iC, j = 0; i >= fC; --i, ++j) {
	pal[j] = (char)sopa[iF][i];
      }
      pal[j + 1] = '\0';
      break;
    case 3:			//Abajo
      for(i = iF, j = 0; i <= fF; ++i, ++j) {
	pal[j] = (char)sopa[i][iC];
      }
      pal[j + 1] = '\0';
      break;
    case 4:			//Arriba
      for(i = iF, j = 0; i >= fF; --i, ++j) {
	pal[j] = (char)sopa[i][iC];
      }
      pal[j + 1] = '\0';
      break;
  }
  for(i = 0; i < N_PAL && !rec && norec; ++i) {
    if(strncmp
       (temas[opcion][i].palabra, pal,
	(int)strlen(temas[opcion][i].palabra)) == 0
       && temas[opcion][i].encontrada == false) {
      palEncontrada[i] = true;
      rec = true;
    }
  }
  if(rec) {
    printf("\nacertaste la palabra %s\n", temas[opcion][i - 1].palabra);
  } else {
    printf("\nfallaste! es posible que estés repitiendo palabras\n");
  }
}

/**
 *nombre: dirUsuario
 *descripción: a partir del trozo de matriz que indica el usuario le asigna su dirección del 1 al 4
 *parametro iF: inicio de fila
 *parametro iC: inicio de columna
 *parametro fF: fin de fila
 *parametro fC: fin de columna
 *return: un número del 1 al 4 según la dirección
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

int dirUsuario(int iF, int fF, int iC, int fC) {
  int     dirUs;
  if(iF == fF && iC < fC)
    dirUs = 1;			//derecha
  if(iF == fF && iC > fC)
    dirUs = 2;			//izq
  if(iF < fF && iC == fC)
    dirUs = 3;			//abajo
  if(iF > fF && iC == fC)
    dirUs = 4;			//arr
  return dirUs;
}

/**
 *nombre: transcurso
 *descripción: la funcion que permite jugar a esto
 *parametro sopa: la sopa de letras
 *parametro temas: las palabras del tema elegido
 *parametro opcion: el tema que hemos elegido
 *Author: David Santamaría Martín, David Arreba Corral
 *Date: 3 Mayo 2016
 *Version: 1.0 (unica)
 **/

void transcurso(int sopa[DIM][DIM],
		Palabra temas[N_TEMA][N_PAL], int opcion) {
  int     iF, fF, iC, fC, i, respuestas;
  int     palEncontrada[N_PAL];
  bool    sacarla;
  if(opcion == -1) {
    printf("nos vemos\n");
    exit(0);
  }
  colocaPalabras(sopa, temas, opcion);
  rellenaMatriz(sopa);
  imprimirSopa(sopa);
  //damelasolucion(temas, opcion);
  for(i = 0; i < N_PAL; ++i) {
    palEncontrada[i] = false;
  }
  for(i = 0; i < N_PAL; i++) {
    temas[opcion][i].encontrada = false;
  }
  do {
    do {
      printf("introduce inicio de fila: ");
      introduceN(&iF);
      if(iF < 1 || iF > DIM) {
	printf("no válido, debe estar entre 1 y 15\n");
	sacarla = false;
      } else {
	sacarla = true;
      }
    } while(!sacarla);
    do {
      printf("introduce fin de fila: ");
      introduceN(&fF);
      if(fF < 1 || fF > DIM) {
	printf("no válido, debe estar entre 1 y 15\n");
	sacarla = false;
      } else {
	sacarla = true;
      }
    } while(!sacarla);
    do {
      printf("introduce inicio de columna: ");
      introduceN(&iC);
      if(iC < 1 || iC > DIM) {
	printf("no válido, debe estar entre 1 y 15\n");
	sacarla = false;
      } else {
	sacarla = true;
      }
    } while(!sacarla);
    do {
      printf("introduce fin de columna: ");
      introduceN(&fC);
      if(fC < 1 || fC > DIM) {
	printf("no válido, debe estar entre 1 y 15\n");
	sacarla = false;
      } else {
	sacarla = true;
      }
    } while(!sacarla);
    coincidePal(sopa, temas, opcion, iF - 1, iC - 1, fF - 1,
		fC - 1, palEncontrada);
    for(i = 0, respuestas = 0; i < N_PAL; ++i) {
      if(palEncontrada[i] == true) {
	++respuestas;
	temas[opcion][i].encontrada = true;
      }
    }
    printf("\nhas acertado %d palabras\n", respuestas);
    printf("\nestos son tus aciertos:\n");
    imprimeAciertos(temas, opcion);
    imprimirSopa(sopa);
  } while(N_PAL - respuestas != 0);
  printf("has ganado\n");
  damelasolucion(temas, opcion);
}

/**
 *nombre: damelasolucion
 *descripción: al finalizar la partida vuelca la solución de la sopa
 *entrada: struct que contiene los temas y opcion elegida
 *salida: un fichero solucion.txt
 *autores: David Santamaría Martín, David Arreba Corral
 *fecha: 24 mayo 2016
 *Version: 1.000000000000000000000000000000000000001
*/

void damelasolucion(Palabra t[N_TEMA][N_PAL], int opcion) {
  FILE   *archivosolucion;
  int     i;
  archivosolucion = fopen("solucion.txt", "w");
  if(archivosolucion != NULL) {
    for(i = 0; i < N_PAL; i++) {
      fprintf(archivosolucion,
	      "Palabra: %s,Fila inicial: %d, Columna inicial: %d,Fila final: %d,Columna final: %d, Direccion: %d\n",
	      t[opcion][i].palabra, t[opcion][i].fila_inicial + 1,
	      t[opcion][i].columna_inicial + 1,
	      t[opcion][i].fila_final + 1, t[opcion][i].columna_final + 1,
	      t[opcion][i].direccion);
    }
    fclose(archivosolucion);
  }
}

/**
 *nombre: imprimeAciertos
 *descripción: imprime las palabras que el usuario ha acertado
 *entrada: struct que contiene los temas y opcion elegida
 *salida: las palabras acertadas, por pantalla
 *autores: David Santamaría Martín, David Arreba Corral
 *fecha: 24 mayo 2016
 *Version: 1.000000000000000000000000000000000000001
*/

void imprimeAciertos(Palabra t[N_TEMA][N_PAL], int opcion) {
  int     i;
  for(i = 0; i < N_PAL; i++) {
    if(t[opcion][i].encontrada) {
      printf("%s\n", t[opcion][i].palabra);
    }
  }
  printf("\n");
}
