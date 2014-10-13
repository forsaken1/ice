solve(true) :- !.
solve(not A) :- not(solve(A)).
solve((A, B)) :- !, solve(A), solve(B).
solve(A) :- clause(A, B), solve(B).