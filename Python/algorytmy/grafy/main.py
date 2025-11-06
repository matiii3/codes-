import copy
import sys
sys.setrecursionlimit(10**6)
'''
DFS(G, u)
u.visited = true
for each v ∈ G.Adj[u]
if v.visited == false
DFS(G, v)
init() {
for each u ∈ G
u.visited = false
for each u ∈ G
DFS(G, u)
}'''
g=[]
'''
print("podaj liczbe wierzcholkow:")
w=int(input())
print("podaj liczbe krawedzi:")
e=int(input())
g=[[w,e]]
for i in range(e):
    print("podaj krawedz")
    g.append(list(map(int,input().split())))
print(g)
#g=[[1,2],[2,4],[5,4],[4,3],[2,5],[3,1],[5,1],[3,2]]
'''
with open('test3.txt') as file:
    while True:
        line=file.readline()
        if not line:
            break
        g.append(list(map(int,line.split())))



def dfs(visited, graph, node,end):
    for i in range(len(graph[node])):
        neighbour = i
        if graph[node][neighbour] == 1 and node!=neighbour:
            #print(neighbour)
            if neighbour in visited and neighbour not in end:

                #print("graf jest cykliczny")
                return True
            else:
                visited.add(neighbour)
                if dfs(visited, graph, neighbour,end):
                    return True

            end.add(neighbour)
    return False
    '''
    deleted=[]
    Kahn_mx(deleted,graph,node,V)
    #print(deleted)
    if len(deleted)==len(graph):
        return True
    else:
        return False'''


def dfs_ln(visited, graph, node,end):
    next=graph[node]
    for value in next:
        if value in visited and value not in end:
            #print("graf jest cykliczny")
            return True
        else:
            visited.add(node)
            if dfs_ln(visited, graph, value,end):
                return True
        end.append(value)
    return False

    '''
    deleted=[]
    Kahn_ln(deleted,graph,node)
    if len(deleted)==v:
        return True
    else:
        return False
'''




def smallest(graf, size):
    for i in range(size):
        for j in range(size):
            if graf[i][j] == 1:
                return i
#g=[[3,1],[1,2],[1,5],[1,6],[2,4],[2,6],[2,5],[6,4]]
def matrix_nieskierowany(size):
    line=[0]*(size+1)
    graf=[]
    for i in range(size+1):
       graf.append(line.copy())
    nsk=copy.copy(graf)
    #print(nsk)


    print("ile polaczen: ")
    connections=int(input())

    for i in range(connections):

        #print("Podaj połaczoną parę wierzchołków : ")
        x=g[i][0]  #int(input())
        y=g[i][1] #int(input())
        #print(x,y)
        nsk[y][x]=1
        nsk[x][y]=1
        #print(nsk)

    first=smallest(graf,size)
    dfs(visited,graf,first)

def in_deg_0_matrix(mx,V):
    for i in range(1,len(mx)):
        if i in V and -1 not in mx[i]:
            return i
def if_in_deg_0_matrix(mx,V):
    for i in range(1,len(mx)):
        #print(i)
        if i in V and -1 not in mx[i]:
            #print(i)
            return True
    return False


def matrix_skierowany():
    v=g[0][0]
    E=g[0][1]
    line = [0] * (v + 1)
    graf = []
    for i in range(v + 1):
        graf.append(line.copy())
    sk = copy.copy(graf)
    check = copy.copy(sk)
    #print("ile polaczen: ")
    #connections=int(input())
    V=[]
    for i in range(1,v+1):
        V.append(i)

    for i in range(1,E+1):
        #print("Podaj połaczoną parę wierzchołków (od-do):")
        x=g[i][0]
        y=g[i][1]
        sk[x][y]=1
        sk[y][x]=-1
        check[x][y] = 1
        check[y][x] = -1
    #print(sk)
    visited = set()
    start=1
    if if_in_deg_0_matrix(sk,V):
        start=in_deg_0_matrix(sk,V)
    c=[]
    end=set()
    #dfs(visited,sk,start,v,V,c,end)

    if not dfs(visited,sk,start,end):

        Tarjan_ms(sk,v,start)
        print("Kahn_ms")
        K_list=[]
        Kahn_mx(K_list,sk,start,V)
        print(K_list)

        #Tarjan_ms(sk,v,start)

    else:
        print("graf jest cykliczny, niemozliwe sortowanie")



