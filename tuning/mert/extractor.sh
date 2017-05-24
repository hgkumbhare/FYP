#!/usr/bin/env bash
cd /home/hgkumbhare/working/tuning/mert
/home/hgkumbhare/mosesdecoder/bin/extractor --sctype BLEU --scconfig case:true  --scfile run4.scores.dat --ffile run4.features.dat -r /home/hgkumbhare/corpus/nl_file_lowercase.fr -n run4.best100.out.gz
