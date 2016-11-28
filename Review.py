#!/usr/bin/python2.7

import collections

import nltk
from nltk.tokenize import sent_tokenize, word_tokenize

import re

class Review:
    content = None
    cleanText = None
    tokenizedText = None
    taggedText = None

    def __init__(self, txt):
#       dictionary containing meta-info about the review
        self.content = txt

#       remove all special characters that hold nold no meaning
        self.cleanText = re.sub('[/*&\^%\$\#@\<\>]+', '', self.content['body'].lower())

#       remove eccessive number of periods
        self.cleanText = re.sub('[\.]{2,}', '.', self.cleanText)

#       add a space after a period if it appears to be the end of a sentance
        self.cleanText = re.sub('\.(?=[a-zA-Z])', '. ', self.cleanText)

#       tokenize and tag the now-clean text
        self.tokenizedText = [word_tokenize(w) for w in sent_tokenize(self.cleanText)]
        self.taggedText = [nltk.pos_tag(s) for s in self.tokenizedText]

#   get all words of a particular part of speach, specified by poses
    def getPos(self, poses='ALL'):
        ret = []

        if isinstance(poses, list):
            for s in self.taggedText:
                for w, pos in s:
                    for p in poses:
                        if p == pos:
                            ret.append((w, pos))
            return ret

        for s in self.taggedText:
            for w, p in s:
                if poses == 'ALL'or poses == p:
                    ret.append((w, p))
        
        return ret

    def getWordCountDict(self, poses='ALL'):
        ret = {}

        if isinstance(poses, list):
            for sent in self.taggedText:
                for word, p in sent:
                    for pos in poses:
                        if pos == p:
                            key = word + '-' + p
                            if key in ret:
                                ret[key] = ret[key] + 1
                            else:
                                ret[key] = 1
        
        for sent in self.taggedText:
            for word, p in sent:
                if poses == 'ALL' or poses == p:
                    key = word + '-' + p
                    if key in ret:
                        ret[key] = ret[key] + 1
                    else:
                        ret[key] = 1
        return ret
