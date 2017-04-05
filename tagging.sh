#!/bin/sh

# need to add backslash for $.*[\]^
# here I am using , instead of / because / is present in input string

while read p; do
	echo $p
	IFS='\|' read -r -a array <<< "$p"
	echo ${array[0]}
	echo ${array[1]}	
	sed -i "s,${array[0]},${array[1]},g" ~/working/input_file.txt
done < ~/corpus/tags.txt

