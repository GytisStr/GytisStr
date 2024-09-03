import unittest
from uzduotis_14_1 import *

class TestUzduotis14_1(unittest.TestCase):
    
    def test_skaiciu_suma(self):
        self.assertEqual(643, skaiciu_suma(2, 6, 4, 78, 1, 454, 30, 68))
        self.assertEqual(-4, skaiciu_suma(-1, -3))
        self.assertEqual(0, skaiciu_suma(-10, 10))


tikrinimas = TestUzduotis14_1()
tikrinimas.test_skaiciu_suma()