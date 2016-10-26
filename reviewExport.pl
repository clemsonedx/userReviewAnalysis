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
	group.add_argument('-s', dest='src', required=True)
	return parser.parse_args()

def fixString(c):
	nc = c
	nc = re.sub(r"[\n\r]+", ' ', nc)
	nc = re.sub(r"[ ]{2,}", ' ', nc)

	match = re.search(r"u'.*'", nc)
	if match:
		print "NORMALIZING " + match.group()
		unicodedata.normalize('NFKD', nc).encode('ascii','ignore')
	return nc

def main():
	course =  handleArgs().src
	rp = html.fromstring(requests.get(course + "?page=1#reviews").content)
	pcount = int(rp.xpath('//input[@name="num_pages"]/@value')[0])
	#print pcount

	studentNames = []
	ratings = []
	dates = []
	votes = []
	bodies = []
	for i in range(1, pcount + 1):
		rp = html.fromstring(requests.get(course + "?page=" + str(i) + "#reviews").content)

#		parse student names
		studentNamesTemp = rp.xpath('//p[@class="userinfo__username"]/text()')
		studentNamesTemp = [fixString(sn) for sn in studentNamesTemp]
		for i in range(0, len(studentNamesTemp)):
			sn = re.sub(r'[ \r\t\n]+', '', sn)
			if not studentNamesTemp[i]:
				studentNamesTemp[i] = "Student"
			sn = fixString(sn)
		studentNames.extend(studentNamesTemp)
		#print studentNames
		#print len(studentNames)

#		parse student rating
		ratings.extend(rp.xpath('//div[@class="review-body-info"]/span[@itemprop="reviewRating"]/meta[@itemprop="ratingValue"]/@content'))
		#print ratings
		#print len(ratings)

#		parse publish date
		dates.extend(rp.xpath('//time[@itemprop="datePublished"]/@datetime'))
		#print dates
		#print len(dates)

#		parse vote count
		votes.extend(rp.xpath('//span[@class="mini-poll-control__option-rating js-helpful__rating"]/text()'))
		#print votes
		#print len(votes)

#		parse review body
		bodiesTemp = rp.xpath('//div[@itemprop="reviewBody"]/text()')
		bodiesTemp = [fixString(c) for c in bodiesTemp]
		bodies.extend(bodiesTemp)
		#print bodies
		#print len(bodies)

	print studentNames
#	write contents to csv
	with open('reviews.csv', 'wb') as csvfile:
		writer = csv.writer(csvfile, dialect='excel')
		writer.writerow(['Student Names', 'rating', 'date', 'votes', 'body'])
		for i in range(0, len(bodies)):
			writer.writerow([studentNames[i],ratings[i],dates[i],votes[i],bodies[i]])

if __name__ == "__main__":
	sys.exit(main())
