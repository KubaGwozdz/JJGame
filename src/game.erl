%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. cze 2018 17:12
%%%-------------------------------------------------------------------
-module(game).
-author("kuba").

%% API
-export([start/0,  register_players/0, register/1, collect_answers/1, collect_choices/1, broadcast_clients/3]).
%-record(player, {pid, name}).


start() ->
  BoardServerPID = spawn(fun() -> boardServer:start_link() end),
  AnswersServerPID = spawn(fun() -> answersServer:start_link() end),
  register_players(),
  ok.

register_players() ->
  Players = boardServer:get_clients_pids(),
  register(Players).

register(Players) ->    % broadcasts clients registration mode
  if length(Players) == 0 -> ok;
    true ->
      [Player | Others ] = Players,
      Player ! register,
      register(Others)
  end.


collect_answers(Rebus) ->
  answersServer:add_rebus(Rebus),
  broadcast_clients(Rebus, boardServer:get_clients_pids(), give_answer).

collect_choices(Rebus) ->
  broadcast_clients(Rebus, boardServer:get_clients_pids(), choose).


broadcast_clients(Rebus, Players, Msg) ->
  if length(Players) == 0 -> ok;
    true ->
      [PID | Rest] = Players,
      PID ! {Msg, Rebus},
      broadcast_clients(Rebus, Rest, Msg)
  end.




