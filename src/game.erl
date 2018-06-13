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
-export([start/0,  register_players/0]).
%-record(player, {pid, name}).


start() ->
  BoardServerPID = spawn(fun() -> boardServer:start_link() end),
  AnswersServerPID = spawn(fun() -> answersServer:start_link() end),
  register(regProc, spawn(fun() -> game:register_players() end)),
  ok.







broadcast_puzzle(Rebus, Players) ->
  if length(Players) == 0 -> ok;
    true ->
      [PID | Rest] = Players,
      PID ! {give_answer, Rebus, self()},
      broadcast_puzzle(Rebus, Rest)
  end.


collect_answers(Rebus) ->
  answersServer:add_rebus(Rebus),
  broadcast_puzzle(Rebus, boardServer:get_clients_pids()),
  collect(Rebus).

collect(Rebus) ->   % Answers: key = Answer , Val = Pid
  receive
    stop -> ok;
    {answer, Answer, Pid} ->
      answersServer:add_answer(Rebus, Answer, Pid),
      collect_answers(Rebus)
  end.





collect_choices(Rebus) ->1.

