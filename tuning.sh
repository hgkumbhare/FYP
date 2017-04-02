#!/bin/sh
#tuning script

#The end result of tuning is an ini file with trained weights, which should be in ~/working/mert-work/moses.ini
# To check errors see mert.out

#nl_file_tuning has tuning data

~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < ~/corpus/nl_file_tuning.en > ~/corpus/nl_file_tuning.tok.en

~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < ~/corpus/se_file_tuning.en > ~/corpus/se_file_tuning.tok.en

# Note we made "truecase-model.en" as "~/corpus/truecase-model_nl.en"
~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model_nl.en < ~/corpus/nl_file_tuning.tok.en > ~/corpus/nl_file_tuning.true.en


~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model_se.en < ~/corpus/se_file_tuning.tok.en > ~/corpus/se_file_tuning.true.en

~/mosesdecoder/scripts/training/mert-moses.pl ~/corpus/se_file_tuning.true.en ~/corpus/nl_file_tuning.true.en ~/mosesdecoder/bin/moses ~/lm/train/model/moses.ini --mertdir ~/mosesdecoder/bin/ &> ~/working/mert.out &

#how to add this line for speed
#echo `--decoder-flags="threads 4"`

echo "TUNING SCRIPT RAN SUCCESSFULLY"

#Make input file lowercase
~/mosesdecoder/scripts/tokenizer/lowercase.perl -l en < ~/working/input_file.txt > ~/working/input_file_lowercase.txt

# Running or Testing moses (not needed now because we using binarised form)
#~/mosesdecoder/bin/moses -f ~/working/mert-work/moses.ini < ~/working/input_file_lowercase.txt > ~/working/output_file_lowercase.txt






