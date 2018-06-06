%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. cze 2018 19:27
%%%-------------------------------------------------------------------
-module(boardServer_test).
-author("kuba").
-include_lib("eunit/include/eunit.hrl").

%% API
-export([]).

%test:

register_client_test() ->
  boardServer:start_link(),
  boardServer:register_client(1),
  boardServer:register_client(1),
  boardServer:register_client(2),
  [?assertEqual(boardServer:get_leaderboard(),{leaderBoard,#{1 => 0,2 => 0}})].

add_client_point_test() ->
  boardServer:start_link(),
  boardServer:register_client(1),
  boardServer:register_client(2),
  boardServer:add_client_point(1),
  boardServer:add_client_point(1),
  boardServer:add_client_point(1),
  boardServer:add_client_point(1),
  boardServer:add_client_point(2),
  boardServer:add_client_point(2),
  boardServer:add_client_point(2),
  boardServer:add_client_point(3),
  [?assertEqual(boardServer:get_leaderboard(),{leaderBoard,#{1 => 4,2 => 3}})].

