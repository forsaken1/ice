require '../lib/lib.rb'
 
def encode(data)
  dict = []
  n = 0
       
  begin
    endlines, spaces = list(map(int, inf.readline().split()))
    n += endlines + spaces

    if endlines
      dict << ['\n', endlines]
    end

    if spaces
      dict << [' ', spaces]
    end

    for x in inf.readline().split()
      c = x[0]
      frec = x[1:].to_i
      n += frec
      dict << [c,frec]
 
    beg = mpfr(0)
    n = mpfr(n)
    for x in dict:
      beg, x[1] = beg + x[1]/n, beg          
    key = mpfr(inf.read())
    beg = 0
  rescue Exception
    return 'input file is not archive'
  end

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
    outf.write(dict[j-1][0])
    beg = beg + dict[j-1][1]*length
    length = nend - beg  
end

init("Arithm encoding") { |text| encode(text) }