#!/usr/bin/env bash
cd /home/hgkumbhare/working/mert-work
/home/hgkumbhare/mosesdecoder/bin/extractor --sctype BLEU --scconfig case:true  --scfile run2.scores.dat --ffile run2.features.dat -r /home/hgkumbhare/corpus/nl_file_tuning.true.en -n run2.best100.out.gz