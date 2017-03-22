#!/bin/sh
#for all training parameters visit: http://www.statmt.org/moses/?n=FactoredTraining.TrainingParameters

~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < ~/corpus/nl_file.en > ~/corpus/nl_file.tok.en

~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < ~/corpus/se_file.en > ~/corpus/se_file.tok.en


~/mosesdecoder/scripts/recaser/train-truecaser.perl --model ~/corpus/truecase-model_nl.en --corpus ~/corpus/nl_file.tok.en

~/mosesdecoder/scripts/recaser/train-truecaser.perl --model ~/corpus/truecase-model_se.en --corpus ~/corpus/se_file.tok.en


~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model_nl.en < ~/corpus/nl_file.tok.en > ~/corpus/nl_file.true.en

~/mosesdecoder/scripts/recaser/truecase.perl --model ~/corpus/truecase-model_se.en < ~/corpus/se_file.tok.en > ~/corpus/se_file.true.en

# one command to limit words in a sentence

~/mosesdecoder/bin/lmplz -o 2 <~/corpus/nl_file.true.en > ~/corpus/nl_file.arpa.en

~/mosesdecoder/bin/build_binary ~/corpus/nl_file.arpa.en ~/lm/nl_file.blm.en

#echo `echo "KYC procedure" | ~/mosesdecoder/bin/query ~/lm/nl_file.blm.en`

nohup nice ~/mosesdecoder/scripts/training/train-model.perl -root-dir train -corpus ~/corpus/nl_file --e en --f en -alignment grow-diag-final-and -reordering msd-bidirectional-fe -lm 0:3:$HOME/lm/nl_file.blm.en:8 -external-bin-dir ~/mosesdecoder/tools >& training.out &


#nohup nice ~/mosesdecoder/scripts/training/train-model.perl -root-dir train -corpus ~/corpus/news-commentary-v8.fr-en.clean --e en -alignment grow-diag-final-and -reordering msd-bidirectional-fe -lm 0:3:$HOME/lm/news-commentary-v8.fr-en.blm.en:8 -external-bin-dir ~/mosesdecoder/tools >& training.out &

~/mosesdecoder/bin/moses -f ~/working/train/model/moses.ini < input_file.txt > output_file.txt

echo "SCRIPT RAN SUCCESSFULLY"
