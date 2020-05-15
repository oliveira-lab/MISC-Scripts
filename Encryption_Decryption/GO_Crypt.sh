#!/bin/bash

#########################################################################
# File Name: GO_Crypt.sh
# Author(s): Pedro H. Oliveira
# Institution: Mount Sinai School of Medicine, NY, USA
# Mail: pcphco@gmail.com
# Created Time: Sun 3 May 2020 23:17:35 PM (EDT)
#########################################################################



help='''
  USAGE:  GO_Crypt.sh
    -c   <crypt_option: encrypt / decrypt>
    -f   <crypt_file: text (use with encrypt) or DNA (use with decrypt)>
'''

while getopts ":c:f:hr:" opt; do
    ## Count the opts
    let optnum++
    case $opt in
        c)
            crypt_option=$OPTARG
            ;;
        f)
            crypt_file=$OPTARG
            ;;
        h)
            printf "$help"
            exit 1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [ -z "$crypt_option" ]
then
	echo "Argument missing"
	exit 1
	else if [ -z "$crypt_file" ]
	then
		echo "Argument missing"
		exit 1
		else if [ "$crypt_option" != "encrypt" ] && [ "$crypt_option" != "decrypt" ]
		then
			echo "Wrong crypt_option. Use encrypt or decrypt."
			exit 1
		fi		
	fi
fi



keys=(
'k1=(00 11 01 10)' 
'k2=(00 11 10 01)' 
'k3=(00 01 11 10)' 
'k4=(00 01 10 11)' 
'k5=(00 10 11 01)' 
'k6=(00 10 01 11)' 
'k7=(11 00 01 10)' 
'k8=(11 00 10 01)' 
'k9=(11 01 00 10)' 
'k10=(11 01 10 00)' 
'k11=(11 10 00 01)' 
'k12=(11 10 01 00)' 
'k13=(01 00 10 11)' 
'k14=(01 00 11 10)' 
'k15=(01 10 00 11)' 
'k16=(01 10 11 00)' 
'k17=(01 11 00 10)' 
'k18=(01 11 10 00)' 
'k19=(10 00 01 11)' 
'k20=(10 00 11 01)' 
'k21=(10 01 00 11)' 
'k22=(10 01 11 00)' 
'k23=(10 11 00 01)' 
'k24=(10 11 01 00)'
)




if [[ "$crypt_option" == "encrypt" ]]; then

    tput setaf 2; echo "Currently $crypt_option"ing" text to DNA. Please wait..."; tput sgr0
	awk '{print $0}' ${crypt_file} | perl -lpe '$_=join " ", unpack"(B8)*"' > binary_file.txt

	rnd=${keys[$RANDOM % ${#keys[@]}]}

echo "
-----------------------------------
The code used for encryption was:"
	echo $rnd | sed 's/=(/ /g' | awk '{print "A=" $2}'
	echo $rnd | awk '{print "T=" $2}'
	echo $rnd | awk '{print "C=" $3}'
	echo $rnd | sed 's/)//g' | awk '{print "G=" $4}'
echo "-----------------------------------"

	A=`echo $rnd | sed 's/=(/ /g' | awk '{print $2}'`
	T=`echo $rnd | awk '{print $2}'`
	C=`echo $rnd | awk '{print $3}'`
	G=`echo $rnd | sed 's/)//g' | awk '{print $4}'`

	code=`echo $rnd | sed 's/=(/ /g' | awk '{print $1}'`
	sed 's/ //g' binary_file.txt | sed 's/.\{2\}/& /g' | sed "s/$A /A /g;s/$T /T /g; s/$C /C /g;s/$G /G /g" |\
	sed 's/ //g' | awk -v val=$code 'BEGIN{print val}; {print}' > DNA_Encrypted.txt
	tput setaf 2; echo "Done!"; tput sgr0


else
    tput setaf 2; echo "Currently $crypt_option"ing" DNA to text. Please wait..."; tput sgr0

	arrayindex=`awk 'NR==1{print substr($1,2)-1}' $crypt_file`

	A=`echo ${keys[$arrayindex]} | awk '{print $1}' | sed 's/=(/ /g' | awk '{print $2}'`
	T=`echo ${keys[$arrayindex]} | awk '{print $2}'`
	C=`echo ${keys[$arrayindex]} | awk '{print $3}'`
	G=`echo ${keys[$arrayindex]} | awk '{print $4}' | sed 's/)//g'`

	awk 'NR>1{print $0}' ${crypt_file} | sed "s/A/$A/g;s/T/$T/g; s/C/$C/g;s/G/$G/g" | sed 's/.\{8\}/& /g' | perl -lape '$_=pack"(B8)*",@F' > Text_Decrypted.txt
	tput setaf 2; echo "Done!"; tput sgr0

fi

