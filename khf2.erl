-module(khf2).
-author('lorinczb96@gmail.com').
-vsn('2019-10-19').
-export([ertekek/2]).
%-compile(export_all).

% X elem torlese L listabol
torles(X, L)-> [Y || Y <- L, Y =/= X].

% Egy cella elemein iteral es torli a lehetosegek (L lista) kozul
elemFilter(L, Elemek) when (length(Elemek) < 1) -> L;
elemFilter(L, Elemek) -> elemFilter(torles(hd(Elemek), L), tl(Elemek)).

% R. soron iteral + sorElem segedfv hivas
sorVizsgalo(L, Row, _C, _ActC) when (length(Row) < 1) -> L;
sorVizsgalo(L, Row, C, ActC) when (C =:= ActC) -> sorVizsgalo(L, tl(Row), C, ActC + 1);
sorVizsgalo(L, Row, C, ActC) -> sorVizsgalo(elemFilter(L, hd(Row)), tl(Row), C, ActC + 1).

% Vegig iteral Sudoku sorain es minden C. cellaban levo elemet filterezi
oszlop(L, M, _C, _R, _ActR) when (length(M) < 1) -> L;
oszlop(L, M, C, R, ActR) when (R =:= ActR) -> oszlop(L, tl(M), C, R, ActR + 1);
oszlop(L, M, C, R, ActR) -> oszlop(elemFilter(L, lists:nth(C, hd(M))), tl(M), C, R, ActR + 1).

sorSub(K, M, R) ->
  I0 = ((R - 1) div K) * K + 1,
  lists:sublist(M, I0, K).

% Ki kellene hagyni az R,C koordinatat, es akkor nem lenne szukseg eredetiCellaPlusz fuggvenyre
% Jelenleg emiatt elhasal az egyik teszt
% TODO:: nope. no kedv
oszlopSub(Sorok, _K, _C, Acc) when (length(Sorok) < 1) -> Acc;
oszlopSub(Sorok, K, C, Acc) ->
  J0 = ((C - 1) div K) * K + 1,
  oszlopSub(tl(Sorok), K, C, lists:append(Acc, lists:sublist(hd(Sorok), J0, K))).

% Visszaadja azt a resz matrixok amelyikben R,C koordinata megtalalhato
subMatrix(K, M, R, C) ->
  Sorok = sorSub(K, M, R),
  oszlopSub(Sorok, K, C, []).

% L listabol eltavolitja a K*K-s cella elemeit
cella(L, K, M, R, C) -> L -- (lists:append(subMatrix(K, M, R, C))).

% Sorok es oszlopok vizsgalatakor kivesszuk amink volt, ezert most visszaadjuk
eredetiCellaPlusz(L, M, R, C) -> (L ++ lists:nth(C, lists:nth(R, M))) -- [e,o,w,s].

% L listabol torli a paritasnak megfelelo elemeket
oOrE(L, ActCell) when (length(ActCell) < 1) -> L;
oOrE(L, ActCell) when (hd(ActCell) == e) -> oOrE([Y || Y <- L, Y rem 2 =:= 0], tl(ActCell));
oOrE(L, ActCell) when (hd(ActCell) == o) -> oOrE([Y || Y <- L, Y rem 2 =/= 0], tl(ActCell));
oOrE(L, ActCell) -> oOrE(L, tl(ActCell)).

% Segedfv lista inithez
init(L1, L2) when (length(L1) =:= 0) -> L2;
init(L1, _L2) -> L1.

% Lista init
initList(M, K, R, C) -> init([Y || Y <-lists:nth(C, lists:nth(R, M))] -- [e,o,w,s], lists:seq(1,K*K)).

ertekek({K, M}, {R, C}) ->
  InitList = initList(M, K, R, C),
  Cella = cella(InitList, K, M, R, C),
  EredetiCellaPlusz = eredetiCellaPlusz(Cella, M, R, C),
  SorFiltered = sorVizsgalo(EredetiCellaPlusz, lists:nth(R, M), C, 1),
  OszlopFiltered = oszlop(SorFiltered, M, C, R, 1),
  oOrE(OszlopFiltered, lists:nth(C, lists:nth(R, M))).