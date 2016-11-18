#!/usr/bin/python2.7

import csv
import Review
from Review import Review

try:
    r = csv.DictReader(open('excel.csv')).next()
except IOError:
    exit(1)

review = Review(r)
print(review.text)
print('\n\n')
print(review.tokenizedText)
print('\n\n')
print(review.taggedText)

