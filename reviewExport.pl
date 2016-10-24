#!/usr/bin/python2.7

import re
import sys
import difflib
import urllib2
import argparse

class Usage(Exception):
	def __init__(self, msg):
		self.msg=msg

def handleArgs():
	descStr = """
	extracts edx course reviews into a .csv file
	"""
	parser = argparse.ArgumentParser(description=descStr)
	group = parser.add_argument_group()
	group.add_argument('-s', dest='src', required=True)
	return parser.parse_args()

def main():
	course =  handleArgs().src
	rp = urllib2.urlopen(course + "?page=1#reviews").read()
	pcount = int(re.search('(?<=name\=\"num_pages\" value\=\").*(?=\" /\>)', rp, re.MULTILINE).group())
	print pcount
	for i in range(1, pcount + 1):
		print i
		rp = urllib2.urlopen(course + "?page=$i#reviews").read()

if __name__ == "__main__":
	sys.exit(main())
