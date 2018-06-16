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
-export([loop/1,start/0,gameLoop/3]).

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
      registerLoop({Frame2,Panel2,Turns});
    #wx{id = 2, event = #wxCommand{type = command_button_clicked}} ->
      game:register_players(),
      wxPanel:destroy(Panel),
      {Frame2,Panel2,Turns} = serverFrames:registeredPlayers(Frame,5),
      registerLoop({Frame2,Panel2,Turns});
    #wx{id = 3, event = #wxCommand{type = command_button_clicked}} ->
      game:register_players(),
      wxPanel:destroy(Panel),
      {Frame2,Panel2,Turns} = serverFrames:registeredPlayers(Frame,10),
      registerLoop({Frame2,Panel2,Turns})
  end.

registerLoop(State) ->
  {Frame,Panel,Turns} = State,
  receive
    #wx{id = 4, event = #wxCommand{type = command_button_clicked}} ->
      game:collect_answers(Turns),
      wxPanel:destroy(Panel),
      gameLoop(Frame,Turns,40000);
    #wx{id = 5, event = #wxCommand{type = command_button_clicked}} ->
      wxFrame:destroy(Frame),
      ok
  after
    3000 ->
      wxPanel:destroy(Panel),
      {Frame2,Panel2,Turns2} = serverFrames:registeredPlayers(Frame,Turns),
      registerLoop({Frame2,Panel2,Turns2})
  end.

gameLoop(Frame,Turns,Counter) ->
  {Frame2,Panel,Turns2} = serverFrames:rebusDisplay(Frame,Turns),
  ok.