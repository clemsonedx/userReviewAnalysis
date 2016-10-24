#!/usr/bin/python2.7

import re
import sys
import argparse
from lxml import html
import requests

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
	rp = html.fromstring(requests.get(course + "?page=1#reviews").content)
	pcount = int(rp.xpath('//input[@name="num_pages"]/@value')[0])
	print pcount

	for i in range(1, pcount + 1):
		studentNames = rp.xpath('//p[@class="userinfo__username"]/text()')
		studentNames = [re.sub(r'[ \r\t\n]+', '', sn) for sn in studentNames]
		for i in range(0, len(studentNames)):
			if not studentNames[i]:
				studentNames[i] = "Student"
		print studentNames
		break


if __name__ == "__main__":
	sys.exit(main())
