from nltk.tokenize import sent_tokenize
from os.path import expanduser


homedir = expanduser("~")

# convert paragraph to sentences in nl file
fp = open(homedir+"/corpus/nl_raw_data.en")
text = fp.read()
sent_tokenize_list = sent_tokenize(text)
len(sent_tokenize_list)

target = open(homedir+"/corpus/nl_file.en", 'w')
target.truncate()

for line in sent_tokenize_list:
	target.write(line)
	target.write("\n")
target.close();

# convert paragraph to sentences in se file
fp = open(homedir+"/corpus/nl_raw_data.fr")
text = fp.read()
sent_tokenize_list = sent_tokenize(text)
len(sent_tokenize_list)

target = open(homedir+"/corpus/nl_file.fr", 'w')
target.truncate()

for line in sent_tokenize_list:
	target.write(line)
	target.write("\n")
target.close()
