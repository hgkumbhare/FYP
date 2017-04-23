#!/usr/bin/env bash
cd /home/hgkumbhare/working/tuning/mert
/home/hgkumbhare/mosesdecoder/bin/extractor --sctype BLEU --scconfig case:true  --scfile run3.scores.dat --ffile run3.features.dat -r /home/hgkumbhare/corpus/nl_file.fr -n run3.best100.out.gz
