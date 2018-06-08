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
-export([start/1, server_loop/3,send_rebus/2, register_players/1]).
-record(player, {pid, name}).


start(Turns) ->
  BoardServerPID = spawn(fun() -> boardServer:start_link() end),
  Players = register_players([]),
  Players.



register_players(Players) ->
  receive
    play -> Players;
    {register, PID, Name} ->
      lists:append([#player{pid = PID, name = Name}], Players),
      boardServer:register_client(PID, Name),
      register_players(Players)
  end.




server_loop(Players, Rebus, Score) -> 3.



collect_choices(Time)-> 3.

send_rebus(Remaining, Rebus) ->
  if length(Remaining) /= 0->
    [PID | Rest] = Remaining,
    PID ! {give_answer, Rebus, self()},
    send_rebus(Rest, Remaining);
    true -> ok
  end.

