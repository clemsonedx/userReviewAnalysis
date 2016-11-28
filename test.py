#!/usr/bin/python2.7

import unittest

import csv
import Review
from Review import Review

class TestReview(unittest.TestCase):
    reader = None
    review = None

    @classmethod
    def setUpClass(cls):
        cls.reader = csv.DictReader(open('excel.csv'))
        cls.review = Review(cls.reader.next())

    def test_getPos(self):
        posTupples = self.review.getPos()
        self.assertTrue(len(posTupples) > 0)

    def test_getWordCountDict(self):
        countDict = {}
        for key, count in self.review.getWordCountDict(['NN', 'NNS']).items():
            if key in countDict:
                countDict[key] = countDict[key] + 1
            else:
                countDict[key] = 1

if __name__ == '__main__':
    unittest.main()
