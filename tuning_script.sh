#!/bin/sh
#tuning script

cd ~/corpus

~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < nl_file_tuning.en > ~/corpus/nl_file_tuning.tok.en

~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < se_file_tuning.en > ~/corpus/se_file_tuning.tok.en

# Note we made "truecase-model.en" as "~/corpus/truecase-model_nl.en"
~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model_nl.en < ~/corpus/nl_file_tuning.tok.en > ~/corpus/nl_file_tuning.true.en


~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model_se.en < ~/corpus/se_file_tuning.tok.en > ~/corpus/se_file_tuning.true.en

cd ~/working
pwd

nohup nice ~/mosesdecoder/scripts/training/mert-moses.pl ~/corpus/se_file_tuning.true.en ~/corpus/nl_file_tuning.true.en ~/mosesdecoder/bin/moses train/model/moses.ini --mertdir ~/mosesdecoder/bin/ &> mert.out &

#how to add this line for speed
#echo `--decoder-flags="threads 4"`

echo "TUNING SCRIPT RAN SUCCESSFULLY"





mkdir ~/working/binarised-model
cd ~/working
~/mosesdecoder/bin/processPhraseTableMin \
-in train/model/phrase-table.gz -nscores 4 \
-out binarised-model/phrase-table
~/mosesdecoder/bin/processLexicalTableMin \
-in train/model/reordering-table.wbe-msd-bidirectional-fe.gz \
-out binarised-model/reordering-table


echo "BINARISED MODEL SUCCESSFULLY"
