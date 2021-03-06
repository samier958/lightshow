Az előző két részben megbeszéltük, hogy milyen operációs rendszert érdemes használni és mire van szükség a munkához.

Most az a feldatunk, hogy kialakítsunk egy kényelmes környezetet, hogy gyorsan és könnyen tudjunk dolgozni. 
Ahogy azt már sokszor sok helyen elmondtam, a számíttatógép nagyon irritál, ezért természetesen itt is a számítógépes megoldást preferálom, vagyis nem egérklikkelő rabszolgamunka lesz a fejlesztés.

A fordítást mindenképpen make segítségével végezzük, mivel ez biztosítja a hordozható kódot ill. nem szeretném minden munka elején a beállításokat hosszasan egérrel kattogtatni.
Egy új projektet úgy szeretnék indítani, hogy az alapokat egy template-ből automatikusan generálja a környezet, beleértve a main file-t ill. a make generálását is.

Kétféle projektet lehet indítani, ext ill. app.

Az ext egy komponens, ami további használatra szolgál és az extension könyvtárba kerül. Az app a hagyományos értelemben vett applikáció.

Első dolgunk a template elkészítése. 
A szükséges file-ok:
.gitignore	Git repository-ból kihagyandó file-név minták.
Makefile.app    Applikáció fordításához szükséges Makefile
Makefile.ext    Extension fordításához szükséges Makefile
app.c		Applikáció main c file
chconf.h	ChibiOS config file
halconf.h	ChibiOS HAL config file
ext.c		Extension main file
ext.cbp		Extension Code::Blocks project file
mcuconf.h	controller config file
misc.h		különleges applikáció funkciók header file-ja
misc.c		különleges applikáció funkciók forrás file-ja
project.cbp	Applikáció Code::Blocks project file
usbcfg.h	USB console header file
usbcfg.c	USB console forrás file

test/Makefile   Extension test fordításához szükséges Makefile
test/main.c	Extension test main c file
test/test.cbp   Extension test Code::Blocks project file

doc/.gitignore 	Git repository-ból kihagyandó file-név minták.
doc/Makefile 	Dokumentáció generálásához Makefile
doc/doxyfile	Dokumentáció config file

Ezeken kívül kell egy script amely generálja a template-ből a projektet. A generálás során többször lehet szükség az egyes template file-okban az új projekt nevének behelyettesítésére. 
Ezt legkönnyebben úgy lehet megoldani, hogy a template file-okban elhelyezünk egy mintát, amit ki kell cserélni a projektnévre. Ez extension esetében #!#EXT_NAME#!# ill. ha nagybetűvel kell behelyettesíteni, akkor
#!#UEXT_NAME#!#. Hasonlóan az applikáció esetében ezek #!#PROJECT_NAME#!# ill. #!#UPROJECT_NAME#!#. 
A script-ről készítettem két soft-linket, createapp ill. createlib néven. A script a basename segítségével el tudja dönteni, hogy melyik néven hívták meg és a megfelelő ág fog futni.

Applikáció 

indítása ./createapp appnev script-tel. Eredmény egy appnev nevű könyvtár, amelyben megjelennek az alábbi file-ok:
.gitignore	Git repository-ból kihagyandó file-név minták.
Makefile  	Make fordításvezérlő
chconf.h  	ChibiOS config header file
appnev.cbp	Code::Blocks project file
halconf.h 	ChibiOS HAL header file
main.c    	Applikáció main c file
mcuconf.h 	ChibiOS microcontroller config header file
misc.c    	
misc.h    
usbcfg.c  
usbcfg.h

a doc könyvtárban:

Makefile	Make fordításvezérlő
doxyfile	Doxygen configurációs file

az appnev könyvtárban a make hatására lefut a fordító. A Code::Blocks segítségével az appnev.cbp-t megnyitva betöltődik a projekt. Az beállításokat megtekintve láthatjuk, hogy a Makefile-t használja fordításra,
de megmarad az IDE előnye is. A projekthez a ChibiOS include file-jai hozzá vannak adva, így a code completion funkció is használható. 
Ha a projekt lefordult, akkor a parancssorból kiadott make flash paranccsal a bináris file-t letölti a discovery board flash memóriájába, majd megvárja, amíg reset-et nyomunk a board-on, majd 2 mp után elindítja a gtkterm-et
és megjelenik a console. 

Extension

indítása ./createext extnev script-tel. Eredmény egy extnev nevű könyvtár az Extension alkönyvtárban. Ezen belül létrejön egy test alkönyvtár amely az extension tesztjét valósítja meg. 
File-ok:

Extension/extnev/
  .gitignore	Git repository-ból kihagyandó file-név minták.
  extnev.cbp 	Code::Blocks project file.
  extnev.mk	Make include file az extension fordításához
  doc/
    Makefile	Make fordításvezérlő
    doxyfile	Doxygen configurációs file
    .gitignore	Git repository-ból kihagyandó file-név minták.
  include/
    extnev.h	Header file az extension definicíókhoz
  src/
    extnev.c	C forrás az extension kódjához
  test/
    Makefile	Make fordításvezérlő
    extnev.cbp	Teszt Code::Blocks project file
    chconf.h  	ChibiOS config header file
    halconf.h 	ChibiOS HAL header file
    mcuconf.h 	ChibiOS microcontroller config header file
    
Extension elérhetővé tétele

A kész letesztelt exension-t a settings.mk file-ban lehet publikálni:

ifeq ($(USE_<EXTENSION NEV>),y)
include $(EXTENSION)/<extension nev>/<extension_nev>.mk
endif

Ha az extension további extension-okat használ, akkor azokat is be kell állítani. Pl. az új extension szeretné használni a config
extension-t:

ifeq ($(USE_<EXTENSION NEV>),y)
USE_CONFIG=y
include $(EXTENSION)/<extension nev>/<extension_nev>.mk
endif

Itt azonban vigyázni kell, úgy kell elhelyezni az ifeq kódját, a file-ban, hogy a használni kívánt extension-ok vizsgálata elé kerüljön. 
Pl. itt a kódot a ifeq ($(USE_CONFIG),y)) vizsgálat elé kell helyezni.

Kényelmi szolgáltatások

Taszk generálás

ChibiOS alatt szinte minden külön taszkban fut. Egy új taszk létrehozásának automatizálása igencsak megkönnyíti a munkát. 
Használata az adott project könyvtárban a make createtask  <taskname> paranccsal lehetséges. Ennek hatására létrehozza
a tasknev.h és tasknev.c file-okat a megfelelő tartalommal. 

Help

Érdemes a Makefile-hoz help-et is készíteni, mivel egyre szerteágazóbb lesz, nem várható el a felhasználóktól, hogy 
keresgéljenek a különböző egymásra hivatkozó Makefile hierarchiában. A make help parancsra az elérhető célokat listázza ki.


   