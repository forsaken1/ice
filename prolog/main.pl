factorial(1, 1).
factorial(X, Result) :-
    X > 0,
    X1 is X - 1,
    factorial(X1, Result1),
    Result is X * Result1.

main :-
    factorial(7, X),
    writeln(X).