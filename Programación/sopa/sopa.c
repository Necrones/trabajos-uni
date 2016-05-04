/**
 *Title: Sopa de letras
 *Description: Hace una sopa de letras con varios temas
 *@Author: Luis Pedrosa Ruiz y José Luis Garrido Labrador (JoseluCross)
 *@organization: UBU
 *@Version: 1.0.0
 *@Date: 05/04/2016
 */

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdbool.h>
#include <stdlib.h>

#define DIM 15
#define TCHAR 11
#define N_TEMA 5
#define N_PAL 8			//5 era muy mainstream
#define CHAR_MIN 65		//A en ASCII
#define CHAR_MAX 90		//Z en ASCII
#define ZERO 48			//0 en ASCII
#define A_MINUS 97		//a en ASCII
#define ESC 27			//Escape en ASCII
#define ESP 32			//Espacio en ASCII
#define DASH 45			//- en ASCII
#define BARRA 124		//| en ASCII

void    crearSopa(int[DIM][DIM]);
void    imprimirSopa(int[DIM][DIM]);
void    rellenaTemas(char[N_TEMA][N_PAL][TCHAR]);
int     solicitaOpcionMenu(void);
int     clean_stdin(void);
void    colocaPalabras(int[DIM][DIM], char[N_TEMA][N_PAL][TCHAR], int);
void    colocaPalabra(int[DIM][DIM], char[TCHAR], int);
void    rellenaMatriz(int[DIM][DIM]);
int     buscaAleatorio(int, int);
bool    esPosibleColocarPalabra(int[DIM][DIM], char[TCHAR], int, int, int);
void    introduceNum(int *);
void    coincidePal(int[DIM][DIM], char[N_TEMA][N_PAL][TCHAR], int, int,
		    int, int, int, bool[N_PAL]);
void    juego(int[DIM][DIM], char[N_TEMA][N_PAL][TCHAR]);
void    minuscula(int[DIM][DIM], int, int, int, int, int);
int     sentido(int, int, int, int);

int main() {
  srand(time(NULL));
  //srand(22);                  //Cruce en coches
  int     sopa[DIM][DIM];
  char    temas[N_TEMA][N_PAL][TCHAR];
  rellenaTemas(temas);
  system("clear");
  juego(sopa, temas);
  return 0;
}

/**
 *Nombre: clean_stdin
 *Description: Borra el buffer del teclado
 *@return: 1 si lo ha borrado
 *@author: Luis Pedrosa Ruiz y JoseluCross
 *date: 12/04/2016
 *@version: 1.0
 */
int clean_stdin() {
  while(getchar() != '\n') ;
  return 1;
}

/**
  *Nombre: juego
  *Descripción: ejecuta el juego de la sopa de letras
  *@param matriz: sopa de letra
  *@param themes: temas de la sopa
  *@author: Luis Pedrosa Ruiz y JoseluCross
  *@date: 26/04/2016
  */
