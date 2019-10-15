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

% Vegig iteral Sudoku sorain es minden C. cellaban levo elemet filterezi
oszlop(L, M, _C) when (length(M) < 1) -> L;
oszlop(L, M, C) -> oszlop(elemFilter(L, lists:nth(C, hd(M))), tl(M), C).

% Sorok es oszlopok vizsgalatakor kivesszuk amink volt, ezert most visszaadjuk
eredetiCellaPlusz(L, M, R, C) -> (L ++ lists:nth(C, lists:nth(R, M))) -- [e,o,w,s].

% R,C koordinata nagy cellajanak kezdo es utolso oszlopa
kezdoCol(C, K) -> (C div K) * K + 1.
vegeCol(C, K) -> (C div K) * K + K.

% R,C koordinata nagy cellajanak kezdo es utolso sora
kezdoRow(R, K) -> (R div K) * K + 1.
vegeRow(R, K) -> (R div K) * K + K.

% R,C koordinata elemeit itt nem szabad kivenni a lehetosegekbol
rRow(L, C, K, ActRow) -> sorVizsgalo(sorVizsgalo(L, lists:sublist(ActRow, kezdoCol(C, K), C - kezdoCol(C, K))), lists:sublist(ActRow, C + 1, vegeCol(C,K) - C)).

% Vegig megy R,C koordinata K*K-s cellajan, es filterez
kszkSorok(L, K, _M, R, _C, ActRow) when (ActRow > (R div K) * K + K) -> L;
kszkSorok(L, K, M, R, C, ActRow) when (ActRow =:= R) -> kszkSorok(rRow(L, C, K, lists:nth(ActRow, M)), K, M, R, C, ActRow + 1);
kszkSorok(L, K, M, R, C, ActRow) -> kszkSorok(sorVizsgalo(L, lists:sublist(lists:nth(ActRow, M), kezdoCol(C, K), K)), K, M, R, C, ActRow +1).

oOrE(L, ActCell) when (length(ActCell) < 1) -> L;
oOrE(L, ActCell) when (hd(ActCell) == e) -> oOrE([Y || Y <- L, Y rem 2 =:= 0], tl(ActCell));
oOrE(L, ActCell) when (hd(ActCell) == o) -> oOrE([Y || Y <- L, Y rem 2 =/= 0], tl(ActCell));
oOrE(L, ActCell) -> oOrE(L, tl(ActCell)).

ertekek({K, M}, {R, C}) -> oOrE(kszkSorok(eredetiCellaPlusz(oszlop(sorVizsgalo(lists:seq(1,K*K), lists:nth(R, M)), M, C), M, R, C), K, M, R, C, kezdoRow(R,K)), lists:nth(C, lists:nth(R, M))).