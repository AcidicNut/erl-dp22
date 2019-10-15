-module(khf2).
-author('email@unit.org.hu').
-vsn('year-mm-dd').
%-export([ertekek/2]).
-compile(export_all).

torles(X, L)-> [Y || Y <- L, Y =/= X].

sorElem(L, Elemek) when (length(Elemek) < 1) -> L;
sorElem(L, Elemek) -> sorElem(torles(hd(Elemek), L), tl(Elemek)).

sorVizsgalo(L, Row) when (length(Row) < 1) -> L;
sorVizsgalo(L, Row) -> sorVizsgalo(sorElem(L, hd(Row)), tl(Row)).

ertekek({K, M}, {R, C}) -> sorVizsgalo(lists:seq(1,K*K), lists:nth(R, M)).