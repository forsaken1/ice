:- op(40,xfx,\).
:- op(50,xfx,^).

solve_equation(A*B=0,X,Solution) :- 
  !,
  factorize(A*B,X,Factors\[]),
  remove_duplicates(Factors,Factors1),
  solve_factors(Factors1,X,Solution).

solve_equation(Equation,X,Solution) :-
  single_occurrence(X,Equation), 
  !,
  position(X,Equation,[Side|Position]),
  maneuver_sides(Side,Equation,Equation1),
  isolate(Position,Equation1,Solution).

solve_equation(Lhs=Rhs,X,Solution) :-
  polynomial(Lhs,X),
  polynomial(Rhs,X),
  !,
  polynomial_normal_form(Lhs-Rhs,X,PolyForm),
  solve_polynomial_equation(PolyForm,X,Solution).

solve_equation(Equation,X,Solution) :-
  offenders(Equation,X,Offenders),
  multiple(Offenders),
  %homogenize(Equation,X,Offenders,Equation1,X1), % off
  homogenize(Equation,X,Equation1,X1), % on
  solve_equation(Equation1,X1,Solution1),
  solve_equation(Solution1,X,Solution).


factorize(A*B,X,Factors\Rest) :-
  !, factorize(A,X,Factors\Factors1), factorize(B,X,Factors1\Rest).
  factorize(C,X,[C|Factors]\Factors) :-
  subterm(X,C),  !.
  factorize(C,X,Factors\Factors).


solve_factors([Factor|Factors],X,Solution) :-
  solve_equation(Factor=0,X,Solution).
solve_factors([Factor|Factors],X,Solution) :-
  solve_factors(Factors,X,Solution).

/*  The isolation method  */

maneuver_sides(1,Lhs = Rhs,Lhs = Rhs) :- !.
maneuver_sides(2,Lhs = Rhs,Rhs = Lhs) :- !.

isolate([N|Position],Equation,IsolatedEquation) :- 
  isolax(N,Equation,Equation1), 
  isolate(Position,Equation1,IsolatedEquation).
  isolate([],Equation,Equation).

/* Axioms for Isolation  */

isolax(1,-Lhs = Rhs,Lhs = -Rhs).      % Unary minus 

isolax(1,Term1+Term2 = Rhs,Term1 = Rhs-Term2).    % Addition
isolax(2,Term1+Term2 = Rhs,Term2 = Rhs-Term1).    % Addition

isolax(1,Term1-Term2 = Rhs,Term1 = Rhs+Term2).    % Subtraction
isolax(2,Term1-Term2 = Rhs,Term2 = Term1-Rhs).    % Subtraction

isolax(1,Term1*Term2 = Rhs,Term1 = Rhs/Term2) :-  % Multiplication 
   Term2 \== 0.
isolax(2,Term1*Term2 = Rhs,Term2 = Rhs/Term1) :-  % Multiplication 
   Term1 \== 0.

isolax(1,Term1/Term2 = Rhs,Term1 = Rhs*Term2) :-  % Division
   Term2 \== 0.
isolax(2,Term1/Term2 = Rhs,Term2 = Term1/Rhs) :-  % Division
   Rhs \== 0. 

isolax(1,Term1^Term2 = Rhs,Term1 = Rhs^(-Term2)). % Exponentiation $$$ ^
isolax(2,Term1^Term2 = Rhs,Term2 = log(base(Term1),Rhs)). % Exponentiation

isolax(1,sin(U) = V,U = arcsin(V)).     % Sine
isolax(1,sin(U) = V,U = 180 - arcsin(V)).   % Sine
isolax(1,cos(U) = V,U = arccos(V)).     % Cosine
isolax(1,cos(U) = V,U = -arccos(V)).      % Cosine

/*  The polynomial method */

polynomial(X,X) :- !.
polynomial(Term,X) :- 
  atomic(Term), !. % заменил на integer
polynomial(Term1+Term2,X) :- 
  !, polynomial(Term1,X), polynomial(Term2,X).
polynomial(Term1-Term2,X) :- 
  !, polynomial(Term1,X), polynomial(Term2,X).
polynomial(Term1*Term2,X) :- 
  !, polynomial(Term1,X), polynomial(Term2,X).
polynomial(Term1/Term2,X) :- 
  !, polynomial(Term1,X), atomic(Term2). % constant to integer
polynomial(Term ^ N,X) :-  
  !, integer(N), N >= 0, polynomial(Term,X).  

polynomial_normal_form(Polynomial,X,NormalForm) :-
  polynomial_form(Polynomial,X,PolyForm),
  remove_zero_terms(PolyForm,NormalForm), !.

polynomial_form(X,X,[(1,1)]).
polynomial_form(X^N,X,[(1,N)]).

polynomial_form(Term1+Term2,X,PolyForm) :-
  polynomial_form(Term1,X,PolyForm1),
  polynomial_form(Term2,X,PolyForm2),
  add_polynomials(PolyForm1,PolyForm2,PolyForm).

