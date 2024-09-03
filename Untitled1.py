#!/usr/bin/env python
# coding: utf-8

# In[14]:



metai = 2021

metai = int(input("Iveskite metus: "))
if (metai % 4) == 0:
   if (metai % 100) == 0:
       if (metai % 400) == 0:
           print("{0} yra keliamieji".format(metai))
       else:
           print("{0} yra keliamieji".format(metai))
   else:
       print("{0} yra keliamieji".format(metai))
else:
   print("{0} nera keliamieji".format(metai))


# In[ ]:





# In[ ]:


metai = 2021

metai = int(input("Iveskite metus: "))
if (metai % 4) == 0:
   if (metai % 100) == 0:
       if (metai % 400) == 0:
           print("{0} yra keliamieji".format(metai))
       else:
           print("{0} yra keliamieji".format(metai))
   else:
       print("{0} yra keliamieji".format(metai))
else:
    print("{0} nera keliamieji".format(metai))


# In[ ]:


mano_tekstas = """The Zen of Python
Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
"""
import mano_tekstas
print mano_tekstas


# In[1]:


a = 5
a +=9
print (a)


# In[2]:


b = 13
b /=7
print (b)


# In[3]:


c = 2**2
print (c)


# In[4]:


c = 32 % 6
print (c)


# In[6]:


zodis = "Lietuvos Statistikos Departamentas"
print (zodis[0:8])


# In[12]:


zodis = "Lietuvos Statistikos Departamentas"
print (zodis.replace('Statistikos','Bulviu' ))


# In[14]:


d = "Zodis"
e = 8
e = str(e)
print(d+e)


# In[16]:


d="250"
e=4
print(d*e)


# In[ ]:


a = input ("Ivesk skaiciu asile:")


# In[ ]:


a = 0


# In[ ]:


import mano_tekstas


# In[ ]:


print (mano_tekstas)


# In[ ]:





# In[ ]:


vardas = input("Koks tavo vardas?")
print ("Hello" + str(vardas))

metai = int(input("Kiek tau metu?"))
print ("oho" + metai "metai")
print (str(metai * 365) + "dienu")


# In[ ]:




