tidy(Lhs=Rhs) :-
	!,
	tidy_polynomial(Lhs),
	write('='),
	tidy_polynomial(Rhs).



tidy_polynomial(Arg1+Arg2) :-
	!,
	tidy_expr(Arg1),
	write('+'),
	tidy_expr(Arg2).

tidy_polynomial(Equation) :-
	!,
	tidy_expr(Equation).



tidy_expr(Arg1*Arg2) :-
	!,
	tidy_graduation(Arg1),
	write('*'),
	tidy_graduation(Arg2).

tidy_expr(Equation) :-
	!,
	tidy_graduation(Equation).



tidy_graduation(Arg1^Arg2) :-
	!,
	tidy_grad_arg_one(Arg1),
	tidy_grad_arg_two(Arg2).

tidy_graduation(Equation) :-
	!,
	write(Equation).

tidy_grad_arg_one(Equation) :-
	!,
	integer(Equation),
	Equation == 1,
	Equation == 0.

tidy_grad_arg_one(Equation) :-
	!,
	write(Equation).

tidy_grad_arg_two(Equation) :-
	integer(Equation),
	Equation == 1.

tidy_grad_arg_two(Equation) :-
	integer(Equation),
	Equation > 1,
	write('^'),
	write(Equation).

tidy_grad_arg_two(Equation) :-
	write('('),
	write(Equation),
	write(')').


% Tests

test(N) :- equation(N, E), tidy(E).

equation(1, x^1 = 1). % x=1
equation(2, 2*x = 1 + 0). % 2*x=1
equation(3, x*1 = 0 + 0). % x=0
equation(4, x^1 = 1^100). % x=1
equation(10, 1^(2 * x) + 2*x = cos(x)^0 + (x + 0)^2). % 1+2*x=1+x^2