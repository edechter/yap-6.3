
:- object(potions).


	:- info([
		version is 1.0,
		date is 2004/4/29,
		author is 'Paulo Moura',
		comment is 'Harry Potter potions logical puzzle.']).

	:- uses(list).

	:- public(potions/7).
	:- mode(potions(?atom, ?atom, ?atom, ?atom, ?atom, ?atom, ?atom), zero_or_one).
	:- info(potions/7, [
		comment is 'Contents of the seven potions.',
		argnames is ['P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7']]).


	contents([wine, wine, poison, poison, poison, forward, backwards]).

	potions(P1, P2, P3, P4, P5, P6, P7) :-
		contents(H1),
		list::select(P1, H1, H2),
		list::select(P7, H2, H3),
		P1 \= P7, P1 \= forward, P7 \= forward,					% second clue
		list::select(P2, H3, H4),
		P2 \= poison,
		list::select(P3, H4, H5),
		P3 \= poison,											% third clue
		P2 = P6,
		list::select(P6, H5, H6),								% fourth clue
		list::select(P4, H6, H7),
		list::select(P5, H7, []),
		two_pairs_poison_wine([P1, P2, P3, P4, P5, P6, P7]).	% first clue
	

	two_pairs_poison_wine(S) :-
		poison_wine_pair(S, R),
		poison_wine_pair(R, _).

	poison_wine_pair([poison, wine| R], R) :-
		!.

	poison_wine_pair([_| L], R) :-
		poison_wine_pair(L, R).


:- end_object.
