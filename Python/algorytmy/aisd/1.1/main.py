import random
import time

file=open("output.txt","w")

def insertion_sort(tab):

    start = time.time()
    for i in range(len(tab)):
        maks = i
        for j in range(i+1,len(tab)):

            if tab[j] > tab[maks]:
                maks = j

        switch = tab[maks]
        tab[maks] = tab[i]
        tab[i] = switch

    end = time.time()
    print("czas:  ", end - start)



def Shell_sort(tab):

    start=time.time()
    k=len(tab)
    k=int(k/2)
    iteration=1
    while k>0:

        for i in range(len(tab)-k):
            maks=i
            j=i+k
            while j<len(tab):
                if tab[j] > tab[maks]:
                    maks=j
                j+=k
            switch=tab[maks]
            tab[maks]=tab[i]
            tab[i]=switch
        k=int(k/2)
        iteration+=1
    end=time.time()
    print("czas: ", end-start)


connections = 0


def merge_sort(myList):
   global connections
   if len(myList) > 1:
       mid = len(myList) // 2
       left = myList[:mid]
       right = myList[mid:]

       merge_sort(left)
       merge_sort(right)

       i = 0
       j = 0
       k = 0

       while i < len(left) and j < len(right):
           if left[i] >= right[j]:
               myList[k] = left[i]
               i += 1


           else:
               myList[k] = right[j]
               j += 1


           k += 1


       while i < len(left):
           myList[k] = left[i]
           i += 1
           k += 1


       while j < len(right):
           myList[k] = right[j]
           j += 1
           k += 1
       connections += 1


def partition(tab, low, high):

  pivot = tab[high]


  i = low - 1

  for j in range(low, high):
    if tab[j] >= pivot:

      i = i + 1

      (tab[i], tab[j]) = (tab[j], tab[i])

  (tab[i + 1], tab[high]) = (tab[high], tab[i + 1])

  return i + 1


def quickSort(tab, low, high):
  if low < high:

    pi = partition(tab, low, high)

    quickSort(tab, low, pi - 1)

    quickSort(tab, pi + 1, high)

def heapify(myList, n, i):
   largest = i
   left = 2 * i + 1
   right = 2 * i + 2

   if left < n and myList[i] > myList[left]:
       largest = left

   if right < n and myList[largest] > myList[right]:
       largest = right

   if largest != i:
       (myList[i], myList[largest]) = (myList[largest], myList[i])

       heapify(myList, n, largest)


def heapSort(myList):

   A = tab.copy()
   start = time.time()
   n = len(myList)

   for i in range(n // 2 - 1, -1, -1):
       heapify(myList, n, i)

   for i in range(n - 1, 0, -1):
       (myList[i], myList[0]) = (myList[0], myList[i])
       heapify(myList, i, 0)
   end = time.time()
   print("czas:  ", end - start)




tab=[]

size= 7500
print(size,"- elementow:")
for _ in range(size):
    #wpisujemy losowe dane
    tab.append(random.randint(0,size*10))


#dla danych wejsciowych rosnacych:
#tab.sort()
'''
#dla danych wejsciowych malejacych:
tab.sort(reverse=True)


#dla danych wejsciowych A-ksztaltnych:

middle = int(size/2)
A1 = tab[:middle]
A2 = tab[middle:]
A1.sort()
A2.sort(reverse=True)
tab=A1+A2



#dla danych wejsciowych V-ksztaltnych:

middle = int(size/2)
A1 = tab[:middle]
A2 = tab[middle:]
A1.sort(reverse=True)
A2.sort()
tab=A1+A2
'''

'''
    #WYWOLANIE MERGE SORT
A = tab.copy()
start = time.time()
merge_sort(tab)
end=time.time()
print("czas:  ", end - start)




    #WYWOLYWANIE QUICK SORT
print("Quick sort")

high = size-1
low= 0

start = time.time()
quickSort(tab,low,high)
end=time.time()
print("czas:  ", end - start)
'''


heapSort(tab)
#insertion_sort(tab)
#Shell_sort(tab)

