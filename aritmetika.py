# aritmetika.py
# v: 2021-04-19T1426 AU

def sudetis(a, b):
	return a + b

def atimtis(a, b):
	return a - b

def daugyba(a, b):
	return a * b # v1.0 final AU revOJ

def dalyba(a, b):
	# pridename tikrinimą: dalyba iš nulio
	if b == 0:
		raise ValueError("Dalyba iš nulio negalima")
	return a / b # v0.1 AU
