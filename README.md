# MISC-Scripts
Useful bash/python/perl scripts for bioinformatics.

## Encryption_Decryption

The GO_Crypt.sh script performs a simple encryption of a text file into DNA code (represented as nucleotides A, T, C, G).
The algorithm works by converting each text character (letters, numbers, symbols) into a binary form, and transforming the latter into DNA using a randomly generated key dictionary of the form:

	keys=(
	'k1=(00 11 01 10)' 
	'k2=(00 11 10 01)' 
	'k3=(00 01 11 10)'
	.
	.
	)

In the above dictionary, each column represents a DNA nucleotide. For example, for k1, A='00', T='11', C='01', G='10'.
The correspondence between binary code and nucleotides is performed in a random fashion and can assume 24 possible combinations. 
Information on the key dictionary used is also stored in the encrypted file, allowing decryption to text characters when needed.

The procedure for encryption is:

	./GO.Crypt.sh -c encrypt -f Text.txt

where Text.txt is any text file to be encrypted (provided as example). This will produce an intermediary binary file and a final DNA Encrypted file. The latter contains the key dictionary index as header, which allows for decryption:

	./GO.Crypt.sh -c decrypt -f DNA_Encrypted.txt
    
This produces the original decrypted text file.


## Shannon_Entropy

The GO_Shannon.sh script computes the Shannon entropy at each individual position of a multi-sequence alignment (MSA) in FASTA format. 
The script takes into consideration the desired gap ratio, i.e, the percentage of gaps at a given position (varies between [0-1[).

To run it:

	./GO.Shannon.sh -f <MSA: FASTA file> -g <gap_ratio [0-1[>

This produces an output Shannon_Entropy.txt file.
