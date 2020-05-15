#!/bin/bash

#########################################################################
# File Name: GO_Shannon.sh
# Author(s): Pedro H. Oliveira
# Institution: Mount Sinai School of Medicine, NY, USA
# Mail: pcphco@gmail.com
# Created Time: Fri 15 May 2020 10:37:32 AM (EDT)
#########################################################################


help='''
  USAGE:  GO_Shannon.sh
    -f   <MSA: FASTA file>
    -g   <gap_ratio: number between [0-1[. 0 means no gaps are accepted at a given position>
'''


while getopts ":f:g:hr:" opt; do
    ## Count the opts
    let optnum++
    case $opt in
        f)
            MSA=$OPTARG
            ;;
        g)
            gap_ratio=$OPTARG
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


# check missing arguments or if outside range
if [ -z "$MSA" ] ; then
	echo "Argument missing"
	exit 1
	else if [ -z "$gap_ratio" ] ; then
		echo "Argument missing"
		exit 1
		else if (( $(echo "${gap_ratio} >= 1" | bc) )) || (( $(echo "${gap_ratio} < 0" | bc) )) ; then
			echo "Wrong Gap Ratio. Use a value between [0-1[."
			exit 1
		fi		
	fi
fi

# linearizing FASTA
awk '/^>/ {
			printf("%s%s\t",(N>0?"\n":""),$0);N++;next;
			}; 
			{printf("%s",$0);} 
			END{
		printf("\n");
}' ${MSA} |\

awk '{print $NF}' |\

# computing base frequencies
awk '{
    len=length($1);
    for(i=1;i<=len;i++) {
        B=substr($1,i,1);
        S[i][B]++;
    }
} 
    END {
        for(BI=0;BI<5;BI++) {
            B=(BI==0?"A":(BI==1?"C":(BI==2?"G":(BI==3?"T":"-"))));             
            printf("%s",B); 
            for(i in S) {
                total=0;
                for(B2 in S[i]){
                    total+=S[i][B2];
                }
            printf("\t%4.3f",(S[i][B]/total));
            } 
        printf("\n");
        }
}' |\

awk '{$1=""; print $0}' |\

# file transposing
awk '{ 
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {    
    for(k=1; k<=p; k++) {
        tr=a[1,k]
        for(i=2; i<=NR; i++){
            tr=tr" "a[i,k];
        }
        print tr
    }
}' |\

awk -v gap=${gap_ratio} '{if($5>gap) print "nan"; else print $0}'|\

# computing Shannon entropy per site
awk '{
    for(i = 1; i <= NF; i++)
            s = s OFS $i*log($i)/log(2)
            print s
            s = ""
}'|\
sed 's/-nan//g' |\
awk '{for(i=1;i<=NF;i++) t+=$i; 
	if($0~"[0-9]") print (-1)*t;
	else print "LGR"
	t=0
}' |\
awk '{print NR,$1}' | awk 'BEGIN{print "Position", "Shannon_Entropy"}1' > Shannon_Entropy.txt
tput setaf 2; echo "Done!"; tput sgr0

