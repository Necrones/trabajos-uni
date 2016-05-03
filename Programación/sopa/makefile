#archivo para ejecutar en las prácticas de programación de 1º del GºII
#v 2014/15 para Linux
#by CPA@LSI.IngCivil.UBu CC.BY-NC-SA 3.0
	#archivos
EXE=sopa
TARFILE=../$(EXE).tbz2
OBJS=
HEADS=c_facil.h
IND_RC=.indent.pro #fichero de configuración las sangrias
SRCS=*.[hc]
TMPS=*.o #test
HTMLS=$(SRCS).html makefile.html
BAKDIR=.bak
	#opciones
PURGE_OP=2#nº de archivos a no purgar
	#comandos del sistema
CLS=clear
LS=ls -t #
LSR=ls -tr #
MV=mv #
RM=rm #
NULL=>/dev/null
NOERR=2$(NULL)
	#comandos de compilación, enlazado y presentación
TEST_VERSION=test v_$(VERSION_CONTROL) != v_numbered
INDENT=indent #
CFLAGS=-Wall #opciones de compilación
CC=cc -c $(CFLAGS)#
CPP=cpp -D _STDIO_H -D _MATH_H -D _TERMIOS_H #no expandir <stdio.h> <math.h>
LFLAGS=-lm #opciones de enlazado con las librerías
LN=cc #
TOHTML=gvim -c"set number" -c"TOhtml" -c"x" -c"q" #
NAVEGADOR=firefox #
	#colores y comandos de presentación
