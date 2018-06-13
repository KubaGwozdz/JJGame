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
-export([register/2]).
-export([send_answer/3, send_choice/2, get_my_points/1]).


register(PID, Name) ->
      boardServer:register_client(PID, Name).

send_answer(Rebus, Answer,  PID) ->
  answersServer:add_answer(Rebus, Answer, PID).

send_choice(Rebus, Answer) ->
  answersServer:add_point(Rebus, Answer).

get_my_points(PID) ->
  boardServer:get_clients_points(PID).





