 /*************************************************************************
 *									 *
 *	 YAP Prolog 							 *
 *									 *
 *	Yap Prolog was developed at NCCUP - Universidade do Porto	 *
 *									 *
 * Copyright L.Damas, V.S.Costa and Universidade do Porto 1985-1997	 *
 *									 *
 *************************************************************************/

:- system_module( '$os', [ 
	       cd/0,
	       cd/1,
	       getcwd/1,
	       ls/0,
	       pwd/0,
	       unix/1,
	       putenv/2,
	       getenv/2,
	       setenv/2
	 ], [] ).
:- use_system_module( '$_errors', ['$do_error'/2]).

/**
 * @short YAP core Operating system interface.
 *
 */

cd :-
	cd('~').

cd(F) :-
		format( atom( M ), 'before absolute_file_name ~w', [F]), log_event( M ),
      absolute_file_name(F, Dir, [file_type(directory),file_errors(fail),access(execute),expand(true)]),
      working_directory(_, Dir).

getcwd(Dir) :- working_directory(Dir, Dir).

ls :-
	getcwd(X),
	'$load_system_ls'(X,L),
	'$do_print_files'(L).

'$load_system_ls'(X,L) :-
	'$undefined'(directory_files(X, L), operating_system_support),
	load_files(library(system),[silent(true)]),
	fail.
'$load_system_ls'(X,L) :-
	operating_system_support:directory_files(X, L).
	

'$do_print_files'([]) :-
	nl.
'$do_print_files'([F| Fs]) :-
	'$do_print_file'(F),
	'$do_print_files'(Fs).

'$do_print_file'('.') :- !.
'$do_print_file'('..') :- !.
'$do_print_file'(F) :- atom_concat('.', _, F), !.
'$do_print_file'(F) :-
	write(F), write('  ').

pwd :-
	getcwd(X),
	write(X), nl.

unix(V) :- var(V), !,
	'$do_error'(instantiation_error,unix(V)).
unix(argv(L)) :- '$is_list_of_atoms'(L,L), !, '$argv'(L).
unix(argv(V)) :-
	'$do_error'(type_error(atomic,V),unix(argv(V))).
unix(cd) :- cd('~').
unix(cd(A)) :- cd(A).
unix(environ(X,Y)) :- '$do_environ'(X,Y).
unix(getcwd(X)) :- getcwd(X).
unix(shell(V)) :- var(V), !,
	'$do_error'(instantiation_error,unix(shell(V))).
unix(shell(A)) :- atom(A), !, '$shell'(A).
unix(shell(A)) :- string(A), !, '$shell'(A).
unix(shell(V)) :-
	'$do_error'(type_error(atomic,V),unix(shell(V))).
unix(system(V)) :- var(V), !,
	'$do_error'(instantiation_error,unix(system(V))).
unix(system(A)) :- atom(A), !, system(A).
unix(system(A)) :- string(A), !, system(A).
unix(system(V)) :-
	'$do_error'(type_error(atom,V),unix(system(V))).
unix(shell) :- sh.
unix(putenv(X,Y)) :- '$putenv'(X,Y).


'$is_list_of_atoms'(V,_) :- var(V),!.
'$is_list_of_atoms'([],_) :- !.
'$is_list_of_atoms'([H|L],L0) :- !,
	'$check_if_head_may_be_atom'(H,L0),
	'$is_list_of_atoms'(L,L0).
'$is_list_of_atoms'(H,L0) :-
	'$do_error'(type_error(list,H),unix(argv(L0))).

'$check_if_head_may_be_atom'(H,_) :-
	var(H), !.
'$check_if_head_may_be_atom'(H,_) :-
	atom(H), !.
'$check_if_head_may_be_atom'(H,L0) :-
	'$do_error'(type_error(atom,H),unix(argv(L0))).


'$do_environ'(X, Y) :-
	var(X), !,
	'$do_error'(instantiation_error,unix(environ(X,Y))).
'$do_environ'(X, Y) :- atom(X), !,
	'$getenv'(X,Y).
'$do_environ'(X, Y) :-
	'$do_error'(type_error(atom,X),unix(environ(X,Y))).
	

putenv(Na,Val) :-
	'$putenv'(Na,Val).

getenv(Na,Val) :-
	'$getenv'(Na,Val).

setenv(Na,Val) :-
	'$putenv'(Na,Val).

