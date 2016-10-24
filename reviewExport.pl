#!/usr/bin/python2.7

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
	i = 2;
	while True:
		rpnext = urllib2.urlopen(course + "?page=$i#reviews").read()
		print(rp)
		if True:
			break
		i += 1
		rp = rpnext

if __name__ == "__main__":
	sys.exit(main())
