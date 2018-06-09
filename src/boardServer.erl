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
-export([get_leaderboard/0, get_number_of_players/0, get_clients/0, get_clients_pids/0,
  register_client/2, delete_client/1, add_client_point/1]).
-export([create_leaderboard/0]).

-record(leaderBoard, {board}).
-record(player,{name, points}).

start_link() ->
  gen_server:start_link({global, ?MODULE}, ?MODULE, [],[]).



init(Leaderboard) -> {ok,create_leaderboard()}.



%% CLIENT INTERFACE
get_leaderboard() ->
  gen_server:call({global, boardServer}, {get_leaderboard}).

get_number_of_players() ->
  gen_server:call({global, boardServer}, {get_number_of_players}).

get_clients() ->
  gen_server:call({global, boardServer}, {get_clients}).

get_clients_pids() ->
  gen_server:call({global, boardServer}, {get_clients_pids}).

register_client(PID, Name) ->
  gen_server:call({global, boardServer}, {register_client, PID, Name}).

delete_client(PID) ->
  gen_server:cast({global, boardServer}, {delete_client, PID}).

add_client_point(PID) ->
  gen_server:call({global, boardServer}, {add_client_point, PID}).




%% CALLBACKS

handle_call({get_leaderboard}, _From, Leaderboard) -> {reply, Leaderboard, Leaderboard};

handle_call({get_number_of_players}, _From, Leaderboard) ->
  L1 = Leaderboard#leaderBoard.board,
  Players = maps:keys(L1),
  {reply, length(Players), Leaderboard};

handle_call({get_clients}, _From, Leaderboard) ->
  L1 = Leaderboard#leaderBoard.board,
  Players = maps:to_list(L1),
  {reply, Players, Leaderboard};

handle_call({get_clients_pids}, _From, Leaderboard) ->
  L1 = Leaderboard#leaderBoard.board,
  PlayerPids = maps:keys(L1),
  {reply, PlayerPids, Leaderboard};

handle_call({register_client, PID, Name}, _From, Leaderboard) ->
  L1 = Leaderboard#leaderBoard.board,
  Players = maps:keys(L1),
  N = maps:values(L1),
  Names = lists:map(fun(#player{name=X}) -> X end, N),
  AlreadyRegisterdPID = lists:any(fun (X) -> X == PID end, Players),
  AlreadyRegisterdName = lists:any(fun (X) -> X == Name end, Names),
  if ((AlreadyRegisterdPID /= true) and (AlreadyRegisterdName /= true)) ->
    L2  = maps:put(PID, #player{name = Name, points = 0}, L1),
    L3 = #leaderBoard{board = L2},
    {reply, ok, L3};
    true -> {reply, allreadyRegistered, Leaderboard}
  end;

handle_call({add_client_point, PID}, _From, Leaderboard) ->
  Board = Leaderboard#leaderBoard.board,
  Status = maps:find(PID,Board),
  if Status /= error ->
    {_,#player{points = Points, name = Name}} = maps:find(PID,Board),
    NewB = maps:update(PID, #player{points = Points+1, name = Name},Board),
  {reply, ok, #leaderBoard{board = NewB}};
    true ->   {reply, 'Client doesn not exist', Leaderboard}
  end.


handle_cast({delete_client, PID}, _From, Leaderboard) ->
  L1 = Leaderboard#leaderBoard.board,
  L2 = maps:remove(PID,L1),
  {noreply, #leaderBoard{board= L2}}.



%% FUNCTIONS

create_leaderboard() ->
  Board = maps:new(),   % key: PID val: player
  Leaderboard = #leaderBoard{board = Board},
  Leaderboard.
