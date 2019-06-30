#!/bin/bash
#------------ SET ABSOLUTE PATH TO TOOLS
PATHSUBLISTER="/path/to/Sublist3r/sublist3r.py"
PATHSUBZY="/path/to/subzy"
PATHAQUATONE="/path/to/aquatone"
PATHASSETFINDER="/Users/MYUSER/go/bin/./assetfinder" #Usually is like this
PATHSUBDOMAINTAKEOVER="/path/to/subdomain-takeover"
OUTPUT="/path/to/output"
#------------
bold=$(tput bold)
normal=$(tput sgr0)

clear
echo "${bold}Vamos a buscar algunos 'Suddomains TakeOvers' (Sublist3r + Assetfinder + subzy)${normal}"
echo 
   "        _______
                         | ___  o|
                         |[_-_]_ |
      ______________     |[_____]|
     |.------------.|    |[_____]|
     ||            ||    |[====o]|
     ||            ||    |[_.--_]|
     ||            ||    |[_____]|
     ||            ||    |      :|
     ||____________||    |      :|
 .==.|""  ......    |.==.|      :|
 |::| '-.________.-' |::||      :|
 |''|  (__________)-.|''||______:|
   _.............._    ______"

echo "${bold}Ingresa el Dominio: ${normal}"
read DOMAIN
echo
echo $DOMAIN
echo
echo "${bold}Correcto? S/N: ${normal}"
read domainOk
if [ "$domainOk" = "S" ] || [ "$domainOk" = "s" ]; then
	echo "${bold}Ingresa el nombre del archivo: ${normal}"
	read SUDOMAINPATH
	clear
	echo
	clear
	echo "${bold}Comenzamos a buscar Subdominios...${normal}"
	python2 $PATHSUBLISTER -d $DOMAIN -o $OUTPUT/$SUDOMAINPATH.txt
else
	echo "${bold}Ingresa nuevamente: "
	read DOMAIN
	echo "${bold}Ingresa el nombre del archivo:${normal} "
	read SUDOMAINPATH
	clear
	echo
	clear
	echo "${bold}Comenzamos a buscar Subdominios...${normal}"
	python2 $PATHSUBLISTER -d $DOMAIN -o $OUTPUT/$SUDOMAINPATH.txt
fi
echo
echo "${bold}Ahora vamos a tirar otra tool para ver si salen mas subominios...${normal}"
echo "${bold}Recorda compararlos a mano! (por ahora)${normal}"
echo
echo
$PATHASSETFINDER -subs-only $DOMAIN
sleep 3
#TODO: Comparar strings de salidas para ver si hay un sudominio nuevo y consolidar entonces en un nuevo output.txt
echo
echo "${bold}Veamos si tenemos suerte y encontramos un Subdomain Takeover!!...${normal}"
echo


if $PATHSUBZY/./subzy --target $OUTPUT/$SUDOMAINPATH | grep -w "^.*  VULNERABLE" ; then
   echo "${bold}HAY VULN, VIVA LA PATRIA!!!${normal}"
 else
 	echo "${bold}Noooo!, No hay vuln :(${normal}"
fi

echo
echo "Vamos a realizar un poco de fuerza bruta para descubrir nuevos subdominios y ver si alguno es vulnerable..."
echo "Esto va a demorar un poco, tomate un cafe mientras..."
echo
#TODO: Que el grep muestre en detected-takeover.txt todos los dominios que detecto vulnerables y no muestre otras cosas que no interesen

python2 $PATHSUBDOMAINTAKEOVER/takeover.py -d $DOMAIN -w $PATHSUBDOMAINTAKEOVER/Subdomain.txt -t 20 >> /tmp/takeover2.txt;cat /tmp/takeover2.txt | grep -w "DETECTED" > $OUTPUT/detected-takeover.txt
echo "Listo! fijate si salio algo..."
open $OUTPUT/detected-takeover.txt

sleep 5
echo "${bold}Hora de ver que hay en cada subdominio encontrado, usemos el Aquatone...${normal}"
cd $PATHAQUATONE
sudo cat $OUTPUT/$SUDOMAINPATH.txt | ./aquatone -out $OUTPUT/$DOMAIN
open $OUTPUT/$DOMAIN/aquatone_report.html
echo
echo "Ya termine!, queres hacer fuerza bruta para ver si salen mas subdominios? S/N: "
read bruteForce
while [ "$bruteForce" != "s" ] && [ "$bruteForce" != "S" ] && [ "$bruteForce" != "n" ] && [ "$bruteForce" != "N" ]; do
	echo "Respuesta incorrecta alcornoque!, vamos de nuevo, ingresa solo S o N: "
	read bruteForce
done
if [ "$bruteForce" = "S" ] || [ "$bruteForce" = "s" ]; then
	python2 $PATHSUBLISTER -d $DOMAIN -b -o $OUTPUT/brutedforced.txt
	echo
	echo "Terminamos! fijate si salio algo y tuvimos suerte!"
else
	if [ "$bruteForce" = "n" ] || [ "$bruteForce" = "N" ]; then
		sleep 2
		echo "Fue un placer, hasta la proxima!"
		exit 1
	fi
fi