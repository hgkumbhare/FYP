#!/bin/sh

# need to add backslash for $.*[\]^
# here I am using , instead of / because / is present in input string

#Make input file lowercase
~/mosesdecoder/scripts/tokenizer/lowercase.perl -l en < ~/working/input_file.txt > ~/working/input_file_lowercase.txt

cp ~/working/input_file_lowercase.txt ~/working/input_file_tag.txt

while read p; do
	echo $p
	IFS='\|' read -r -a array <<< "$p"
	echo ${array[0]}
	echo ${array[1]}	
	sed -i "s,${array[0]},${array[1]},g" ~/working/input_file_tag.txt
done < ~/corpus/tags.txt

