#!/bin/bash

PASSWORD_LIST="password_list.txt"
MAX_WORDS_PER_PERMUTATION=4

if [[ $# -ne 2 ]]; then
	echo "Usage: $0 PASSWORD_LIST MAX_WORDS_PER_PERMUTATION"
	echo "Using default output name: $PASSWORD_LIST"
	echo "      default permutation word max: $MAX_WORDS_PER_PERMUTATION"
else
	PASSWORD_LIST=$1
	MAX_WORDS_PER_PERMUTATION=$2
	echo "Output will be directed to $PASSWORD_LIST"
	echo "Maximum number of words per permutation: $MAX_WORDS_PER_PERMUTATION" 
fi 

echo -e "\nEnter words to be permuted for the password list file (press ENTER on empty line when done):\n" 
original_list=()
while read line; do
	if [[ -z $line ]]; then
		break
	fi

	original_list+=("$line")
done

q_original_list=$(printf %q, "${original_list[@]}")

permutation_list=()

for max_words in $(seq 1 $MAX_WORDS_PER_PERMUTATION);
do
	
	brace_expansion=""
	for word in $(seq 1 $max_words);
	do
		brace_expansion+="{${q_original_list%,}}"
	done

	permutation_list+=($(eval "echo $brace_expansion"))
done

echo -e "Adding to $PASSWORD_LIST:\n${permutation_list[@]}"
printf "%s\n" "${permutation_list[@]}" > $PASSWORD_LIST
