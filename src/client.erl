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

register(PID, Name) ->
      boardServer:register_client(PID, Name).

send_answer(Rebus, Answer,  PID) ->
  answersServer:add_answer(Rebus, Answer, PID).




