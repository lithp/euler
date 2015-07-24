#!/usr/bin/swipl -q -t main -s

:- use_module(library(assoc)).
:- use_module(library(pairs)).

divides(X, Y) :- 0 is X mod Y.

prime(X) :- X > 1,
            Limit is floor(sqrt(X)),
            foreach(between(2, Limit, Factor), not(divides(X, Factor))).

fill([], _, 0).
fill([X|Xs], X, N) :- N0 is N-1, fill(Xs, X, N0).

gen_primes(N) :- findall(X, (between(2, N, X), prime(X)), Primes),
                         length(Primes, Length),
                         fill(Trues, true, Length),
                         pairs_keys_values(Pairs, Primes, Trues),
                         list_to_assoc(Pairs, PrimeAssoc),
                         nb_setval(primeassoc, PrimeAssoc).

is_prime(X) :- nb_getval(primeassoc, PrimeAssoc),
               get_assoc(X, PrimeAssoc, _).

rotate([H | Rest], R) :- append(Rest, [H], R).

rotations(List, Rotations) :- length(List, Length),
                              rotations(Length, List, Rotations).
rotations(1, List, [Rotation]) :- rotate(List, Rotation).
rotations(N, List, [Rotation | Rest]) :- Next is N - 1,
                                         rotate(List, Rotation),
                                         rotations(Next, Rotation, Rest).

int_rotations(X, Rotations) :- number_chars(X, Chars),
                               rotations(Chars, CharRotations),
                               maplist(number_chars, Rotations, CharRotations), !.

% cyclic_prime(X) :- 0 is X mod 1000, writeln(X), false.
cyclic_prime(X) :- int_rotations(X, Rotations),
                   maplist(is_prime, Rotations), !.

cyclic_primes(N, Cyclics) :- findall(X, (between(2, N, X), cyclic_prime(X)), Cyclics).

main :- Million = 1000000,
        gen_primes(Million),
        cyclic_primes(Million, Cyclics),
        length(Cyclics, Count),
        writeln(Count).
