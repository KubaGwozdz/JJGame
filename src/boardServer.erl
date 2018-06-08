%%%-------------------------------------------------------------------
%%% @author JJ
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. cze 2018 16:06
%%%-------------------------------------------------------------------
-module(boardServer).
-author("JJ").
-behaviour(gen_server).


%% API
-export([start_link/0, init/1]).
-export([handle_call/3, handle_cast/3]).
-export([get_leaderboard/0, register_client/1, delete_client/1, add_client_point/1]).
-export([create_leaderboard/0]).

-record(leaderBoard, {board}).

start_link() ->
  gen_server:start_link({global, ?MODULE}, ?MODULE, [],[]).



init(Leaderboard) -> {ok,create_leaderboard()}.



%% CLIENT INTERFACE
get_leaderboard() ->
  gen_server:call({global, boardServer}, {get_leaderboard}).

register_client(PID) ->
  gen_server:call({global, boardServer}, {register_client, PID}).

delete_client(PID) ->
  gen_server:cast({global, boardServer}, {delete_client, PID}).

add_client_point(PID) ->
  gen_server:call({global, boardServer}, {add_client_point, PID}).



%% CALLBACKS

handle_call({get_leaderboard}, _From, Leaderboard) -> {reply, Leaderboard, Leaderboard};

handle_call({register_client, PID}, _From, Leaderboard) ->
  L1 = Leaderboard#leaderBoard.board,
  Players = maps:keys(L1),
  AlreadyRegisterd = lists:any(fun (X) -> X== PID end, Players),
  if AlreadyRegisterd /= true ->
    L2  = maps:put(PID, 0, L1),
    L3 = #leaderBoard{board = L2},
    {reply, ok, L3};
    true -> {reply, allreadyRegistered, Leaderboard}
  end;

handle_call({add_client_point, PID}, _From, Leaderboard) ->
  Board = Leaderboard#leaderBoard.board,
  {Status, Points} = maps:find(PID,Board),
  if Status == ok ->
    NewB = Board#{PID => (Points+1)},
  {reply, ok, #leaderBoard{board = NewB}};
    true ->   {reply, 'Client doesn not exist', Leaderboard}
  end.


handle_cast({delete_client, PID}, _From, Leaderboard) ->
  L1 = Leaderboard#leaderBoard.board,
  L2 = maps:remove(PID,L1),
  {noreply, #leaderBoard{board= L2}}.



%% FUNCTIONS

create_leaderboard() ->
  Board = maps:new(),   % key: PID val: SCORE
  Leaderboard = #leaderBoard{board = Board},
  Leaderboard.