void juego(int matriz[DIM][DIM], char themes[N_TEMA][N_PAL][TCHAR]) {
  int     ini_fila, ini_col, fin_fila, fin_col;	//Coordenadas
  bool    palEncontrada[N_PAL];
  int     i;			//Contador
  int     respuestas;
  bool    victoria = false, game = true, salida;
  int     partida, tema;
  while(game) {
    //Iniciamos el juego 
    tema = solicitaOpcionMenu();
    if(tema != -1) {
      crearSopa(matriz);
      colocaPalabras(matriz, themes, tema);
      rellenaMatriz(matriz);
      imprimirSopa(matriz);
      //Inicializamos palEncontrada
      for(i = 0; i < N_PAL; ++i) {
	palEncontrada[i] = false;
      }
      do {
	do {
	  printf("Introduce la primera coordenada (fila): ");
	  introduceNum(&ini_fila);
	  if(ini_fila < 1 || ini_fila > DIM) {
	    printf("Fuera de rango\n");
	    salida = false;
	  } else {
	    salida = true;
	  }
	} while(!salida);
	do {
	  printf("Introduce la primera coordenada (columna): ");
	  introduceNum(&ini_col);
	  if(ini_col < 1 || ini_fila > DIM) {
	    printf("Fuera de rango\n");
	    salida = false;
	  } else {
	    salida = true;
	  }
	} while(!salida);
	do {
	  printf("Introduce la segunda coordenada (fila): ");
	  introduceNum(&fin_fila);
	  if(fin_fila < 1 || ini_fila > DIM) {
	    printf("Fuera de rango\n");
	    salida = false;
	  } else {
	    salida = true;
	  }
	} while(!salida);
	do {
	  printf("Introduce la segunda coordenada (columna): ");
	  introduceNum(&fin_col);
	  if(fin_col < 1 || ini_fila > DIM) {
	    printf("Fuera de rango\n");
	    salida = false;
	  } else {
	    salida = true;
	  }
	} while(!salida);
	system("clear");
	coincidePal(matriz, themes, tema, ini_fila - 1, ini_col - 1,
		    fin_fila - 1, fin_col - 1, palEncontrada);
	imprimirSopa(matriz);
	for(i = 0, respuestas = 0; i < N_PAL; ++i) {
	  if(palEncontrada[i] == true) {
	    ++respuestas;
	  }
	}
	if(respuestas == N_PAL) {
	  victoria = true;
	}
	printf("Quedan %i palabras\n", N_PAL - respuestas);
	if(!victoria) {
	  printf
	      ("¿Quiere seguir jugando? - No (ESC) - Si (cualquier tecla): ");
	  partida = getchar();
	  if(partida == ESC) {
	    printf("Gracias por jugar, vuelva cuando quiera\n");
	    game = false;
	  }
	}
      }
      while(!victoria && game);
      if(game) {
	printf("Felicidades, has ganado\n");
	do {
	  printf("¿Quiere jugar una partida?, [Espacio]-Si [ESC]-No: ");
	  partida = getchar();
	  if(partida == ESC) {
	    printf("Adios\n");
	    game = false;
	  }
	} while(partida != ESP && partida != ESC);
      }
    } else {
      game = false;
    }
  }
}

/**
 *Nombre: solicitaOpcionMenu
 *Description: Muestra el menú
 *@return: opción elegida
 *@author: Luis Pedrosa Ruiz y JoseluCross
 *@date: 12/04/2016
 *@version: 1.0
 */
int solicitaOpcionMenu() {
  int     menu;
  bool    salida = false;
  do {
    printf("Elije un tema\n");
    printf("_____________\n");
    printf("1 - Coches\n");
    printf("2 - Colores\n");
    printf("3 - Formas\n");
    printf("4 - Ciudades\n");
    printf("5 - Países\n");
    printf("0 - Salir\n");
    introduceNum(&menu);
    if(menu < 0 || menu > 5) {
      printf("Valor incorrecto\n");
      salida = false;
    } else {
      salida = true;
    }
  } while(!salida);
  return menu - 1;
}

/**
 *Nombre: crearSopa
 *Description: Genera una matriz 25x25 llena de ceros
 *@param mat[DIM][DIM] - Matriz que contendrá la sopa
 *@author: Luis Pedrosa Ruiz y JoseluCross
 *@date: 05/04/2016
 *@version: 1.0
 */
void crearSopa(int mat[DIM][DIM]) {
  int     i, j;			//horizontal y vertical
  for(i = 0; i < DIM; i++) {
    for(j = 0; j < DIM; j++) {
      mat[i][j] = ZERO;
    }
  }
}

/**
 *Nombre: imprimirSopa
 *Description: Imprime la sopa de letras
 *@param sop[DIM][DIM] - Sopa de letras imprimida
 *@author: Luis Pedrosa Ruiz y JoseluCross
 *@date: 05/04/2016
 *@version: 1.0
 */
