tidy(Lhs=Rhs) :-
	tidy_polynomial(Lhs),
	write('='),
	tidy_polynomial(Rhs).



tidy_polynomial(Arg+0) :-
	tidy_expr(Arg).

tidy_polynomial(0+Arg) :-
	tidy_expr(Arg).

tidy_polynomial(Arg1+Arg2) :-
	tidy_expr(Arg1),
	write('+'),
	tidy_expr(Arg2).

tidy_polynomial(Equation) :-
	tidy_expr(Equation).



tidy_expr(Arg*1) :-
	tidy_graduation(Arg).

tidy_expr(1*Arg) :-
	tidy_graduation(Arg).

tidy_expr(Arg1*Arg2) :-
	tidy_graduation(Arg1),
	write('*'),
	tidy_graduation(Arg2).

tidy_expr(Equation) :-
	tidy_graduation(Equation).



tidy_graduation(Arg^0) :-
	write('1').

tidy_graduation(1^Arg) :-
	write('1').

tidy_graduation(Arg1^Arg2) :-
	tidy_grad_arg_one(Arg1),
	tidy_grad_arg_two(Arg2).

tidy_graduation(Equation) :-
	write(Equation).

tidy_grad_arg_one(Equation) :-
	integer(Equation),
	Equation == 0.

tidy_grad_arg_one(Equation) :-
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
	write('^('),
	%write(Equation),
	tidy_polynomial(Equation),
	write(')').


% Tests

test(N) :- equation(N, E), tidy(E).

equation(1, x^1 = 1). 		% x=1
equation(2, x^2 = 1). 		% x^2=1
equation(3, x^1 = x^2).		% x=x^2
equation(4, x^5 = x^10).	% x^5=x^10
equation(5, x^1 + 0 = 10).	% x=10
equation(6, x^1 + 5 = 10).	% x+5=10
equation(7, x^5 + 1 = x^1 + 100). % x^5+1=x+100
equation(8, 1^5 = 1). 		% 1=1
equation(9, 123^0 = 1).		% 1=1
equation(10, 0^0 = 1^0).	% 1=1
equation(11, 2*x = 1 + 0). 	% 2*x=1
equation(12, x*1 = 0 + 0). 	% x=0
equation(13, x*1 = 0 + 0). 	% x=0
equation(14, x^1 = 1^100). 	% x=1
equation(15, x^(2*x + 2) = 1). % x^(2*x+2)=1
equation(16, x = 1^(30*x^2)).  % x=1
equation(17, x = cos(x)). 	% x=cos(x)
equation(18, x^2 = cos(x)^2). 	% x^2=cos(x)^2
equation(19, x^5 = cos(x)^0). 	% x^5=1
equation(20, sin(x) + 0 = 0 + cos(x)). % sin(x)+cos(x)
equation(21, cos(x) * 1 = 1 * sin(x)). % cos(x)+sin(x)
equation(22, cos(x)^(2*sin(x)) * 1 = 0 + sin(x)^(5 + cos(x))). % cos(x)^(2*sin(x))=sin(x)^(5+cos(x))
equation(100, 1^((2 * x)^l) + 2*x = cos(x)^0 + (x + 0)^2). 	   % 1+2*x=1+x^2