import copy

def dec2bin(number, n):
    new_number=0
    while number>0:
        new_number*=10
        new_number+=number%2
        number=int(number/2)
    new_number=str(new_number)
    while len(new_number)!=n:
        new_number='0'+new_number
    return new_number


def Knapsack_brute_force(c,n,e):
    fmax=0
    rozw=[]
    max_w=0
    for i in range(1, 2**n):
        current=dec2bin(i,n)

        W=0
        f=0
        X=[]

        for j in range(n):
            if current[j]=='1':

                W+=e[n-j-1][0]
                X.append(n-j)

        if W<c:
            for z in range(n):
                if current[z] == '1':
                    f+=e[n-z-1][1]
            if f>fmax:
                fmax=f
                rozw=X
                max_w=W

    print("elementy wybrane do plecaka: ")
    print(rozw)
    print("sumaryczny rozmiar:", max_w)
    print("wartosc funkcji celu: ", fmax)

def rozw_AD(macierz_kosztow,c,n,e):
    rozw=[]
    print("elementy wybrane do plecaka: ")
    while macierz_kosztow[n][c]!=0:
        #print(n, c)
        if macierz_kosztow[n][c]>macierz_kosztow[n-1][c]:
            print(n)
            rozw.append(n)
            c = c - e[n - 1][0]
            n=n-1
        else:
            n=n-1
    return rozw

def AD(c,n,e):
    macierz_kosztow=[]
    line=[0]*(c+1)
    for _ in range(n+1):
        macierz_kosztow.append(copy.copy(line))

    for i in range(1,n+1):
        for j in range(1,c+1):

            if e[i-1][0]<=j :
                macierz_kosztow[i][j]= max(macierz_kosztow[i-1][j],macierz_kosztow[i-1][j-e[i-1][0]]+e[i-1][1])

            else:
                macierz_kosztow[i][j]=macierz_kosztow[i-1][j]
    #print(macierz_kosztow)
    w=0
    l=rozw_AD(macierz_kosztow,c,n,e)
    for i in range(len(l)):
        w+=e[l[i]-1][0]

    print("sumaryczny rozmiar:",w)
    print("wartosc funkcji celu: ",macierz_kosztow[n][c])


def AZ(c,n,e):
    s=[]
    elem=[]
    rozw=0
    for i in range(0, n):
        s.append([i+1,e[i][0], e[i][1],e[i][1]/e[i][0]])
    s=sorted(s,key=lambda item: item[3])
    s.reverse()
    i=0
    w=0
    print("elementy wybrane do plecaka: ")
    while w<=c and i<n :
        if w+s[i][1] < c:
            w+=s[i][1]
            rozw+=s[i][2]
            print(s[i][0])
        i+=1
    print("sumaryczny rozmiar:",w)
    print("wartosc funkcji celu: ",rozw)





#c=8
#n=4
#e=[[2,4],[1,3],[4,6],[4,8]]
e=[]
c=0
n=0
'''
dane = list(map(int, input().split()))
n = dane[0]
c = dane[1]
for _ in range(n):
    el=list(map(int, input().split()))
    if len(el)!=2:
        print("podano niepoprawny element:",el)
        continue
    else:
        e.append(el)

'''


p = []
with open('test.txt') as file:
    while True:
        line = file.readline()
        if not line:
            break
        p.append(list(map(int, line.split())))
        if len(line.split())!= 2:
            print("podano niepoprawny element:",line)
            continue
    n = p[0][0]
    c = p[0][1]
    e = p[1:]


if len(e)<n:
    print("podales za malo elementow, dopisz je:")
    while len(e)<n:
        print("podaj element:")
        e.append(list(map(int, input().split())))
if len(e)==n:
    ka=1
    #AZ(c,n,e)
    #Knapsack_brute_force(c,n,e)
    #AD(c,n,e)


ka=1
So=[0]*10
So[0]=1
for i in range(8):
    ka+=1
    So[ka]=1
print(So)
