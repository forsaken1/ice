solve(true, 0) :- !.
solve(Head, Count) :- not(clause(Head, Body)), fail.
solve((Goal1, Goal2), Count) :-!, solve(Goal1, Count), solve(Goal2, Count), Count is Count + 2.
solve(Head, Count) :- clause(Head, Body), solve(Body, Count), Count is Count + 1.

web_lang(php).
web_lang(python).
web_lang(javascript).

programmer(john, php).
programmer(steve, c_plus_plus).
programmer(andrew, python).
programmer(marie, pure_c).
programmer(tommy, javascript).
programmer(james, ruby).

is_web_lang(L) :-
    web_lang(L).

web_programmer(Somebody) :-
	programmer(Somebody, ruby); programmer(Somebody, Lang), is_web_lang(Lang).