# keliamieji.py
# v: 2021-04-19T1357 AU
def ar_keliamieji(metai):
	if ( (metai % 400 == 0)
		or
		( ( metai % 4 == 0 ) )
	):
		return("Keliamieji")
	else:
		return("Nekeliamieji")
