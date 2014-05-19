import sys
from gmpy2 import *
get_context().precision = 500
 
def decode():
  dict = []
  n = 0
       
  try:
    endlines, spaces = list(map(int, inf.readline().split()))
    n += endlines + spaces
    if endlines:
      dict.append(['\n', endlines])
    if spaces:
      dict.append([' ', spaces])     
    for x in inf.readline().split():
      c = x[0]
      frec = int(x[1:])
      n += frec
      dict.append([c,frec])
 
    beg = mpfr(0)
    n = mpfr(n)
    for x in dict:
      beg, x[1] = beg + x[1]/n, beg          
    key = mpfr(inf.read())
    beg = 0
  except ValueError:
    print('input file is not archive')
    return
  length = 1
  for i in range(int(n)):
    j = 0
    nend = beg
    while nend < key:
      j += 1
      if j == len(dict):
        nend = beg + length
        break                  
      nend = beg + dict[j][1]*length
#                       print(nend)
    outf.write(dict[j-1][0])
    beg = beg + dict[j-1][1]*length
    length = nend - beg
#               print(beg, length)
       
           
if len(sys.argv) != 3:
  print('use python ariDecoder.py <inputFile> <outputFile>')
else:          
  inf = open(sys.argv[1])
  outf = open(sys.argv[2],'w')           
       
  decode()
       
  inf.close()
  outf.close()