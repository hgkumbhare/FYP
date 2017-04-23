#!/bin/sh
#tuning script

#The end result of tuning is an ini file with trained weights, which should be in ~/working/mert-work/moses.ini
# To check errors see mert.out

#nl_file_tuning has tuning data


#ideally tuning data should be different from training data
# converting to lowercase
~/mosesdecoder/scripts/tokenizer/lowercase.perl -l en < ~/corpus/nl_file.en > ~/corpus/nl_file_tuning.en
~/mosesdecoder/scripts/tokenizer/lowercase.perl -l en < ~/corpus/nl_file.fr > ~/corpus/nl_file_tuning.fr

~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < ~/corpus/nl_file_tuning.en > ~/corpus/nl_file_tuning.tok.en
~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < ~/corpus/nl_file_tuning.fr > ~/corpus/nl_file_tuning.tok.fr

# Note we made "truecase-model.en" 
~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model.en < ~/corpus/nl_file_tuning.tok.en > ~/corpus/nl_file_tuning.true.en

~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model.fr < ~/corpus/nl_file_tuning.tok.fr > ~/corpus/nl_file_tuning.true.fr

~/mosesdecoder/scripts/training/mert-moses.pl ~/corpus/nl_file_tuning.true.fr ~/corpus/nl_file_tuning.true.en ~/mosesdecoder/bin/moses ~/lm/train/model/moses.ini --mertdir ~/mosesdecoder/bin/ &> ~/working/mert.out &

#how to add this line for speed
#echo `--decoder-flags="threads 4"`




echo "TUNING SCRIPT RAN SUCCESSFULLY"






