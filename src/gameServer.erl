%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. cze 2018 17:12
%%%-------------------------------------------------------------------
-module(gameServer).
-author("kuba").

%% API
-export([start/0, server_loop/2, send_rebus/2]).


start() ->
  BoardServerPID = spawn(boardServer:start_link()),
  CollectChoicesPID = spawn(?MODULE:collect_choices()),
  receive
    {lets_play} ->
      N = boardServer:get_clients_pid(),
      server_loop(N,1)
  end.

server_loop(Players, Rebus, Score) ->
  send_rebus(Players, Rebus).


collect_choices(Time)-> 3.

send_rebus(Remaining, Rebus) ->
  if length(Remaining) /= 0->
    [PID | Rest] = Remaining,
    PID ! {give_answer, Rebus, self()},
    send_rebus(Rest, Remaining);
    true -> ok
  end.

