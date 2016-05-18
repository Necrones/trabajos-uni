/**
 *Title: Sopa de letras
 *Description: Hace una sopa de letras con varios temas
 *@Author: Luis Pedrosa Ruiz y José Luis Garrido Labrador (JoseluCross)
 *@organization: UBU
 *@Version: 2.0.0
 *@Date: 05/04/2016
 */
//Librerías
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdbool.h>
#include <stdlib.h>
//Constantes
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
//Registros
typedef struct {
  char    palabra[TCHAR];
  int     fila_inicio;
  int     columna_inicio;
  int     fila_final;
  int     columna_final;
  int     direccion;
} Palabra;
//Prototipos
void    crearSopa(int[DIM][DIM]);
void    imprimirSopa(int[DIM][DIM]);
void    rellenaTemas(Palabra[N_TEMA][N_PAL]);
int     solicitaOpcionMenu(void);
int     clean_stdin(void);
void    colocaPalabras(int[DIM][DIM], Palabra[N_PAL]);
void    colocaPalabra(int[DIM][DIM], Palabra *, int);
void    rellenaMatriz(int[DIM][DIM]);
int     buscaAleatorio(int, int);
bool    esPosibleColocarPalabra(int[DIM][DIM], Palabra, int, int);
void    introduceNum(int *);
void    coincidePal(int[DIM][DIM], Palabra[N_PAL], int,
		    int, int, int, bool[N_PAL]);
void    juego(int[DIM][DIM], Palabra[N_TEMA][N_PAL]);
void    minuscula(int[DIM][DIM], int, int, int, int, int);
int     sentido(int, int, int, int);

int main() {
  srand(time(NULL));
  //srand(22);                  //Cruce en coches y colores
  int     sopa[DIM][DIM];
  Palabra temas[N_TEMA][N_PAL];
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
void juego(int matriz[DIM][DIM], Palabra themes[N_TEMA][N_PAL]) {
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
      colocaPalabras(matriz, themes[tema]);
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
	coincidePal(matriz, themes[tema], ini_fila - 1, ini_col - 1,
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
	  } else if(partida == ESP) {
	    victoria = false;
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
void rellenaTemas(Palabra tem[N_TEMA][N_PAL]) {
  //Línea 0 es coches
  strcpy(tem[0][0].palabra, "AUDI");
  strcpy(tem[0][1].palabra, "MERCEDES");
  strcpy(tem[0][2].palabra, "FORD");
  strcpy(tem[0][3].palabra, "OPEL");
  strcpy(tem[0][4].palabra, "RENAULT");
  strcpy(tem[0][5].palabra, "PORSCHE");
  strcpy(tem[0][6].palabra, "PEUGEOT");
  strcpy(tem[0][7].palabra, "SEAT");
  //Linea 1 es colores
  strcpy(tem[1][0].palabra, "ROJO");
  strcpy(tem[1][1].palabra, "VERDE");
  strcpy(tem[1][2].palabra, "AZUL");
  strcpy(tem[1][3].palabra, "AMARILLO");
  strcpy(tem[1][4].palabra, "NARANJA");
  strcpy(tem[1][5].palabra, "MAGENTA");
  strcpy(tem[1][6].palabra, "MARRON");
  strcpy(tem[1][7].palabra, "GRIS");
  //Linea 2 es formas
  strcpy(tem[2][0].palabra, "CIRCULO");
  strcpy(tem[2][1].palabra, "TRIANGULO");
  strcpy(tem[2][2].palabra, "CUADRADO");
  strcpy(tem[2][3].palabra, "ROMBO");
  strcpy(tem[2][4].palabra, "ELIPSE");
  strcpy(tem[2][5].palabra, "PENTAGONO");
  strcpy(tem[2][6].palabra, "RECTANGULO");
  strcpy(tem[2][7].palabra, "TRAPECIO");
  //Linea 3 es ciudades
  strcpy(tem[3][0].palabra, "MADRID");
  strcpy(tem[3][1].palabra, "BARCELONA");
  strcpy(tem[3][2].palabra, "BILBAO");
  strcpy(tem[3][3].palabra, "ZARAGOZA");
  strcpy(tem[3][4].palabra, "BURGOS");
  strcpy(tem[3][5].palabra, "FERROL");
  strcpy(tem[3][6].palabra, "JAEN");
  strcpy(tem[3][7].palabra, "CORDOBA");
  //Linea 4 es países
  strcpy(tem[4][0].palabra, "INGLATERRA");
  strcpy(tem[4][1].palabra, "ARGELIA");
  strcpy(tem[4][2].palabra, "ITALIA");
  strcpy(tem[4][3].palabra, "FRANCIA");
  strcpy(tem[4][4].palabra, "MARRUECOS");
  strcpy(tem[4][5].palabra, "CUBA");
  strcpy(tem[4][6].palabra, "ECUADOR");
  strcpy(tem[4][7].palabra, "RUSIA");
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
void colocaPalabras(int sople[DIM][DIM], Palabra palab[N_PAL]) {
  int     i;
  for(i = 0; i < N_PAL; i++) {
    palab[i].direccion = buscaAleatorio(1, 8);
    colocaPalabra(sople, &palab[i], palab[i].direccion);
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
void colocaPalabra(int sopi[DIM][DIM], Palabra * pala, int direccion) {
  int     fila, columna, i, j = 0, k;
  do {
    fila = buscaAleatorio(0, DIM - 1);
    columna = buscaAleatorio(0, DIM - 1);
  } while(!(esPosibleColocarPalabra(sopi, *pala, columna, fila)));
  ((*pala)).fila_inicio = fila;
  (*pala).columna_inicio = columna;
  switch (direccion) {
    case 1:			//derecha
      for(i = (*pala).columna_inicio;
	  i < ((*pala).columna_inicio + (int)strlen((*pala).palabra));
	  i++) {
	sopi[(*pala).fila_inicio][i] = (int)(*pala).palabra[j];
	j++;
      }
      (*pala).fila_final = (*pala).fila_inicio;
      (*pala).columna_final = i - 1;
      break;
    case 2:			//izquierda
      for(i = (*pala).columna_inicio;
	  i > ((*pala).columna_inicio - (int)strlen((*pala).palabra));
	  i--) {
	sopi[(*pala).fila_inicio][i] = (int)(*pala).palabra[j];
	j++;
      }
      (*pala).fila_final = (*pala).fila_inicio;
      (*pala).columna_final = i + 1;
      break;
    case 3:			//abajo
      for(i = (*pala).fila_inicio;
	  i < ((*pala).fila_inicio + (int)strlen((*pala).palabra)); i++) {
	sopi[i][(*pala).columna_inicio] = (int)(*pala).palabra[j];
	j++;
      }
      (*pala).fila_final = i - 1;
      (*pala).columna_final = (*pala).columna_inicio;
      break;
    case 4:			//arriba
      for(i = (*pala).fila_inicio;
	  i > ((*pala).fila_inicio - (int)strlen((*pala).palabra)); i--) {
	sopi[i][(*pala).columna_inicio] = (int)(*pala).palabra[j];
	j++;
      }
      (*pala).fila_final = i + 1;
      (*pala).columna_final = (*pala).columna_inicio;
      break;
    case 5:			//diagonal derecha abajo
      for(i = (*pala).fila_inicio, k = (*pala).columna_inicio;
	  i < ((*pala).fila_inicio + (int)strlen((*pala).palabra));
	  i++, k++) {
	sopi[i][k] = (int)(*pala).palabra[j];
	j++;
      }
      (*pala).fila_final = i - 1;
      (*pala).columna_final = k - 1;
      break;
    case 6:			//diagonal derecha arriba
      for(i = (*pala).fila_inicio, k = (*pala).columna_inicio;
	  i > ((*pala).fila_inicio - (int)strlen((*pala).palabra));
	  i--, k++) {
	sopi[i][k] = (int)(*pala).palabra[j];
	j++;
      }
      (*pala).fila_final = i + 1;
      (*pala).columna_final = k - 1;
      break;
    case 7:			//diagonal izquierda abajo
      for(i = (*pala).fila_inicio, k = (*pala).columna_inicio;
	  i < ((*pala).fila_inicio + (int)strlen((*pala).palabra));
	  i++, k--) {
	sopi[i][k] = (int)(*pala).palabra[j];
	j++;
      }
      (*pala).fila_final = i - 1;
      (*pala).columna_final = k + 1;
      break;
    case 8:			//diagonal izquierda arriba
      for(i = (*pala).fila_inicio, k = (*pala).columna_inicio;
	  i > ((*pala).fila_inicio - (int)strlen((*pala).palabra));
	  i--, k--) {
	sopi[i][k] = (int)(*pala).palabra[j];
	j++;
      }
      (*pala).fila_final = i + 1;
      (*pala).columna_final = k + 1;
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
bool esPosibleColocarPalabra(int so[DIM][DIM], Palabra p, int col, int fil) {
  bool    error = true;
  int     i, j, k;
  switch (p.direccion) {
    case 1:			//derecha
      if(col + (int)strlen(p.palabra) > DIM) {
	error = false;
      } else {
	for(i = col, j = 0; i <= col + (int)strlen(p.palabra); i++, j++) {
	  if(so[fil][i] != ZERO) {
	    if(p.palabra[j] != so[fil][i]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 2:			//izquierda
      if(col - (int)strlen(p.palabra) < 0) {
	error = false;
      } else {
	for(i = col, j = 0; i >= col - (int)strlen(p.palabra); i--, j++) {
	  if(so[fil][i] != ZERO) {
	    if(p.palabra[j] != so[fil][i]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 3:			//abajo
      if(fil + (int)strlen(p.palabra) > DIM) {
	error = false;
      } else {
	for(i = fil, j = 0; i <= fil + (int)strlen(p.palabra); i++, j++) {
	  if(so[i][col] != ZERO) {
	    if(p.palabra[j] != so[i][col]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 4:			//arriba
      if(fil - (int)strlen(p.palabra) < 0) {
	error = false;
      } else {
	for(i = fil, j = 0; i >= fil - (int)strlen(p.palabra); i--, j++) {
	  if(so[i][col] != ZERO) {
	    if(p.palabra[j] != so[i][col]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 5:			//Diagonal derecha abajo
      if(fil + (int)strlen(p.palabra) > DIM
	 || col + (int)strlen(p.palabra) > DIM) {
	error = false;
      } else {
	for(i = fil, j = col, k = 0;
	    i <= fil + (int)strlen(p.palabra); i++, j++, k++) {
	  if(so[i][j] != ZERO) {
	    if(p.palabra[k] != so[i][j]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 6:			//Diagonal derecha arriba
      if(fil - (int)strlen(p.palabra) < 0
	 || col + (int)strlen(p.palabra) > DIM) {
	error = false;
      } else {
	for(i = fil, j = col, k = 0;
	    i >= fil - (int)strlen(p.palabra); i--, j++, k++) {
	  if(so[i][j] != ZERO) {
	    if(p.palabra[k] != so[i][j]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 7:			//Diagonal izquierda abajo
      if(fil + (int)strlen(p.palabra) > DIM
	 || col - (int)strlen(p.palabra) < 0) {
	error = false;
      } else {
	for(i = fil, j = col, k = 0;
	    i <= fil + (int)strlen(p.palabra); i++, j--, k++) {
	  if(so[i][j] != ZERO) {
	    if(p.palabra[k] != so[i][j]) {
	      error = false;
	    }
	  }
	}
      }
      break;
    case 8:			//Diagonal izquierda arriba
      if(fil - (int)strlen(p.palabra) < 0
	 || col - (int)strlen(p.palabra) < 0) {
	error = false;
      } else {
	for(i = fil, j = col, k = 0;
	    i >= fil - (int)strlen(p.palabra); i--, j--, k++) {
	  if(so[i][j] != ZERO) {
	    if(p.palabra[k] != so[i][j]) {
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
	sopa[i][j] = buscaAleatorio(CHAR_MIN, CHAR_MAX);	//Comportamiento normal
	//sopa[i][j] = ESP;     //Para una correción más fácil
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
		 Palabra palabras[N_PAL],
		 int iF, int iC, int fF, int fC, bool find[N_PAL]) {
  int     i;			//Contadores y variables auxiliares
  bool    rec = false;		// norec = true;  //Variables de conrol
  //char    pal[TCHAR];
  for(i = 0; i < N_PAL && !rec; ++i) {
    if(palabras[i].fila_inicio == iF && palabras[i].columna_inicio == iC
       && palabras[i].fila_final == fF
       && palabras[i].columna_final == fC) {
      rec = true;
      find[i] = true;
    }
  }
  if(rec) {
    printf("Palabra %s correcta\n", palabras[i - 1].palabra);
    minuscula(matrix, iF, iC, fF, fC, palabras[i - 1].direccion);
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
	  m[iF][i] += (A_MINUS - CHAR_MIN);
	}
      }
      break;
    case 2:			//Izquierda
      for(i = iC; i >= fC; --i) {
	if(m[iF][i] < A_MINUS) {
	  m[iF][i] += (A_MINUS - CHAR_MIN);
	}
      }
      break;
    case 3:			//Abajo
      for(i = iF; i <= fF; ++i) {
	if(m[i][iC] < A_MINUS) {
	  m[i][iC] += (A_MINUS - CHAR_MIN);
	}
      }
      break;
    case 4:			//Arriba
      for(i = iF; i >= fF; --i) {
	if(m[i][iC] < A_MINUS) {
	  m[i][iC] += (A_MINUS - CHAR_MIN);
	}
      }
      break;
    case 5:			//Abajo derecha
      for(i = iF, j = iC; i <= fF; ++i, ++j) {
	if(m[i][j] < A_MINUS) {
	  m[i][j] += (A_MINUS - CHAR_MIN);
	}
      }
      break;
    case 6:			//Arriba derecha
      for(i = iF, j = iC; i >= fF; --i, ++j) {
	if(m[i][j] < A_MINUS) {
	  m[i][j] += (A_MINUS - CHAR_MIN);
	}
      }
      break;
    case 7:			//Abajo izquierda
      for(i = iF, j = iC; i <= fF; ++i, --j) {
	if(m[i][j] < A_MINUS) {
	  m[i][j] += (A_MINUS - CHAR_MIN);
	}
      }
      break;
    case 8:			//Arriba izquierda
      for(i = iF, j = iC; i >= fF; --i, --j) {
	if(m[i][j] < A_MINUS) {
	  m[i][j] += (A_MINUS - CHAR_MIN);
	}
      }
      break;
  }
}
