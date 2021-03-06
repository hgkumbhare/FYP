#!/bin/sh
#tree based training script

# mgiza not found error : https://www.mail-archive.com/moses-support@mit.edu/msg09790.html

# ERROR: Cannot find /home/hgkumbhare/mosesdecoder/tools/merge_alignment.py at /home/hgkumbhare/mosesdecoder/scripts/training/train-model.perl line 400. 
# downloaded folder from https://github.com/moses-smt/mgiza and copied merge_alignment.py file in required directory

# format to be used found on http://lotus.kuee.kyoto-u.ac.jp/WAT/baseline/baselineSystemTree2String.html

#Make input file lowercase
~/mosesdecoder/scripts/tokenizer/lowercase.perl -l en < ~/corpus/nl_file.en > ~/corpus/nl_file_lowercase.en

~/mosesdecoder/scripts/tokenizer/lowercase.perl -l en < ~/corpus/nl_file.fr > ~/corpus/nl_file_lowercase.fr

~/mosesdecoder/scripts/training/train-model.perl \
	-root-dir train \
	--corpus ~/corpus/nl_file_lowercase \
	--external-bin-dir ~/mosesdecoder/tools --f fr \
	--e en \
	--alignment grow-diag-final \
	--hierarchical \
	--glue-grammar --lm 0:3:$HOME/lm/nl_file.blm.en:8 \
	>& logfile 2>&1 

#~/mosesdecoder/scripts/training/train-model.perl -root-dir train -corpus ~/corpus/nl_file.clean --e en --f fr -alignment grow-diag-final-and -reordering msd-bidirectional-fe -lm 0:3:$HOME/lm/nl_file.blm.en:8 -external-bin-dir ~/mosesdecoder/tools >& training.out &


# found on link - http://stp.lingfil.uu.se/~aarons/MT-kurs/lab7.html

#/local/kurs/mt/mosesdecoder/scripts/training/train-model.perl --corpus corpus \
#        --f src --e tgt --root-dir root-dir --lm 0:order:file \
#        --external-bin-dir /local/kurs/mt/bin64 --hierarchical \ 
#        --glue-grammar -mgiza >logfile 2>&1


rm -r ~/working/tuning | echo "cannot delete tuning folder but its okay"
mkdir ~/working/tuning


  ~/mosesdecoder/scripts/training/mert-moses.pl \
  ~/corpus/nl_file_lowercase.en \
  ~/corpus/nl_file_lowercase.fr \
  ~/mosesdecoder/bin/moses_chart \
  ~/working/train/model/moses.ini \
  --mertdir ~/mosesdecoder/bin \
  --working-dir ~/working/tuning/mert \
  --no-filter-phrase-table \
  --inputtype 3 \
  --predictable-seeds \
  >& ~/working/tuning/mert.log 




#Insert weights into the configuration file.
#perl ~/mosesdecoder/scripts/ems/support/substitute-weights.perl \
#  ~/working/train/model/moses.ini \
#  ~/working/tuning/mert/moses.ini \
#  ~/working/train/model/moses-tuned.ini 

# to comment
#if false then fi
# end comment

cp ~/working/tuning/mert/moses.ini ~/working/train/model/moses-tuned.ini

~/mosesdecoder/bin/moses_chart -config ~/working/train/model/moses-tuned.ini -max-chart-span 1000  -inputtype 3 < input_file_lowercase.txt > output_file_tree.txt 2> log_tree.log 



