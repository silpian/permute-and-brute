#!/bin/bash

USAGE_MESSAGE="Usage: $0 PASSWORD_LIST COMPRESSED_FILE"

if [[ $# -ne 2 ]]; then
	echo $USAGE_MESSAGE
	exit 1
else
	if [[ ! -f $1 ]]; then
		echo $USAGE_MESSAGE
		echo "File with password permutations, '$1', not found"
		exit 1
	fi
	if [[ ! -f $2 ]]; then
		echo $USAGE_MESSAGE
		echo "Compressed file, '$2', not found"
		exit 1
	fi

	echo -e "Brute forcing passwords from '$1' to extract files from '$2'\n"
fi

DESTINATION_DIR="extracted_$2"
if [[ ! -d $DESTINATION_DIR ]]; then
	mkdir $DESTINATION_DIR
fi

SUCCESS_MESSAGE="Everything is Ok"

while IFS= read -r line || [[ -n "$line" ]]; do
	# if not working, check for line endings - '\r' or '\n'
	# printf '%q' "$line"
	cleaned_line=$(echo "${line}" | tr -d '\r')
	printf '%q' "Trying: $cleaned_line"
	echo ""
	log_string=$(7z e $2 -o$DESTINATION_DIR -p$cleaned_line -y 2>&1)
	if [[ $log_string =~ $SUCCESS_MESSAGE ]]; then
		echo "Successful! Password: $cleaned_line"
		exit
	fi
done < "$1"

echo "Unsuccessful. Try another password file."
