#!/bin/sh
#for all training parameters visit: http://www.statmt.org/moses/?n=FactoredTraining.TrainingParameters

# To check errors see training.out
# variables
MAX_PHRASE_LENGTH=100
NGRAM=4

# tokenisation: This means that spaces have to be inserted between (e.g.) words and punctuation

# to remove empty lines
# sed '/^$/d' se_file.en > temp.txt


# Just copying corpus in home folder to home/working

# file variable
nl_file="nl_file"
se_file="nl_file"

rm -r ~/working/corpus | echo "Cannot delete corpus folder but it is okay"
cp -r ~/corpus ~/working/corpus


~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < ~/corpus/nl_file.en > ~/corpus/nl_file.tok.en

~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < ~/corpus/nl_file.fr > ~/corpus/nl_file.tok.fr


#truecasing: The initial words in each sentence are converted to their most probable casing. This helps reduce data sparsity.

~/mosesdecoder/scripts/recaser/train-truecaser.perl --model ~/corpus/truecase-model.en --corpus ~/corpus/nl_file.tok.en

~/mosesdecoder/scripts/recaser/train-truecaser.perl --model ~/corpus/truecase-model.fr --corpus ~/corpus/nl_file.tok.fr

# convert all to lowercase

~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model.en < ~/corpus/nl_file.tok.en > ~/corpus/nl_file.true.en

~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model.fr < ~/corpus/nl_file.tok.fr > ~/corpus/nl_file.true.fr


# convert all to lowercase
#~/mosesdecoder/scripts/tokenizer/lowercase.perl -l en < ~/corpus/nl_file.en > ~/corpus/nl_file_lowercase.en
#~/mosesdecoder/scripts/tokenizer/lowercase.perl -l en < ~/corpus/nl_file.fr > ~/corpus/nl_file_lowercase.fr

# one command to limit words in a sentence

~/mosesdecoder/scripts/training/clean-corpus-n.perl \
~/corpus/nl_file.true fr en \
~/corpus/nl_file.clean 1 80

#Language Model Training using fr 
rm -r ~/lm | echo "Cannot delete lm folder but it is okay"
mkdir ~/lm
cd ~/lm
~/mosesdecoder/bin/lmplz -o $NGRAM <~/corpus/nl_file.true.fr > ~/corpus/nl_file.arpa.en

~/mosesdecoder/bin/build_binary ~/corpus/nl_file.arpa.en ~/lm/nl_file.blm.en



~/mosesdecoder/scripts/training/train-model.perl -root-dir train -corpus ~/corpus/nl_file.clean --e en --f fr -alignment grow-diag-final-and -reordering msd-bidirectional-fe -lm 0:3:$HOME/lm/nl_file.blm.en:8 -external-bin-dir ~/mosesdecoder/tools >& training.out &



#scripts/training/train-model.perl \
#-external-bin-dir <external_bin_dir>
#-root-dir <workspace_dir> \
#-corpus <train_path_without_ext> \
#-e <tgt_lang> -f <src_lang> \
#-alignment <phrase_extraction_strategy e.g. grow-diag-final-and> \
#-reordering <reordering_strategy e.g. msd-bidirectional-fe>
#-max-phrase-length
#-lm <lm_type, 0 for srilm>:<lm_order>:<lm_file>:0

echo "SCRIPT RAN SUCCESSFULLY"

echo $nl_file
echo $se_file
