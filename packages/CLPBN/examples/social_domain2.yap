:- use_module(library(pfl)).

%:- set_solver(lve).
%:- set_solver(hve).
%:- set_solver(bp).
%:- set_solver(cbp).

:- yap_flag(write_strings, off).

:- multifile people/1.

people @ 5.

people(X,Y) :-
    people(X),
    people(Y).
%    X \== Y.

markov smokes(X)::[t,f]; [1.0, 4.0552]; [people(X)].

markov asthma(X)::[t,f]; [1.0, 9.9742] ; [people(X)].

markov friends(X,Y)::[t,f]; [1.0, 99.48432] ; [people(X,Y)].

markov asthma(X)::[t,f], smokes(X)::[t,f]; [4.48169, 4.48169, 1.0, 4.48169] ; [people(X)].

markov asthma(X)::[t,f], friends(X,Y)::[t,f], smokes(Y)::[t,f];
    [3.004166, 3.004166, 3.004166, 3.004166, 3.004166, 1.0, 1.0, 3.004166] ; [people(X,Y)].

% ?- smokes(p1,t), smokes(p2,t), friends(p1,p2,X)

