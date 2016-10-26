#!/usr/bin/python2.7

import re
import sys
import argparse
from lxml import html
import requests
import csv
import unicodedata

class Usage(Exception):
	def __init__(self, msg):
		self.msg=msg

def handleArgs():
	descStr = """
	extracts edx course reviews into a .csv file
	"""
	parser = argparse.ArgumentParser(description=descStr)
	group = parser.add_argument_group()
	group.add_argument('-s', dest='src', required=True, help="like to course review page (any)")
	group.add_argument('-n', dest='fname', required=False, help="output file name")
	return parser.parse_args()

def fixString(c):
	nc = c
	nc = re.sub(r"[\n\r]+", ' ', nc)
	nc = re.sub(r"[ ]{2,}", ' ', nc)
	nc = re.sub(r'^ +', '', nc)
	nc = re.sub(r' +$', '', nc)

	if type(nc) is unicode:
		nc = unicodedata.normalize('NFKD', nc).encode('ascii','ignore')
	return nc

def main():
	args = handleArgs()
	course =  args.src
	rp = html.fromstring(requests.get(course).content)
	pcount = int(rp.xpath('//input[@name="num_pages"]/@value')[0])
	
	course = re.sub(r'#reviews', '', course)
	course = re.sub(r'\?page\=[0-9]+', '', course)

	studentNames = []
	ratings = []
	dates = []
	votes = []
	bodies = []
	for i in range(1, pcount + 1):
		rp = html.fromstring(requests.get(course + "?page=" + str(i) + "#reviews").content)

#		parse student names
		studentNameNodes= rp.xpath('//p[@class="userinfo__username"]/.')
		studentNamesTemp = []

		for sn in studentNameNodes:
			snc = sn.find('a')
			if snc is not None:
				snc = snc.get('href')
				if snc is not None:
					studentNamesTemp.append('https://www.coursetalk.com' + snc)
			else:
				studentNamesTemp.append(sn.text)
	
		studentNamesTemp = [fixString(sn) for sn in studentNamesTemp]

		for i in range(0, len(studentNamesTemp)):
			sn = fixString(sn)
			if not studentNamesTemp[i]:
				studentNamesTemp[i] = "Student"
		studentNames.extend(studentNamesTemp)

#		parse student rating
		ratings.extend(rp.xpath('//div[@class="review-body-info"]/span[@itemprop="reviewRating"]/meta[@itemprop="ratingValue"]/@content'))

#		parse publish date
		dates.extend(rp.xpath('//time[@itemprop="datePublished"]/@datetime'))

#		parse vote count
		votes.extend(rp.xpath('//span[@class="mini-poll-control__option-rating js-helpful__rating"]/text()'))



#		parse review body
		bodiesTemp = rp.xpath('//div[@itemprop="reviewBody"]/text()')
		bodiesTemp = [fixString(c) for c in bodiesTemp]
		bodies.extend(bodiesTemp)

#	write contents to csv
	
	if args.fname is None:
		args.fname = 'reviews.csv'
	with open(args.fname, 'wb') as csvfile:
		writer = csv.writer(csvfile, dialect='excel')
		writer.writerow(['Student Names', 'rating', 'date', 'votes', 'body'])
		for i in range(0, len(studentNames)):
			writer.writerow([studentNames[i],ratings[i],dates[i],votes[i],bodies[i]])

if __name__ == "__main__":
	sys.exit(main())
