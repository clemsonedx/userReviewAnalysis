#!/usr/bin/python2.7

import nltk
from nltk.tokenize import sent_tokenize, word_tokenize

class Review:
    def __init__(self, txt):
        self.text = txt['body']
        self.tokenizedText = [word_tokenize(w) for w in sent_tokenize(self.text)]
        self.taggedText = [nltk.pos_tag(s) for s in self.tokenizedText]
