-module(khf2).
-author('email@unit.org.hu').
-vsn('year-mm-dd').
%-export([ertekek/2]).
-compile(export_all).

-type sspec() :: {size(), board()}.
-type size()  :: integer().
-type field() :: [info()].
-type info()  :: e | o | s | w | integer().
-type board() :: [[field()]].

-type ssol() :: [[integer()]].
-type col() :: integer().
-type row() :: integer().
-type coords() :: {row(),col()}.
-spec khf2:ertekek(SSpec :: sspec(), R_C :: coords()) -> Vals :: [integer()].
%% Egy érték pontosan akkor szerepel a Vals listában, ha teljesíti a
%% fenti Prolog specifikációban felsorolt (a), (b) és (c) feltételeket, ahol
%% Vals az SSpec specifikációval megadott Sudoku-feladvány R_C
%% koordinátájú mezőjében megengedett értékek listája.