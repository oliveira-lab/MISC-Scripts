# MISC-Scripts
Useful bash/python/R scripts for bioinformatics.

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

Shannon entropy H(X) is defined as the entropy of a discrete random variable X with possible values {x1, ..., xn} and probability mass function P(X):

<a href="https://www.codecogs.com/eqnedit.php?latex={\displaystyle&space;\mathrm&space;{H}&space;(X)=-\sum&space;_{i=1}^{n}{\mathrm&space;{P}&space;(x_{i})\log&space;_{b}\mathrm&space;{P}&space;(x_{i})},}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?{\displaystyle&space;\mathrm&space;{H}&space;(X)=-\sum&space;_{i=1}^{n}{\mathrm&space;{P}&space;(x_{i})\log&space;_{b}\mathrm&space;{P}&space;(x_{i})},}" title="{\displaystyle \mathrm {H} (X)=-\sum _{i=1}^{n}{\mathrm {P} (x_{i})\log _{b}\mathrm {P} (x_{i})},}" /></a>

where b is the base of the logarithm used.

The GO_Shannon.sh script computes the Shannon entropy at each individual position of a multi-sequence alignment (MSA) in FASTA format. 
The script takes into consideration the desired gap ratio, i.e, the percentage of gaps at a given position (varying between [0-1[).

To run it:

	./GO.Shannon.sh -f <MSA: FASTA file> -g <gap_ratio [0-1[>

This produces an output Shannon_Entropy.txt file.

## DNA_Walk

A ‘DNA Walk’ is defined as a 1D random walk model that steps up (+1) if a pyrimidine occurs at a position i along the DNA chain or steps down (-1) in case a purine occurs. 
The GO_WALK.sh script performs a DNA walk given as input a DNA sequence in FASTA format:

	./GO.WALK.sh -f <FASTA file>
