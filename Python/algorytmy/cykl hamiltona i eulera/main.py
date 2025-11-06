import copy
import time
import random

g=[]
'''
with open('test1.txt') as file:
    while True:
        line=file.readline()
        if not line:
            break
        g.append(list(map(int,line.split())))
'''
def dane_graf_nieskierowany(v,proc):
    e=int(v*(v-1)/2)
    e=int(proc*e)
    g.append([v,e])
    while len(g)<(e+1):
        n, m = random.sample(range(1,v), 2)
        if n!=m and [n,m] not in g and [m,n] not in g:
            g.append([n,m])
def dane_graf_skierowany(v,proc):
    e=int(v*(v-1))
    e=int(proc*e)
    g.append([v,e])
    while len(g) < (e + 1):
        n, m = random.sample(range(1,v), 2)
        if n!=m and [n,m] not in g and [m,n] not in g:
            g.append([n,m])
#dane_graf_skierowany(20,0.2)
dane_graf_nieskierowany(15,0.8)

print(g)

Path1=[0]*(g[0][0]+1)
O1=[]
visited1 = 0
k1=0
def macierz_sasiedztwa():
    v = g[0][0]
    E = g[0][1]
    line = [0] * (v + 1)
    graf = []
    for i in range(v + 1):
        graf.append(line.copy())
    nsk=copy.copy(graf)
    #print(nsk)

    for i in range(1,E+1):

        x=g[i][0]
        y=g[i][1]
        #print(x,y)
        nsk[y][x]=1
        nsk[x][y]=1
    #print(nsk)
    '''
    start=time.time()
    if Hcycle_nsk(nsk,v):
        end=time.time()
        print(end-start)
        #print(Path1[1:])
    else:
        print("Graf wejściowy nie zawiera cyklu Hamiltona")'''
    Ecycle_nsk(nsk)

def lista_nastepnikow(lista):
    V=g[0][0]
    E=g[0][1]
    for i in range(1,V+1):
        lista[i]=set()
    for i in range(1,E+1):
        lista[g[i][0]].add(g[i][1])

def lista_poprzednikow(lista):
    V = g[0][0]
    E = g[0][1]
    for i in range(1, V + 1):
        lista[i] = set()
    for i in range(1,E+1):
        lista[g[i][1]].add(g[i][0])

def lista_braku_incydencji(l_pop,l_nas,lbi):
    V = g[0][0]
    for i in range(1,V+1):
        lbi[i]=set()
    for i in range(1, V + 1):
        for k in range(1,V+1):
            if k not in l_pop[i] and k not in l_nas[i]:
                lbi[i].add(k)

    #print(lbi)
def macierz_grafu(l_pop,l_nas,lbi):
    v = g[0][0]
    E = g[0][1]
    line = [0] * (v + 4)
    graf = []
    for i in range(v + 1):
        graf.append(line.copy())
    macierz=copy.copy(graf)
    next=l_nas[1]
    #krok1
    for i in range(1,v+1):
        if l_nas[i] ==set():
            macierz[i][v + 1] =0
        else:
            macierz[i][v+1]=list(l_nas[i])[0]
    for i in range(1,v+1):
        for j in range(1,v+1):
            if j in l_nas[i]:
                macierz[i][j]=list(l_nas[i])[len(list(l_nas[i]))-1]
    #krok2
    for i in range(1,v+1):
        if l_pop[i] ==set():
            macierz[i][v + 2]=0
        else:
            macierz[i][v+2]=list(l_pop[i])[0]
    for i in range(1,v+1):
        for j in range(1,v+1):
            if j in l_pop[i]:
                macierz[i][j]=list(l_pop[i])[len(list(l_pop[i]))-1]+v
    #krok3
    for i in range(1,v+1):
        if lbi[i] == set():
            macierz[i][v + 3] = 0
        else:
            macierz[i][v+3]=list(lbi[i])[0]
    for i in range(1,v+1):
        for j in range(1,v+1):
            if j in lbi[i]:
                macierz[i][j]=-1*list(lbi[i])[len(list(lbi[i]))-1]
    print()
    start=time.time()
    if Hcycle_sk(macierz,v):
        end=time.time()
        print(end-start)
        #print(Path[1:])
    else:
        print("Graf wejściowy nie zawiera cyklu Hamiltona")
    Ecycle_sk(macierz)

Path=[0]*(g[0][0]+1)
O=[]
visited = 0
k=0



