#!/usr/bin/python

import sys
import argparse
from collections import defaultdict
from operator import itemgetter
import csv

from Tkinter import *
import ttk

def handleArgs():
        descStr = """
        reads in user reviews and parses them
        """
        parser = argparse.ArgumentParser(description=descStr)
        group = parser.add_argument_group()
        group.add_argument('-f', dest='fname', required=True, help="Reviews file (.csv)")
        return parser.parse_args()

def parseReviews(fname):
	try:
		csvfile = open(fname)
		reader = csv.DictReader(csvfile)
	except IOError:
		exit(1)
		
	ratings = defaultdict(list)
	for r in reader:
		r['rating'] = int(r['rating'])
		r['votes'] = int(r['votes'])
		rating = r['rating']
		if rating < 4:
			ratings['low'].append(r)
		elif rating < 8:
			ratings['medium'].append(r)
		else:
			ratings['high'].append(r)
	for key, val in ratings.iteritems():
		ratings[key] = sorted(val, key=itemgetter('votes', 'rating'), reverse=True)
        print(ratings['low'])


def main():
    args = handleArgs()
    parseReviews(args.fname)

if __name__ == "__main__":
	sys.exit(main())
