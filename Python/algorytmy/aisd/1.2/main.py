


tab=[]
#for size in sizes:

size = 50
print(size,"- elementow:")
for _ in range(size):
    #wpisujemy losowe dane
    tab.append(random.randint(0,size*10))

'''
dla danych wejsciowych rosnacych:
tab.sort()

dla danych wejsciowych malejacych:
tab.sort(reverse=True)

dla danych wejsciowych A-ksztaltnych:

middle = int(size/2)
A1 = tab[:middle]
A2 = tab[middle:]
A1.sort()
A2.sort(reverse=True)
tab=A1+A2

dla danych wejsciowych V-ksztaltnych:

middle = int(size/2)
A1 = tab[:middle]
A2 = tab[middle:]
A1.sort(reverse=True)
A2.sort()
tab=A1+A2
'''