void imprimirSopa(int sop[DIM][DIM]) {
  int     i, j;			//Horizontal y vertical
  //Se imprime la fila numeral superior
  for(i = 0; i <= DIM; i++) {
    if(i == 0) {
      printf(" %3c", ESP);
    } else {
      printf("%3i", i);
    }
  }
  printf("\n");
  //Se imprime la fila de guiones superior
  for(i = 0; i <= DIM; i++) {
    if(i == 0) {
      printf(" %3c", ESP);
    } else {
      printf("%3c", DASH);
    }
  }
  printf("\n");
  //Se imprime la sopa y las columnas
  for(i = 0; i < DIM; i++) {
    printf("%3i|", i + 1);
    for(j = 0; j < DIM; j++) {
      if(sop[i][j] < A_MINUS) {
	printf("%3c", sop[i][j]);
      } else {
	printf("\x1b[32m%3c\x1b[0m", sop[i][j]);
      }
    }
    printf("%3c%i", BARRA, i + 1);
    printf("\n");
  }
  //Se imprime la fila de guiones inferior
  for(i = 0; i <= DIM; i++) {
    if(i == 0) {
      printf(" %3c", ESP);
    } else {
      printf("%3c", DASH);
    }
  }
  printf("\n");
  //Se imprime la fila numeral inferior
  for(i = 0; i <= DIM; i++) {
    if(i == 0) {
      printf(" %3c", ESP);
    } else {
      printf("%3i", i);
    }
  }
  printf("\n");
}

/**
 *Nombre: rellenaTemas
 *Description: asigna en una matriz las palabras
 *@param tem[DIM][DIM][TCHAR] - palabra asociada al tema
 *@author: Luis Pedrosa Ruiz y JoseluCross
 *@date: 05/04/2016
 *@version: 1.0.0
 */
void rellenaTemas(char tem[N_TEMA][N_PAL][TCHAR]) {
  //Línea 0 es coches
  strcpy(tem[0][0], "AUDI");
  strcpy(tem[0][1], "MERCEDES");
  strcpy(tem[0][2], "FORD");
  strcpy(tem[0][3], "OPEL");
  strcpy(tem[0][4], "RENAULT");
  strcpy(tem[0][5], "PORSCHE");
  strcpy(tem[0][6], "PEUGEOT");
  strcpy(tem[0][7], "SEAT");
  //Linea 1 es colores
  strcpy(tem[1][0], "ROJO");
  strcpy(tem[1][1], "VERDE");
  strcpy(tem[1][2], "AZUL");
  strcpy(tem[1][3], "AMARILLO");
  strcpy(tem[1][4], "NARANJA");
  strcpy(tem[1][5], "MAGENTA");
  strcpy(tem[1][6], "MARRON");
  strcpy(tem[1][7], "GRIS");
  //Linea 2 es formas
  strcpy(tem[2][0], "CIRCULO");
  strcpy(tem[2][1], "TRIANGULO");
  strcpy(tem[2][2], "CUADRADO");
  strcpy(tem[2][3], "ROMBO");
  strcpy(tem[2][4], "ELIPSE");
  strcpy(tem[2][5], "PENTAGONO");
  strcpy(tem[2][6], "RECTANGULO");
  strcpy(tem[2][7], "TRAPECIO");
  //Linea 3 es ciudades
  strcpy(tem[3][0], "MADRID");
  strcpy(tem[3][1], "BARCELONA");
  strcpy(tem[3][2], "BILBAO");
  strcpy(tem[3][3], "ZARAGOZA");
  strcpy(tem[3][4], "BURGOS");
  strcpy(tem[3][5], "FERROL");
  strcpy(tem[3][6], "JAEN");
  strcpy(tem[3][7], "CORDOBA");
  //Linea 4 es países
  strcpy(tem[4][0], "INGLATERRA");
  strcpy(tem[4][1], "ARGELIA");
  strcpy(tem[4][2], "ITALIA");
  strcpy(tem[4][3], "FRANCIA");
  strcpy(tem[4][4], "MARRUECOS");
  strcpy(tem[4][5], "CUBA");
  strcpy(tem[4][6], "ECUADOR");
  strcpy(tem[4][7], "RUSIA");
}

/**
 *Nombre: buscaAleatorio
 *Description: Genera un aleatorio entre dos valores
 *@param max: valor máximo
 *@param min: valor mínimo
 *@return: número aleatorio
 *@author: Carlos Pardo
 *@date: 12/04/2016
 */
int buscaAleatorio(int min, int max) {
  return (rand() / (1.0 + RAND_MAX) * (1 + max - min) + min);
}

/**
 *Nombre: colocaPalabras
 *Description: colocamos las palabras en la matriz
 *@param sople: sopa de letras
 *@param palab: palabra del tema
 *@param te:   tema escogido
 *@author: Luis Pedrosa Ruiz y JoseluCross
 *@date: 12/04/2016
 */
void colocaPalabras(int sople[DIM][DIM], char palab[N_TEMA][N_PAL][TCHAR],
		    int te) {
  int     i;
  for(i = 0; i < N_PAL; i++) {
    colocaPalabra(sople, palab[te][i], buscaAleatorio(1, 8));
  }
}

/**
 *Nombre: colocaPalabra
 *Description: coloca la palabra en la sopa
 *@param sopi: sopa de letra
 *@param pala: palabra
 *@param direccion: dirección de la palabra
 *@author: Luis Pedrosa Ruiz y JoseluCross
 *@date: 12/04/2016
 */
void colocaPalabra(int sopi[DIM][DIM], char pala[TCHAR], int direccion) {
  int     fila, columna, i, j = 0, k;
  bool    e;
  do {
    fila = buscaAleatorio(0, DIM - 1);
    columna = buscaAleatorio(0, DIM - 1);
    e = esPosibleColocarPalabra(sopi, pala, direccion, columna, fila);
  } while(!e);
  switch (direccion) {
    case 1:			//derecha
      for(i = columna; i < (columna + (int)strlen(pala)); i++) {
	sopi[fila][i] = (int)pala[j];
	j++;
      }
      break;
    case 2:			//izquierda
      for(i = columna; i > (columna - (int)strlen(pala)); i--) {
	sopi[fila][i] = (int)pala[j];
	j++;
      }
      break;
    case 3:			//abajo
      for(i = fila; i < (fila + (int)strlen(pala)); i++) {
	sopi[i][columna] = (int)pala[j];
	j++;
      }
      break;
    case 4:			//arriba
      for(i = fila; i > (fila - (int)strlen(pala)); i--) {
	sopi[i][columna] = (int)pala[j];
	j++;
      }
      break;
    case 5:			//diagonal derecha abajo
      for(i = fila, k = columna; i < (fila + (int)strlen(pala)); i++, k++) {
	sopi[i][k] = (int)pala[j];
	j++;
      }
      break;
    case 6:			//diagonal derecha arriba
      for(i = fila, k = columna; i > (fila - (int)strlen(pala)); i--, k++) {
	sopi[i][k] = (int)pala[j];
	j++;
      }
      break;
    case 7:			//diagonal izquierda abajo
      for(i = fila, k = columna; i < (fila + (int)strlen(pala)); i++, k--) {
	sopi[i][k] = (int)pala[j];
	j++;
      }
      break;
    case 8:			//diagonal izquierda arriba
      for(i = fila, k = columna; i > (fila - (int)strlen(pala)); i--, k--) {
	sopi[i][k] = (int)pala[j];
	j++;
      }
      break;
  }
}

/**
 *Nombre: esPosibleColocarPalabra
 *Descripción: comprueba si se puede poner la palabra en la sopa
 *@param so: la sopa de letras
 *@param p: palabra que metemos
 *@param dir: dirección
 *@param col: columna de la matriz
 *@param fil: fila de la matriz
 *@return: 1 si cabe, 0 si no
 *@author: Luis Pedrosa Ruiz JoseluCross
 *@date: 12/04/2016
 */