polynomial_form(Term1-Term2,X,PolyForm) :-
  polynomial_form(Term1,X,PolyForm1),
  polynomial_form(Term2,X,PolyForm2),
  subtract_polynomials(PolyForm1,PolyForm2,PolyForm).

polynomial_form(Term1*Term2,X,PolyForm) :-
  polynomial_form(Term1,X,PolyForm1),
  polynomial_form(Term2,X,PolyForm2),
  multiply_polynomials(PolyForm1,PolyForm2,PolyForm).

polynomial_form(Term^N,X,PolyForm) :- !,
  polynomial_form(Term,X,PolyForm1),
  binomial(PolyForm1,N,PolyForm).

polynomial_form(Term,X,[(Term,0)]) :-
  free_of(X,Term), !.

remove_zero_terms([(0,N)|Poly],Poly1) :-
  !, remove_zero_terms(Poly,Poly1).

remove_zero_terms([(C,N)|Poly],[(C,N)|Poly1]) :-
  C \== 0, !, remove_zero_terms(Poly,Poly1).

remove_zero_terms([],[]).

/*  Polynomial manipulation routines   */

add_polynomials([],Poly,Poly) :- !.

add_polynomials(Poly,[],Poly) :- !.

add_polynomials([(Ai,Ni)|Poly1],[(Aj,Nj)|Poly2],[(Ai,Ni)|Poly]) :-
  Ni > Nj, !, add_polynomials(Poly1,[(Aj,Nj)|Poly2],Poly).

add_polynomials([(Ai,Ni)|Poly1],[(Aj,Nj)|Poly2],[(A,Ni)|Poly]) :-
  Ni =:= Nj, !, A is Ai+Aj, add_polynomials(Poly1,Poly2,Poly).

add_polynomials([(Ai,Ni)|Poly1],[(Aj,Nj)|Poly2],[(Aj,Nj)|Poly]) :-
  Ni < Nj, !, add_polynomials([(Ai,Ni)|Poly1],Poly2,Poly).

subtract_polynomials(Poly1,Poly2,Poly) :-
  multiply_single(Poly2,(-1,0),Poly3),
  add_polynomials(Poly1,Poly3,Poly), !.

multiply_single([(C1,N1)|Poly1],(C,N),[(C2,N2)|Poly]) :-
  C2 is C1*C, N2 is N1+N, multiply_single(Poly1,(C,N),Poly).
  multiply_single([],Factor,[]).

multiply_polynomials([(C,N)|Poly1],Poly2,Poly) :-
  multiply_single(Poly2,(C,N),Poly3),
  multiply_polynomials(Poly1,Poly2,Poly4),
  add_polynomials(Poly3,Poly4,Poly).

multiply_polynomials([],P,[]).

binomial(Poly,1,Poly).
  
solve_polynomial_equation(PolyEquation,X,X = -B/A) :-
  linear(PolyEquation), !, 
  pad(PolyEquation,[(A,1),(B,0)]).

solve_polynomial_equation(PolyEquation,X,Solution) :-
  quadratic(PolyEquation), !,
  pad(PolyEquation,[(A,2),(B,1),(C,0)]),
  discriminant(A,B,C,Discriminant),
  root(X,A,B,C,Discriminant,Solution).

discriminant(A,B,C,D) :- D is B*B - 4*A*C.

root(X,A,B,C,0,X= -B/(2*A)).
root(X,A,B,C,D,X= (-B+sqrt(D))/(2*A)) :- D > 0.
root(X,A,B,C,D,X= (-B-sqrt(D))/(2*A)) :- D > 0.

pad([(C,N)|Poly],[(C,N)|Poly1]) :-
  !, pad(Poly,Poly1).

pad(Poly,[(0,N)|Poly1]) :-
  pad(Poly,Poly1).

pad([],[]).

linear([(Coeff,1)|Poly]).  

quadratic([(Coeff,2)|Poly]).

homogenize(Equation,X,Equation1,X1) :-
  offenders(Equation,X,Offenders),
  reduced_term(X,Offenders,Type,X1),
  rewrite(Offenders,Type,X1,Substitutions),
  substitute(Equation,Substitutions,Equation1).

offenders(Equation,X,Offenders) :-
  parse(Equation,X,Offenders1\[]),
  remove_duplicates(Offenders1,Offenders),
  multiple(Offenders).

reduced_term(X,Offenders,Type,X1) :-
  classify(Offenders,X,Type),
  candidate(Type,Offenders,X,X1).

/*  Heuristics for exponential equations  */
 
classify(Offenders,X,exponential) :-
  exponential_offenders(Offenders,X).

exponential_offenders([A^B|Offs],X) :-
  free_of(X,A), subterm(X,B), exponential_offenders(Offs,X).

exponential_offenders([],X).

