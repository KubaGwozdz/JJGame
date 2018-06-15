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
-export([loop/1,start/0,gameLoop/2]).

start() ->
  spawn(fun() -> game:start() end),
  State = serverFrames:initFrame(),
  loop(State).

loop(State) ->
  {Frame,Panel} = State,
  receive
    #wx{event = #wxClose{}} -> wxWindow:destroy(Frame), ok;
    #wx{id = 1, event = #wxCommand{type = command_button_clicked}} ->
      game:register_players(),
      wxPanel:destroy(Panel),
      {Frame2,Panel2,Turns} = serverFrames:registeredPlayers(Frame,1),
      loop({Frame2,Panel2});
    #wx{id = 2, event = #wxCommand{type = command_button_clicked}} ->
      game:register_players(),
      wxPanel:destroy(Panel),
      {Frame2,Panel2,Turns} = serverFrames:registeredPlayers(Frame,5),
      loop({Frame2,Panel2});
    #wx{id = 3, event = #wxCommand{type = command_button_clicked}} ->
      game:register_players(),
      wxPanel:destroy(Panel),
      {Frame2,Panel2,Turns} = serverFrames:registeredPlayers(Frame,10),
      loop({Frame2,Panel2});
    #wx{id = 4, event = #wxCommand{type = command_button_clicked}} ->
      wxPanel:destroy(Panel),
      gameLoop(Frame,1);
    #wx{id = 5, event = #wxCommand{type = command_button_clicked}} ->
      wxFrame:destroy(Frame)
  end.

gameLoop(Frame,Turns) ->
  Turns.