bool esPosibleColocarPalabra(int so[DIM][DIM], char p[TCHAR], int dir,
			     int col, int fil) {
  bool    error = true;
  int     i, j, k;
  switch (dir) {
    case 1:			//derecha
      if(col + (int)strlen(p) > DIM) {
	error = false;
      } else {
	for(i = col, j = 0; i <= col + (int)strlen(p); i++, j++) {
	  if(so[fil][i] != ZERO) {
	    if(p[j] != so[fil][i]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 2:			//izquierda
      if(col - (int)strlen(p) < 0) {
	error = false;
      } else {
	for(i = col, j = 0; i >= col - (int)strlen(p); i--, j++) {
	  if(so[fil][i] != ZERO) {
	    if(p[j] != so[fil][i]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 3:			//abajo
      if(fil + (int)strlen(p) > DIM) {
	error = false;
      } else {
	for(i = fil, j = 0; i <= fil + (int)strlen(p); i++, j++) {
	  if(so[i][col] != ZERO) {
	    if(p[j] != so[i][col]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 4:			//arriba
      if(fil - (int)strlen(p) < 0) {
	error = false;
      } else {
	for(i = fil, j = 0; i >= fil - (int)strlen(p); i--, j++) {
	  if(so[i][col] != ZERO) {
	    if(p[j] != so[i][col]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 5:			//Diagonal derecha abajo
      if(fil + (int)strlen(p) > DIM || col + (int)strlen(p) > DIM) {
	error = false;
      } else {
	for(i = fil, j = col, k = 0;
	    i <= fil + (int)strlen(p); i++, j++, k++) {
	  if(so[i][j] != ZERO) {
	    if(p[k] != so[i][j]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 6:			//Diagonal derecha arriba
      if(fil - (int)strlen(p) < 0 || col + (int)strlen(p) > DIM) {
	error = false;
      } else {
	for(i = fil, j = col, k = 0;
	    i >= fil - (int)strlen(p); i--, j++, k++) {
	  if(so[i][j] != ZERO) {
	    if(p[k] != so[i][j]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 7:			//Diagonal izquierda abajo
      if(fil + (int)strlen(p) > DIM || col - (int)strlen(p) < 0) {
	error = false;
      } else {
	for(i = fil, j = col, k = 0;
	    i <= fil + (int)strlen(p); i++, j--, k++) {
	  if(so[i][j] != ZERO) {
	    if(p[k] != so[i][j]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 8:			//Diagonal izquierda arriba
      if(fil - (int)strlen(p) < 0 || col - (int)strlen(p) < 0) {
	error = false;
      } else {
	for(i = fil, j = col, k = 0;
	    i >= fil - (int)strlen(p); i--, j--, k++) {
	  if(so[i][j] != ZERO) {
	    if(p[k] != so[i][j]) {
	      error = false;
	    }
	  }
	}
      }
      break;
  }
  return error;
}

/**
 *Nombre: rellenaMatriz
 *Descripción: los "0" restantes se convierten en un caracter entre A y Z
 *@param sopaLetras: la sopa de letras
 *@author: JoseluCross y Luis Pedrosa Ruiz
 *@date: 23/04/2016
 */
void rellenaMatriz(int sopa[DIM][DIM]) {
  int     i, j;
  for(i = 0; i < DIM; i++) {
    for(j = 0; j < DIM; j++) {
      if(sopa[i][j] == ZERO) {
	sopa[i][j] = buscaAleatorio(CHAR_MIN, CHAR_MAX);
      }
    }
  }
}

/**
  *Nombre: introduceNum
  *Description: Introduce un número a donde mande el puntero
  *@param *num: número introducido
  *@author: Luis Pedrosa Ruiz y JoseluCross
  *@date: 26/04/2016
  */
void introduceNum(int *num) {
  char    c;
  bool    salida = false;
  do {
    if(scanf("%d%c", num, &c) != 2 || c != '\n') {
      printf("Opción incorrecta. Introduzca un nuevo valor: ");
      clean_stdin();
    } else {
      salida = true;
    }
  } while(!salida);
}

/**
  *Nombre: coincidePal
  *Descripción: compara la cadena introducida por el usuario y compara con las cadenas
  *@param: matrix - sopa de letras
  *@param: palabras - matriz de las palabras por temas
  *@param: t - tema
  *@param: iF - coordenada fila inicial
  *@param: iC - coordenada columna inicial
  *@param: fF - coordenada fila final
  *@param: fC - coordenada columna final
  *@param: find - palabras encontradas
  *@autor: Luis Pedrosa Ruiz y José Luis Garrido Labrador
  *@date: 26/04/2016
  */
void coincidePal(int matrix[DIM][DIM],
		 char palabras[N_TEMA][N_PAL][TCHAR], int t,
		 int iF, int iC, int fF, int fC, bool find[N_PAL]) {
  int     i, j, k, dir, repair;	//Contadores y variables auxiliares
  bool    rec = false, norec = true;	//Variables de conrol
  char    pal[TCHAR];

  dir = sentido(iF, fF, iC, fC);
  repair = dir;

  switch (dir) {
    case 0:			//Dirección equivocada
      norec = false;
    case 1:			//Derecha
      for(i = iC, j = 0; i <= fC; ++i, ++j) {
	pal[j] = (char)matrix[iF][i];
	if((int)pal[j] >= A_MINUS) {
	  pal[j] -= (A_MINUS - CHAR_MAX);
	}
      } pal[j + 1] = '\0';
      break;
    case 2:			//Izquierda
      for(i = iC, j = 0; i >= fC; --i, ++j) {
	pal[j] = (char)matrix[iF][i];
	if((int)pal[j] >= A_MINUS) {
	  pal[j] -= (A_MINUS - CHAR_MAX);
	}
      }
      pal[j + 1] = '\0';
      break;
    case 3:			//Abajo
      for(i = iF, j = 0; i <= fF; ++i, ++j) {
	pal[j] = (char)matrix[i][iC];
	if((int)pal[j] >= A_MINUS) {
	  pal[j] -= (A_MINUS - CHAR_MAX);
	}
      }
      pal[j + 1] = '\0';
      break;
    case 4:			//Arriba
      for(i = iF, j = 0; i >= fF; --i, ++j) {
	pal[j] = (char)matrix[i][iC];
	if((int)pal[j] >= A_MINUS) {
	  pal[j] -= (A_MINUS - CHAR_MAX);
	}
      }
      pal[j + 1] = '\0';
      break;
    case 5:			//Abajo derecha
      for(i = iF, k = iC, j = 0; i <= fF; ++i, ++k, ++j) {
	pal[j] = (char)matrix[i][k];
	if((int)pal[j] >= A_MINUS) {
	  pal[j] -= (A_MINUS - CHAR_MAX);
	}
      }
      pal[j + 1] = '\0';
      break;
    case 6:			//Arriba derecha
      for(i = iF, k = iC, j = 0; i >= fF; --i, ++k, ++j) {
	pal[j] = (char)matrix[i][k];
	if((int)pal[j] >= A_MINUS) {
	  pal[j] -= (A_MINUS - CHAR_MAX);
	}
      }
      pal[j + 1] = '\0';
      break;
    case 7:			//Abajo izquierda
      for(i = iF, k = iC, j = 0; i <= fF; ++i, --k, ++j) {
	pal[j] = (char)matrix[i][k];
	if((int)pal[j] >= A_MINUS) {
	  pal[j] -= (A_MINUS - CHAR_MAX);
	}
      }
      pal[j + 1] = '\0';
      break;
    case 8:			//Arriba izquierda
      for(i = iF, k = iC, j = 0; i >= fF; --i, --k, ++j) {
	pal[j] = (char)matrix[i][k];
	if((int)pal[j] >= A_MINUS) {
	  pal[j] -= (A_MINUS - CHAR_MAX);
	}
      }
      pal[j + 1] = '\0';
      break;
  }
  //Comparamos buscando si conicide
  for(i = 0; i < N_PAL && !rec && norec; ++i) {
    //puts(pal);                        //debug
    if(strncmp(palabras[t][i], pal, (int)strlen(palabras[t][i])) == 0) {
      find[i] = true;
      rec = true;
      //printf("%i\n", i);//debug
    }
  }
  if(rec) {
    printf("Palabra %s correcta\n", palabras[t][i - 1]);
    minuscula(matrix, iF, iC, fF, fC, dir);
  } else {
    printf("Palabra incorrecta\n");
  }

}

/**
  *Nombre: minuscula
  *Descripción: convierte una sección de la matriz en minuscula
  *@param: m - sopa de letras
  *@param: iF - coordenada fila inicial
  *@param: iC - coordenada columna inicial
  *@param: fF - coordenada fila final
  *@param: fC - coordenada columna final
  *@param: dir - dirección
  *@autor: Luis Pedrosa Ruiz y José Luis Garrido Labrador
  *@date: 26/04/2016
  */
void minuscula(int m[DIM][DIM], int iF, int iC, int fF, int fC, int dir) {
  int     i, j;
  switch (dir) {
    case 1:			//Derecha
      for(i = iC; i <= fC; ++i) {
	if(m[iF][i] < A_MINUS) {
	  m[iF][i] += (A_MINUS - CHAR_MAX);
	}
      }
      break;
    case 2:			//Izquierda
      for(i = iC; i >= fC; --i) {
	if(m[iF][i] < A_MINUS) {
	  m[iF][i] += (A_MINUS - CHAR_MAX);
	}
      }
      break;
    case 3:			//Abajo
      for(i = iF; i <= fF; ++i) {
	if(m[i][iC] < A_MINUS) {
	  m[i][iC] += (A_MINUS - CHAR_MAX);
	}
      }
      break;
    case 4:			//Arriba
      for(i = iF; i >= fF; --i) {
	if(m[i][iC] < A_MINUS) {
	  m[i][iC] += (A_MINUS - CHAR_MAX);
	}
      }
      break;
    case 5:			//Abajo derecha
      for(i = iF, j = iC; i <= fF; ++i, ++j) {
	if(m[i][j] < A_MINUS) {
	  m[i][j] += (A_MINUS - CHAR_MAX);
	}
      }
      break;
    case 6:			//Arriba derecha
      for(i = iF, j = iC; i >= fF; --i, ++j) {
	if(m[i][j] < A_MINUS) {
	  m[i][j] += (A_MINUS - CHAR_MAX);
	}
      }
      break;
    case 7:			//Abajo izquierda
      for(i = iF, j = iC; i <= fF; ++i, --j) {
	if(m[i][j] < A_MINUS) {
	  m[i][j] += (A_MINUS - CHAR_MAX);
	}
      }
      break;
    case 8:			//Arriba izquierda
      for(i = iF, j = iC; i >= fF; --i, --j) {
	if(m[i][j] < A_MINUS) {
	  m[i][j] += (A_MINUS - CHAR_MAX);
	}
      }
      break;
  }
}

/**
 *Title: sentido
 *Descripción: Dice en que sentido está las cordenadas especificadas
 *@param: iX = inicio del eje x
 *@param: fX = final del eje x
 *@param: iY = inicio del eje y
 *@param: fY = final del eje y
 *@return: sent
 *@author: JoseluCross y Luis Pedrosa Ruiz
 *@date: 26/04/2016
 */
int sentido(int iX, int fX, int iY, int fY) {
  int     sent;
  if(iX != fX) {
    if(iY != fY) {		//Diagonales
      if(fY > iY) {
	if(fX > iX) {
	  if((fX - iX) != (fY - iY)) {
	    sent = 0;
	  } else {
	    sent = 5;		//Abajo y a la derecha
	  }
	} else {
	  if((iX - fX) != (fY - iY)) {
	    sent = 0;
	  } else {
	    sent = 6;		//Arriba y a la derecha
	  }
	}
      } else {
	if(fX > iX) {
	  if((fX - iX) != (iY - fY)) {
	    sent = 0;
	  } else {
	    sent = 7;		//Abajo y a la izquierda
	  }
	} else {
	  if((iX - fX) != (iY - fY)) {
	    sent = 0;
	  } else {
	    sent = 8;		//Arriba y a la izquierda
	  }
	}
      }

    } else {			//Vertical
      if(fX >= iX) {
	sent = 3;		//Abajo
      } else {
	sent = 4;		//Arriba
      }
    }
  } else {			//Horizontal
    if(fY >= iY) {
      sent = 1;			//Derecha
    } else {
      sent = 2;			//Izquierda
    }
  }
  return sent;
}
