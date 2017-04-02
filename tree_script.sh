#!/bin/sh
#tree based training script

# mgiza not found error : https://www.mail-archive.com/moses-support@mit.edu/msg09790.html

# ERROR: Cannot find /home/hgkumbhare/mosesdecoder/tools/merge_alignment.py at /home/hgkumbhare/mosesdecoder/scripts/training/train-model.perl line 400. 
# downloaded folder from https://github.com/moses-smt/mgiza and copied merge_alignment.py file in required directory

# format to be used found on http://lotus.kuee.kyoto-u.ac.jp/WAT/baseline/baselineSystemTree2String.html

~/mosesdecoder/scripts/training/train-model.perl \
	-root-dir train \
	--corpus ~/corpus/nl_file \
	--external-bin-dir ~/mosesdecoder/tools --f en \
	--e en \
	--alignment grow-diag-final \
	--hierarchical \
	--glue-grammar --lm 0:3:$HOME/lm/nl_file.blm.en:8 \
	>& logfile 2>&1 

# found on link - http://stp.lingfil.uu.se/~aarons/MT-kurs/lab7.html

#/local/kurs/mt/mosesdecoder/scripts/training/train-model.perl --corpus corpus \
#        --f src --e tgt --root-dir root-dir --lm 0:order:file \
#        --external-bin-dir /local/kurs/mt/bin64 --hierarchical \ 
#        --glue-grammar -mgiza >logfile 2>&1


rm -r tuning
mkdir tuning


  ~/mosesdecoder/scripts/training/mert-moses.pl \
  --f en \
  --e en \
  ~/mosesdecoder/bin/moses_chart \
  ~/working/train/model/moses.ini \
  --mertdir ~/mosesdecoder/bin \
  --working-dir ~/working/tuning/mert \
  --no-filter-phrase-table \
  --inputtype 3 \
  --predictable-seeds \
  >& ~/working/tuning/mert.log 


#Insert weights into the configuration file.
perl ~/mosesdecoder/scripts/ems/support/substitute-weights.perl \
  ~/working/train/model/moses.ini \
  ~/working/tuning/mert/moses.ini \
  ~/working/train/model/moses-tuned.ini 



~/mosesdecoder/bin/moses_chart -config ~/working/train/model/moses-tuned.ini  -inputtype 3 < input_file.txt > output_file_tree.txt 2> log_tree.log 