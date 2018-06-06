%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. cze 2018 18:09
%%%-------------------------------------------------------------------
-module(client).
-author("kuba").

%% API
-export([get_leaderboard/0]).

register() ->
  boardServer:register_client(self()).

get_leaderboard() ->
  boardServer:get_leaderboard().