candidate(exponential,Offenders,X,A^X) :-
  base(Offenders,A), polynomial_exponents(Offenders,X).

 base([A^B|Offs],A) :- base(Offs,A).
 base([],A).

polynomial_exponents([A^B|Offs],X) :-
  polynomial(B,X), polynomial_exponents(Offs,X).

polynomial_exponents([],X).

/*   Parsing the equation and making substitutions     */

parse(A+B,X,L1\L2) :-
  !, parse(A,X,L1\L3), parse(B,X,L3\L2).     
parse(A*B,X,L1\L2) :-
  !, parse(A,X,L1\L3), parse(B,X,L3\L2).     
parse(A-B,X,L1\L2) :-
  !, parse(A,X,L1\L3), parse(B,X,L3\L2).     
parse(A=B,X,L1\L2) :-
  !, parse(A,X,L1\L3), parse(B,X,L3\L2).     
parse(A^B,X,L) :-
  integer(B), !, parse(A,X,L).
parse(A,X,L\L) :-
  free_of(X,A), !.
parse(A,X,[A|L]\L) :-
  subterm(X,A), !.

substitute(A+B,Subs,NewA+NewB) :-
  !, substitute(A,Subs,NewA), substitute(B,Subs,NewB).     
substitute(A*B,Subs,NewA*NewB) :-
  !, substitute(A,Subs,NewA), substitute(B,Subs,NewB).     
substitute(A-B,Subs,NewA-NewB) :-
  !, substitute(A,Subs,NewA), substitute(B,Subs,NewB).     
substitute(A=B,Subs,NewA=NewB) :-
  !, substitute(A,Subs,NewA), substitute(B,Subs,NewB).     
substitute(A^B,Subs,NewA^B) :-
  integer(B), !, substitute(A,Subs,NewA).
substitute(A,Subs,B) :-
  member(A=B,Subs), !.
substitute(A,Subs,A).

/*  Finding homogenization rewrite rules */
 
rewrite([Off|Offs],Type,X1,[Off=Term|Rewrites]) :-
  homogenize_axiom(Type,Off,X1,Term),
  rewrite(Offs,Type,X1,Rewrites).
rewrite([],Type,X,[]).

/*  Homogenization axioms  */

homogenize_axiom(exponential,A^(N*X),A^X,(A^X)^N).
homogenize_axiom(exponential,A^(-X),A^X,1/(A^X)).
homogenize_axiom(exponential,A^(X+B),A^X,A^B*A^X).

/*  Utilities */

subterm(Term,Term).
subterm(Sub,Term) :-
  compound(Term), functor(Term,F,N), subterm(N,Sub,Term).

subterm(N,Sub,Term) :-
   arg(N,Term,Arg), subterm(Sub,Arg).
subterm(N,Sub,Term) :-
  N > 0,
  N1 is N - 1,
  subterm(N1,Sub,Term).

position(Term,Term,[]) :- !.
position(Sub,Term,Path) :-
  compound(Term), functor(Term,F,N), position(N,Sub,Term,Path), !.

position(N,Sub,Term,[N|Path]) :-
   arg(N,Term,Arg), position(Sub,Arg,Path).
position(N,Sub,Term,Path) :- 
   N > 1, N1 is N-1, position(N1,Sub,Term,Path).

free_of(Subterm,Term) :-
  occurrence(Subterm,Term,N), !, N=0.

single_occurrence(Subterm,Term) :-      
  occurrence(Subterm,Term,N), !, N=1.

occurrence(Term,Term,1) :- !.
occurrence(Sub,Term,N) :-
  compound(Term), !, functor(Term,F,M), occurrence(M,Sub,Term,0,N).
occurrence(Sub,Term,0) :- Term \== Sub.

occurrence(M,Sub,Term,N1,N2) :-
  M > 0, !, arg(M,Term,Arg), occurrence(Sub,Arg,N), N3 is N+N1,
  M1 is M-1, occurrence(M1,Sub,Term,N3,N2).
occurrence(0,Sub,Term,N,N).

multiple([X1,X2|Xs]).

remove_duplicates(Xs,Ys) :- no_doubles(Xs,Ys).

no_doubles([X|Xs],Ys) :-
  member(X,Xs), no_doubles(Xs,Ys).
no_doubles([X|Xs],[X|Ys]) :-
  nonmember(X,Xs), no_doubles(Xs,Ys).
no_doubles([],[]).

nonmember(X,[Y|Ys]) :- X \== Y, nonmember(X,Ys).
nonmember(X,[]).

compound(Term) :- functor(Term,F,N),N > 0,!.

%  Testing and data

test_press(X,Y) :- equation(X,E,U), solve_equation(E,U,Y).

equation(1,x^2-3*x+2=0,x).

equation(2,cos(x)*(1-2*sin(x))=0,x).

equation(3,2^(2*x) - 5*2^(x+1) + 16 = 0,x).

equation(4,1^((2*x)^l)+2*x=cos(x)^0+(x+0)^2,x).