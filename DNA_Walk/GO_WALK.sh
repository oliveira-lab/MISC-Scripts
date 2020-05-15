#!/bin/bash

#########################################################################
# File Name: GO_WALK.sh
# Author(s): Pedro H. Oliveira
# Institution: Mount Sinai School of Medicine, NY, USA
# Mail: pcphco@gmail.com
# Created Time: Fri 15 May 2020 10:37:32 AM (EDT)
#########################################################################


help='''
  USAGE:  GO_WALK.sh
    -f   <SEQ: FASTA file>
'''

while getopts ":f:hr:" opt; do
    ## Count the opts
    let optnum++
    case $opt in
        f)
            SEQ=$OPTARG
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


awk '/^>/ {
			printf("%s%s\t",(N>0?"\n":""),$0);N++;next;
			}; 
			{printf("%s",$0);} 
			END{
		printf("\n");
}' ${SEQ} |\
awk '{print $NF}' |\
sed -e 's/\(.\)/\1 /g' |\
tr -s ' '  '\n' |\
sed -e 's/A/1/; s/G/1/; s/T/-1/; s/C/-1/g' |\
awk '{total += $0; $0 = total}1' |\
awk '{print NR,$1}' | awk 'BEGIN{print "Position", "Walk"}1' > DNA_Walk.txt
tput setaf 2; echo "Done!"; tput sgr0
