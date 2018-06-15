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
-export([start/0]).

start() ->
  Parent = wx:new(),
  Frame = wxFrame:new(Parent, -1, "Rebus Game", [{size, {500, 500}}]),
  clientFrames:show_start_frame(Frame),
  boardServer:add_client(self()),   %ważne dziobo
  receive
    register -> clientFrames:show_register_frame(Frame)
  end.

waitin_for_game(Name, Frame) ->
  client:register(self(), Name),
  clientFrames:show_waiting_frame(Frame).


