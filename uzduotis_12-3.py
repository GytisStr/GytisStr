import sqlite3

conn = sqlite3.connect(":memory:")
c = conn.cursor()

class Paskaita:
    def __init__(self, pavadinimas, destytojas, trukme):
        self.pavadinimas = pavadinimas
        self.destytojas = destytojas
        self.trukme = trukme

def sukurti_lentele():
    with conn:
        c.execute("""CREATE TABLE paskaitos (
                pavadinimas text,
                destytojas text,
                trukme integer
                )""")

def irasyti_paskaita(paskaita):
    with conn:
        c.execute(f"INSERT INTO paskaitos VALUES('{paskaita.pavadinimas}', '{paskaita.destytojas}', {paskaita.trukme})")

def rasti_paskaita(pavadinimas):
    c.execute(f"SELECT * FROM paskaitos WHERE pavadinimas='{pavadinimas}'")
    print(c.fetchall())

def pakeisti_trukme(paskaita, trukme):
    with conn:
        c.execute(f"UPDATE paskaitos SET trukme = {trukme} WHERE pavadinimas = '{paskaita.pavadinimas}' AND destytojas = '{paskaita.destytojas}'")

def istrinti_paskaita(paskaita):
    with conn:
        c.execute(f"DELETE from paskaitos WHERE pavadinimas = '{paskaita.pavadinimas}' AND destytojas = '{paskaita.destytojas}'")

def rodyti_visas():
    c.execute("SELECT * FROM paskaitos LIMIT 10")
    print(c.fetchall())

vadyba = Paskaita('Vadyba', 'Domantas', 40)
python = Paskaita('Python', 'Donatas', 80)
java = Paskaita('Java', 'Tomas', 80)

sukurti_lentele()
irasyti_paskaita(vadyba)
irasyti_paskaita(python)
irasyti_paskaita(java)

rasti_paskaita("Vadyba")

pakeisti_trukme(vadyba, 50)

istrinti_paskaita(java)

rodyti_visas()