'''
#g=[[1,2],[2,4],[5,4],[4,3],[2,5],[3,1],[5,1],[3,2]]
with open('the_graph.txt') as file:
    while True:
        line=file.readline()
        if not line:
            break
        g.append(list(map(int,line.split())))
'''
def in_deg_0_ln(ln):
    values=ln.values()
    for key in ln:
        this_key=0
        for value in values:
            if key in value:
                this_key+=1
                continue
        if this_key==0:
            return key


def if_in_deg_0_ln(ln):
    values=ln.values()
    for key in ln:
        this_key = 0
        for value in values:
            if key in value:
                this_key += 1
                continue
        if this_key == 0:
            return True
    return False
#print(g)
def the_list():
    graph={}
    V=g[0][0]
    E=g[0][1]
    for i in range(1,V+1):
        graph[i]=set()

    for i in range(1,E+1):
        graph[g[i][0]].add(g[i][1])
    #print(graph)
    visited=set()
    c=[]
    start=1
    if if_in_deg_0_ln(graph):
        start=in_deg_0_ln(graph)
    end=[]
    #dfs_ln(visited,graph,start,V,c,end)
    if not dfs_ln(visited,graph.copy(),start,end):

        Tarjan_ln(graph, start)
        K_list=[]
        print("Kahn_ln:")
        Kahn_ln(K_list,graph,in_deg_0_ln(graph))
        print(K_list)


        #Tarjan_ln(graph,start)
    else:
        print("graf jest cykliczny, niemozliwe sortowanie")


def TMS(grey, graph, node, T_stock):
    if node not in grey:
        grey.add(node)
        for i in range(len(graph[node])):
            neighbour = i
            if graph[node][neighbour] == 1:
                TMS(grey, graph, neighbour, T_stock)
        #print(node)
        T_stock.append(node)

def Tarjan_ms(graph,v,start):

    print("Tarjan_ms:")
    grey = set()
    T_stock = []
    T_list = []
    start=int(input("podaj wierzcholek poczatkowy:"))
    TMS(grey, graph, start, T_stock)
    for i in range(1,v+1):
        if i not in grey:
            TMS(grey,graph,i,T_stock)
    for i in range(len(T_stock)-1,-1,-1):
        T_list.append(T_stock[i])
    print(T_list)

def TLN(grey, graph, node, T_stock):
    if node not in grey:
        grey.add(node)
        graph[node]=sorted(graph[node])
        #print(graph[node])
        for elements in graph[node]:
                TLN(grey, graph, elements, T_stock)
        #print(node)
        T_stock.append(node)
def Tarjan_ln(graph,start):
    print("Tarjan_ln:")
    if graph == {}:
        print("graph does not exist")
    else:
        grey = set()
        T_stock = []
        T_list=[]
        start=int(input("podaj wierzcholek poczatkowy:"))
        TLN(grey, graph, start, T_stock)
        for v in graph:
            if v not in grey:
                TLN(grey, graph, v, T_stock)
        for i in range(len(T_stock) - 1, -1, -1):
            T_list.append(T_stock[i])
        print(T_list)
def Kahn_ln (K_list,graph, node):
    K_list.append(node)
    del graph[node]
    #print(graph)
    if if_in_deg_0_ln(graph):
        Kahn_ln(K_list,graph,in_deg_0_ln(graph))

def Kahn_mx (K_list,graph, node,V):
    K_list.append(node)
    #print(V)
    #print(V,node)
    V.remove(node)
    for i in range(len(graph)):
        graph[i][node] = 0
        graph[node][i] = 0
    if if_in_deg_0_matrix(graph,V):

        Kahn_mx(K_list,graph,in_deg_0_matrix(graph,V),V)


the_list()
matrix_skierowany()