def Hamiltonian_sk(start, v, visited, n, macierz, k, Path):
    O[v] = True
    visited+=1
    for i in range(1,n+1):
        if macierz[v][i]>0 and macierz[v][i]<=n:
            #print(v,i)
            if i == start and visited == n:
                return True
            if not O[i]:
                #print(i)
                pom=k
                if (Hamiltonian_sk(start, i, visited, n, macierz, pom + 1, Path)):

                    #print(v,i)
                    Path[k] = i
                    #print(Path)

                    return True
    O[v] = False
    visited-=1
    return False
def Hcycle_sk (macierz,n):
    for i in range(0,n+1):
        O.append(False)
    Path[1] = 1
    start=Path[1]
    visited = 0
    k=2
    print("zaczynam hamiltona")
    if Hamiltonian_sk(start, start, visited, n, macierz, k, Path):

        #print(Path)
        return True
    return False

def Hamiltonian_nsk(start, v, visited1, n, macierz, k, Path):
    O1[v] = True
    visited1+=1
    for i in range(1,n+1):
        if macierz[v][i] ==1:
            if i == start and visited1 == n:
                return True
            #print(i)
            if not O1[i]:
                #print(i)
                pom=k
                if (Hamiltonian_nsk(start, i, visited1, n, macierz, pom + 1, Path1)):

                    #print(v,i)
                    Path1[k] = i
                    #print(Path1)
                    return True
    O1[v] = False
    visited1-=1
    return False
def first(macierz):
    for i in range(len(macierz[0])):
        for j in range(len(macierz[0])):
            if macierz[i][j]==1:
                return
def Hcycle_nsk (macierz,n):
    for i in range(0,n+1):
        O1.append(False)
    Path1[1] = 1
    start=Path1[1]
    visited1 = 0
    k1=2
    print("zaczynam hamiltona")
    if Hamiltonian_nsk(start, start, visited1, n, macierz, k1, Path1):
        #print(Path)
        return True
    return False
def in_equal_out():
    for i in range(1,g[0][0]+1):
        if len(l_nas[i]) != len(l_pop[i]):
            return False
        return True

def even_degree(matrix, n):
    for i in range(n):
        if sum(matrix[i]) % 2 != 0:
            return False
    return True
'''
cycle=[]
def Euler_nsk(macierz,deleted,v1,k,E_path1,start):
    for u in range(n):
        if macierz[v][u] != 0:
            macierz[v][u] = 0
            macierz[u][v] = 0
            dfs(u)

    cycle.append(v)

  
    #if deleted == g[0][1] and v1 ==start:
    #    return True
    if deleted<=g[0][1]:
        for i in range(len(macierz)):
            if macierz[v1][i]==1:
                macierz[v1][i] = 0
                macierz[i][v1] = 0
                deleted+=1
                print(v1,i,"  ",deleted)
                #print(macierz)
                #print(deleted)
                print(v1)
                Euler_nsk(macierz,deleted,i,k+1,E_path1,start)
                    #macierz[v1][i] = 0
                    #macierz[i][v1] = 0
    E_path1[k]=v1
    print(E_path1)
        #deleted-=1
        #return False'''


def Ecycle_nsk(macierz):
    #E_path1=[0]*g[0][1]
    #k=1
    cycle = []

    def Euler_nsk(v):
        for u in range(1,g[0][0]+1):
            if macierz[v][u] != 0:
                macierz[v][u] = 0
                macierz[u][v] = 0
                #print(v,u)
                Euler_nsk(u)
        cycle.append(v)
    #Euler_nsk(macierz,deleted,start,k,E_path1,start):
    if even_degree(macierz,g[0][0]):
        start=time.time()
        Euler_nsk(1)
        end=time.time()
        print(end-start)
        #cycle.reverse()
        #print(cycle)
    else:
        print("Graf wejściowy nie zawiera cyklu Eulera.")

def Ecycle_sk(macierz):
    #E_path1=[0]*g[0][1]
    #k=1
    cycle = []

    def Euler_sk(v):
        for u in range(1,g[0][0]+1):
            if macierz[v][u]>0 and macierz[v][u]<=v:
                macierz[v][u] *=-1
                #print(v,u)
                Euler_sk(u)
        cycle.append(v)
    #Euler_nsk(macierz,deleted,start,k,E_path1,start):
    if in_equal_out():
        start=time.time()
        Euler_sk(1)
        end=time.time()
        print(end-start)
        #cycle.reverse()
        #print(cycle)
    else:
        print("Graf wejściowy nie zawiera cyklu Eulera.")






l_pop={}
l_nas={}
lbi={}

lista_nastepnikow(l_nas)
lista_poprzednikow(l_pop)
lista_braku_incydencji(l_pop, l_nas,lbi)
macierz_sasiedztwa()
#macierz_grafu(l_pop, l_nas,lbi)


#print(g)