INI="\033[1m"
ECHO=echo $(INI)
INICOLOR=echo -n $(INI)
FIN="\033[0m"
FINCOLOR=echo -n $(FIN)
ERR=\x1b[31m
WAR=\x1b[35m
REF=\x1b[33m
COLORPIPE=2>&1|sed -e's/.*/\x1b[1m&\x1b[0m/i' -e's/ \bERR.*/$(ERR)&/i' -e's/ \bAVISO.*/$(WAR)&/i' -e's/.*\bundefined.*/$(REF)&/i'>&2
#FF=\x1b[0m\x1b[1m
#COLORPIPE=2>&1|sed -e's/ \bERR.*/$(ERR)&$(FF)/i' -e's/ \bAVISO.*/$(WAR)&$(FF)/i' -e's/.*\bundefined.*/$(REF)&$(FF)/i'>&2;$(FINCOLOR)
	#otros comandos
CHGEXE=$(ECHO);read -p "Introduce el nombre del nuevo ejecutable " e && (cat makefile|sed -e"s/^\(EXE=\).*/\1$$e/">.mk.tmp) && $(MV)makefile makefile~ && $(MV).mk.tmp makefile;$(FINCOLOR)
TAR=tar -cvjf $(TARFILE) #
UNTAR=tar -xjf $(TARFILE) #
SWPS=$(LS).*.swp
CIERRA_ED=($(SWPS) $(NOERR) && (echo " Aviso:\tarchivo/s abierto/s «"`$(SWPS)|sed -e's/^.\(.*\).swp/\1/'`"»\n\tcierralo/s y vuelve a hacer make $@"$(COLORPIPE)))
OLDFILES=$(LSR)$$f.~[0-9]*~ $(NOERR)|head -n-$(PURGE_OP)
	#mensajes
MSG_NUMBERED=$(ECHO)"error:\t  variable de estado no configurada.\nEjecuta:\n$$ VERSION_CONTROL=numbered; export VERSION_CONTROL"$(FIN)
UP=[A
REC=[s$(UP)
BK=[u
BKCLS=$(BK)[J$(UP)
B=[1m#negrita
D=[0m#
DONE1= $B               ¡       #
DONE2=!$D#
MA= $B      make #
KE=$D	#
BR= 			#

all:  $(EXE)
	#$(REC)
	time ./$< #$(BK)./$<
	#$(DONE1)$< EJECUTADO OK             	$(DONE2)

$(EXE):  $(EXE).o $(OBJS)
	#
	#$(UP)$(REC)
	$(LN)-o $@ $^ $(LFLAGS)$(COLORPIPE) #$(BKCLS)
	$(LN)-o $@ $^ $(LFLAGS)$(NOERR)
	#$(DONE1)BIBLIOTECAS ENLAZADAS $@    	$(DONE2)

%.o:  %.c $(HEADS)
	#
	#
	#[2A$(REC)
	if $(TEST_VERSION);then $(MSG_NUMBERED);exit 1;fi #$(BKCLS)
	$(INDENT)$< $(COLORPIPE)
	if test ! -d $(BAKDIR); then mkdir $(BAKDIR); fi
	#
	#[2A$(REC)
	for f in $<;do if test `$(OLDFILES)|head -1`; then $(MV)`$(OLDFILES)` $(BAKDIR);fi done; #$(BKCLS)
	#$(DONE1)$< MAQUETADO OK           	$(DONE2)
	#
	#$(UP)$(REC)
	$(CC)$< $(COLORPIPE)	#$(BKCLS)
	$(CC)$< $(NOERR)
	#$(DONE1)$@ COMPILADO OK           	$(DONE2)

$(EXE).c:
	echo '/*Título: '>$@	#$(UP)
	echo ' *Descripción: '>>$@	#$(UP)
	echo ' *Autor: José Luis Garrido Labrador (JoseluCross)'>>$@	#$(UP)
	echo ' *Version: 1.0 - '`date +"%b/%y"'*/'`>>$@ #$(UP)
	echo '#include <stdio.h>'>>$@                                    #$(UP)
	echo ''>>$@	#$(UP)
	echo 'int main() {'>>$@	#$(UP)
	echo '  return 0;'>>$@	#$(UP)
	echo '}'>>$@	#$(UP)
	notepadqq $@ $(NOERR)&
	$(ECHO)vuelve a ejecutar make después de grabar archivo $@$(FIN)&& exit 1

help:
	#$(MA)help$(KE)muestra este mensaje con la sintaxis.
	#$(MA)-n [regla]$(KE)muestra los comandos para obtener una regla, sin
	#$(BR)ejecutarlos.
	#$(MA)setexe$(KE)actualiza «makefile» cambiando la regla con el nombre
	#$(BR)del ejecutable.
	#$(MA)$(EXE).o$(KE)crea/recrea el archivo objeto «$(EXE).o» compilando,
	#$(BR)maquetando y versionando el archivo fuente si cambió.
	#$(MA)$(EXE)$(KE)crea/recrea el archivo ejecutable «$(EXE)» enlazando
	#$(BR)con las bibliotecas el archivo objeto si cambió
	#$(BR)(implica previo [1mmake $(EXE).o[0m).
	#$(MA)	$(KE)ejecuta «./$(EXE)» (implica previo [1mmake $(EXE)[0m).
	#$(MA)entrega$(KE)crea un archivo comprimido «[1m$(TARFILE)[0m»
	#$(BR)para llevarnos/entregar la práctica.
	#$(MA)indent$(KE)maqueta los nuevos archivos fuente del directorio
	#$(MA)html$(KE)crea y muestra archivos fuentes coloreados «.html».
	#$(MA)cpp $(KE)muestra los archivos fuentes expandiendo las directivas.
	#$(MA)purge_all$(KE)elimina todas las copias de seguridad.
	#$(MA)clear$(KE)elimina los ficheros compilados
	#$(BR)(próximo make => rebuild	).

setexe:
	$(LSR)$(SRCS);$(CHGEXE)
	make help

entrega:
	$(TAR).;$(INICOLOR);$(CIERRA_ED)||$(ECHO)done, descomprimir: $$ $(UNTAR).$(FIN)

indent:  $(SRCS)
	#
	#
	#[2A$(REC)
	if $(TEST_VERSION);then $(MSG_NUMBERED);exit 1;fi #$(BKCLS)
	$(INDENT)$? $(COLORPIPE);touch $@

html:  $(SRCS) makefile
	$(CIERRA_ED)||(for f in $^;do $(TOHTML) $$f;done;sleep 1;$(NAVEGADOR) $(HTMLS)&)

cpp:  $(SRCS)
	(for f in $^;do $(ECHO)=== $$f ===$(FIN);$(CPP) $$f|$(INDENT) $(NOERR);done)|more

clear:
	$(CLS)
	#$(DONE1)BORRANDO ARCHIVOS TEMPORALES    	$(DONE2)
	$(RM)$(TMPS)$(NOERR)
clear_all:
	#$(DONE1)BORRANDO ARCHIVOS GENERADOS     	$(DONE2)
	$(RM)$(EXE) $(HTMLS) $(TMPS)$(NOERR)

purge_all:
	if test ! -d $(BAKDIR); then mkdir $(BAKDIR); fi
	$(MV)*~ $(BAKDIR)
	$(MV)$(BAKDIR) $(BAKDIR)`date +"%Y%V%u%H%M%S"`

ALL:
	for f in *.c; do e=`echo $$f|sed -e "s/.c$$//"`; echo $$e|make setexe; make $$e; sleep 1;done
CLEAR_ALL:
	make purge_all clear_all; for f in *.c; do e=`echo $$f|sed -e "s/.c$$//"`; rm $$e;done

deprecated:
#regla sólo necesarias para Ubuntu 12.04, eliminables en 14.04
$(EXE).o:  $(EXE).c
	#
	#
	#[2A$(REC)
	if $(TEST_VERSION);then $(MSG_NUMBERED);exit 1;fi #$(BKCLS)
	$(INDENT)$< $(COLORPIPE)
	if test ! -d $(BAKDIR); then mkdir $(BAKDIR); fi
	#
	#[2A$(REC)
	for f in $<;do if test `$(OLDFILES)|head -1`; then $(MV)`$(OLDFILES)` $(BAKDIR);fi done; #$(BKCLS)
	#$(DONE1)$< MAQUETADO OK           	$(DONE2)
	#
	#$(UP)$(REC)
	$(CC)$< $(COLORPIPE)	#$(BKCLS)
	$(CC)$< $(NOERR)
	#$(DONE1)$@ COMPILADO OK           	$(DONE2)
