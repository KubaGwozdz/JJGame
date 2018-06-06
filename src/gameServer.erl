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
-export([start/0, server_loop/1]).

-record(player,{pid, name}).

start() ->
  BoardServerPID = spawn(boardServer:start_link()),
  Players = [],
  server_loop(Players).

server_loop(Players) ->
  receive
    {register_client, PID, Name} ->
      Status = boardServer:register_client(PID),
      if Status == ok ->
        P1 =lists:append([#player{pid = PID, name = Name}],Players),
        server_loop(P1);
      true -> server_loop(Players)
      end
  end.

