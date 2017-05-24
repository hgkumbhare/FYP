#!/bin/sh

# Filter the model for this test set, meaning that we only retain the entries needed translate the test set. This will make the translation a lot faster.

rm -r filtered | echo "cannot delete filtered folder but it is okay"

~/mosesdecoder/scripts/training/filter-model-given-input.pl filtered mert-work/moses.ini ~/corpus/nl_file.true.en -Binarizer ~/mosesdecoder/bin/processPhraseTableMin

# to test on output
~/mosesdecoder/bin/moses -f ~/working/filtered/moses.ini < ~/working/input_file_lowercase.txt > ~/working/output_file_lowercase_filtered.txt 2> ~/working/filtered.out

~/mosesdecoder/scripts/generic/multi-bleu.perl -lc ~/corpus/nl_file.true.en < ~/working/output_file_lowercase_filtered.txt


echo "FILTERED MODEL WORKED"
