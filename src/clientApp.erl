%%%-------------------------------------------------------------------
%%% @author Julianek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. cze 2018 21:19
%%%-------------------------------------------------------------------
-module(clientApp).
-author("Julianek").
-include_lib("wx/include/wx.hrl").


%% API
-export([start/0,init/1]).

start() ->
  Parent = wx:new(),
  init({Parent,startingGame}).

init({Parent,State}) ->
  case State of
    startingGame -> Frame = clientFrames:show_start_frame(Parent), Parent = Frame;
    register -> clientFrames:registerYourself(Parent)
  end.
