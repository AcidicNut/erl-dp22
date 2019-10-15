-module(khf2).
-author('email@unit.org.hu').
-vsn('year-mm-dd').
%-export([ertekek/2]).
-compile(export_all).

% X elem torlese L listabol
torles(X, L)-> [Y || Y <- L, Y =/= X].

% Egy cella elemein iteral es torli a lehetosegek (L lista) kozul
elemFilter(L, Elemek) when (length(Elemek) < 1) -> L;
elemFilter(L, Elemek) -> elemFilter(torles(hd(Elemek), L), tl(Elemek)).

% R. soron iteral + sorElem segedfv hivas
sorVizsgalo(L, Row) when (length(Row) < 1) -> L;
sorVizsgalo(L, Row) -> sorVizsgalo(elemFilter(L, hd(Row)), tl(Row)).

% Vegig iteral Sudoku sorain es minden C. cellaban levo elemet filterezik
oszlop(L, M, _C) when (length(M) < 1) -> L;
oszlop(L, M, C) -> oszlop(elemFilter(L, lists:nth(C, hd(M))), tl(M), C).

ertekek({K, M}, {R, C}) -> oszlop(sorVizsgalo(lists:seq(1,K*K), lists:nth(R, M)), M, C).