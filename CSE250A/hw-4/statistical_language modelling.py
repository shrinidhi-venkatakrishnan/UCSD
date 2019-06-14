from math import log
import numpy as np
import matplotlib.pyplot as plt
import pandas

vocabulary= open("hw4_vocab.txt","r");
unigram= open("hw4_unigram.txt");
bigram=open("hw4_bigram.txt");

a=[]
b=[]
prob_final=[]
uni_prob=[]
uniprob2=[]
summ=0
for numbers in unigram:              
    numbers=int(numbers)
    a.append(numbers)                #listing all counts in unigram as matrix
    summ=summ+numbers                #finding total count
    
for val in a:
    uniprob2.append(val/summ)        #finding unigram probability of each word 
for words in vocabulary:
    b.append(words.strip())          #forming a list from vocabulary 
    

first_letter='A'                     #start with the letter "A"
output_names=[]     
index_uni=[]
for name in b:
    if name[0]=='A':
        result = b.index(name)      #get index of words starting with letter A
        output_names.append(name)   #out put words having start letter A
        index_uni.append(result)    #index of A words being appended
        
for numbers in a:
    if a.index(numbers) in index_uni:  #if index of unigram probability matches with index in the list of words starting with A
        numbers=int(numbers)
        prob=numbers/summ              #calculate individual probabilities
        prob_final.append(prob)        #total list of probabilities as a list

print(pandas.DataFrame(prob_final,output_names))
 #######################################################################################################################   
#problem B

c=[]
list_0=[]
list_1=[]
list_2=[]
big=[]
    
with open('hw4_bigram.txt') as textFile:
    
    for line in textFile:
        bigram=line.split()                    #splitting the line into individual words 
        list_0.append(bigram[0])               #appending the index of given word in one list
        list_1.append(bigram[1])               #appending index of 'to be predicted' word in another list 
        list_2.append(bigram[2])               #appending the bigram count into another list
        big.append([int(bigram[0]), int(bigram[1])])  #appending only the indices of given and to be predicted word
        
sums=0
for index, i in enumerate(list_0):
    if(i=='4'):       
        sums=sums+int(list_2[index])        #adding the counts of all occurences of THE followed by any word

               
denominator_the=sums                       #count of the number of times 'THE' has occured 

final_list = []
def Nmaxelements(list1, N):                #function for finding the top 5 occuring words in a list 
    for i in range(0, N):  
        max1 = 0
        for j in range(len(list1)):
            list1[j]=int(list1[j])
            if list1[j] > max1: 
                max1 = list1[j]; 
                  
        list1.remove(max1); 
        final_list.append(max1) 
          
listtt = list_2[993:1464]               #counts of only words following the 
N = 5
Nmaxelements(listtt, N)                 #finding maximum counts
final_list=['2371132', '51556', '45186', '44949', '36439']
top=[]

for i in final_list:
    indd=list_2.index(i)       #get index of the maximum counts
    inddd=int(list_1[indd])    #find index of the given word
    j=b[inddd-1]               #find the word in the vocabulary
    top.append(j)              #appending all the top words
print('\n')
print('THE TOP FIVE WORDS ARE:')    
print(top)
for num in final_list:
    print(int(num)/denominator_the)  #finding the bigram probabilities of each top word
closure=[]
denom=[0]*501

for index, val in enumerate(list_0):
    denom[int(val)] += int(list_2[index])
for index, val in enumerate(list_0):
    closure.append(float(list_2[index])/denom[int(val)])  #finding the bigram probabilities of all the words
    
    
    #part c
sentence='Last week the stock market fell by one hundred points'
sentence=sentence.upper()                                        #changing to upper case
SENTENCE=sentence.split()                                        #splitting into words
COUNT=0
frek=0
P=1;
probarray=[]
for words in vocabulary:
    b.append(words.strip())
