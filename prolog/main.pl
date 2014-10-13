make_date(Y,M,D,date(Y,M,D)).
date(1993,02,22).
    get_year(date(Y,_,_),Y). 
    get_month(date(_,M,_),M). 
    get_day(date(_,_,D),D). 