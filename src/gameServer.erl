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
-export([start/1, play/0, register_players/1]).
-record(player, {pid, name}).


start(Turns) ->
  BoardServerPID = spawn(fun() -> boardServer:start_link() end),
  register_players([]).

play() -> self() ! play.

register_players(Players) ->
  receive
    play -> ok;
    {register, PID, Name} ->
      %lists:append([#player{pid = PID, name = Name}], Players),
      boardServer:register_client(PID, Name),
      register_players(Players)
  end.


broadcast_puzzle(Rebus, Players) ->
  if length(Players) == 0 -> ok;
    true ->
      [PID | Rest] = Players,
      PID ! Rebus,
      broadcast_puzzle(Rebus, Rest)
  end.



collect_answers(Answers) ->   % Answers: key = Answer , Val = Pid
  receive
    stop -> Answers;
    {answer, Answer, Pid} ->
      maps:put(Answer,Pid, Answers),
      collect_answers(Answers)
  end.


game_loop() ->  .













collect_choices(Time)-> 3.

send_rebus(Remaining, Rebus) ->
  if length(Remaining) /= 0->
    [PID | Rest] = Remaining,
    PID ! {give_answer, Rebus, self()},
    send_rebus(Rest, Remaining);
    true -> ok
  end.

