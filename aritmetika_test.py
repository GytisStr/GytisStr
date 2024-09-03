# aritmetika_test.py
# v: 2021-04-19T1428 AU
import unittest
import aritmetika

class TestAritmetika(unittest.TestCase):
	def test_sudetis(self):
		self.assertEqual(aritmetika.sudetis(10, 5), 15)
		self.assertEqual(aritmetika.sudetis(-1, 1), 0)
		self.assertEqual(aritmetika.sudetis(-1, -1), -2)

	def test_atimtis(self):
		self.assertEqual(aritmetika.atimtis(10, 5), 5)
		self.assertEqual(aritmetika.atimtis(-1, 1), -2)
		self.assertEqual(aritmetika.atimtis(-1, -1), 0)

	def test_daugyba(self):
		self.assertEqual(aritmetika.daugyba(10, 5), 50)
		self.assertEqual(aritmetika.daugyba(-1, 1), -1)
		self.assertEqual(aritmetika.daugyba(-1, -1), 1)

	def test_dalyba(self):
		self.assertEqual(aritmetika.dalyba(10, 5), 2)
#		self.assertEqual(aritmetika.dalyba(-1, 1), -1)
#		self.assertEqual(aritmetika.dalyba(-1, -1), 1)
#		self.assertEqual(aritmetika.dalyba(5, 2), 2.5) # v1.1 AU
#		self.assertRaises(ValueError, aritmetika.dalyba, 10, 0) # v1.2 AU - OK
#		with self.assertRaises(ValueError):
#			aritmetika.dalyba(10, 0) # v1.3 AU - OK
		self.assertEqual(aritmetika.dalyba(10, 0), 10) # bad case
