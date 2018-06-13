%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. cze 2018 20:59
%%%-------------------------------------------------------------------
-module(answersServer_test).
-author("kuba").

%% API
-export([]).
-include_lib("eunit/include/eunit.hrl").


%test:

get_answers_test() ->
  answersServer:start_link(),
  answersServer:add_rebus(1),
  answersServer:add_rebus(1),
  answersServer:add_rebus(2),
  answersServer:add_rebus(3),
  answersServer:add_answer(1,"Julianek", 12),
  answersServer:add_answer(1,"Bubus", 13),
  [?assertEqual(answersServer:get_answers(),#{1 =>
  [{answer,"Bubus",13,0},
    {answer,"Julianek",12,0}],
    2 => [],3 => []})].

add_point_test() ->
  answersServer:add_point(1,"Bubus"),
  answersServer:add_point(1,"Bubus"),
  answersServer:add_point(1,"Bubus"),
  answersServer:add_point(1,"Julianek"),
  [?assertEqual(answersServer:get_answers(),#{1 =>
  [{answer,"Julianek",12,1},{answer,"Bubus",13,3}],
    2 => [],3 => []})].

get_rebus_answers_test() ->
  [?assertEqual(answersServer:get_rebus_answers(1),[{answer,"Julianek",12,1},{answer,"Bubus",13,3}])].