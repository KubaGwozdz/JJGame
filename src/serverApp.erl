%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. cze 2018 22:23
%%%-------------------------------------------------------------------
-module(serverApp).
-author("kuba").
-include_lib("wx/include/wx.hrl").
%% API
-export([init/1,start/0,gameLoop/2]).

start() ->
  Parent = wx:new(),
  init({Parent,gameStart}).

init({Parent,State}) ->
  case State of
    turnsPlay -> serverFrames:initFrame(Parent);
    registration -> serverFrames:registeredPlayers(Parent);
  end.

gameLoop(Frame,Turns) ->
  Turns.
  %%game:start(),