for name in b:                                      #for all words in vocabulary
    for reference in SENTENCE:                      #for the words in the given sentence
        if name==reference:                         #if the words match then:
            result = b.index(name)                  #get the index of the words from the vocabulary list
            frek=int(a[result])                     #get the unigram count
            #print(reference, frek/summ)
            prob=frek/summ                          #calculate probability
            probarray.append(prob)                  #append it as a list
            P=P*prob                                #product of all the probabilities          
print('log likelihood in unigram',log(P))           #log likelihood

#bigram model for comparison
BIPROBARRAY=[]
def bigrams(SENTENCE):                              #function for finding bigram probability
    PROBABILITY=1                                   #P=1
    char='<s>'                                      #char  
    SENTENCE.insert(0,char)                         # insert character 
    SIZE=len(SENTENCE)                                       
    for indexx,values in enumerate(SENTENCE) :
        if(indexx+1<=SIZE-1):                       #length requirement
            pos1=(b.index(SENTENCE[indexx]))        #find the position of the word in the vocabulary list
            pos2=(b.index(SENTENCE[indexx+1]))      #find position of second word in sentence
            if ([pos1+1, pos2+1])in big:            #if these indices are occuring in big
                indz=big.index([pos1+1,pos2+1])     #find the index of occurence
                probability_inter=closure[indz]     #find the corresponding bigram probability
                PROBABILITY=PROBABILITY*probability_inter  # find the product of the probability
            else:
                print('words not occuring together are',SENTENCE[indexx],SENTENCE[indexx+1])
                PROBABILITY=0
    if PROBABILITY==0:
        print(' BIGRAM LOG PROBABILITY is UNDEFINED')
    else:
        print( 'BIGRAM LOG PROBABILITY IS',log(PROBABILITY)) #print the log of the answer    
bigrams(SENTENCE)                                           #call the function
    
    
    sentence='The nineteen officials sold fire insurance'
sentence=sentence.upper()
SENTENCE=sentence.split()
COUNT=0
frek=0
P=1;
probarray=[]
for words in vocabulary:
    b.append(words.strip())
for name in b:                #unigram probability
    for reference in SENTENCE:  
        if name==reference:
            result = b.index(name)     
            frek=int(a[result])
            prob=frek/summ
            probarray.append(prob)
            P=P*prob
print('log likelihood of 2nd sentence in unigram',log(P))

bigrams(SENTENCE)           #calling the bigram function

#mixture model
def Pmix(SENTENCE):
    l=0;
    lmlist=[]
    llist = []
    first='<s>'
    SENTENCE.insert(0,first);
    while l<1:                              #while lambda is less than 1
        pmtotal=0   
        for index,w in enumerate(SENTENCE):
            if index+1 == len(SENTENCE):     #condition for length
                break
            pos1= b.index((SENTENCE[index])) #index of the given word in vocabulary 
            pos2= b.index((SENTENCE[index+1])) #index of the to be predicted word in vocabulary
            if ([pos1+1, pos2+1]) in big:      #if these indices occur together in big
                i= big.index([pos1+1,pos2+1])  #get the index of occurence
                puni= uniprob2[pos2]           # get the unigram probability of that word
                pbi= closure[i]                #get the bigram probability
            else:
                puni= uniprob2[pos2]            
                pbi=0;
            pm= ((1-l)*puni) + (l*pbi)        #mixture model formula
            pmtotal +=  log(pm)               #taking log of the answer
            
        lm = pmtotal
        lmlist.append(lm)                     #appending the maximum likelihoods for the pairs of words
        llist.append(l)                       #making a list of lambda values
        l=l+0.01;                             #incrementing lambda

    return lmlist, llist

sentence='The nineteen officials sold fire insurance'  #the test sentence
sentence= sentence.upper()
SENTENCE= sentence.split()
lml, ll= Pmix(SENTENCE)         #maximum likelihood and lambda values returned
plt.plot(ll,lml)                  #plotting the graph
plt.ylabel('log likelihood')
plt.xlabel('lambda')
plt.show()
maxI= max(lml);                #maximum of log likelihoods
ind2= lml.index(maxI)          #find index where this occurs
lvalue= ll[ind2];              #lambda value in that position is
print('Optimal value of lambda is ', lvalue)
