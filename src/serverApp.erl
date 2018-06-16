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
-export([loop/1,start/0,rebusDisplayLoop/5,rebusAnswerLoop/5]).

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
      {Frame2,Panel2,Turns2,Time} = serverFrames:rebusDisplay(Frame,Turns),
      game:collect_answers(Turns),
      rebusDisplayLoop(Frame,Panel2,Turns,40,Time);
    #wx{id = 5, event = #wxCommand{type = command_button_clicked}} ->
      wxFrame:destroy(Frame),
      ok
  after
    3000 ->
      wxPanel:destroy(Panel),
      {Frame2,Panel2,Turns2} = serverFrames:registeredPlayers(Frame,Turns),
      registerLoop({Frame2,Panel2,Turns2})
  end.

rebusDisplayLoop(Frame,Panel,Turns,Counter,Time) ->
  receive
    #wx{event = #wxClose{}} -> wxWindow:destroy(Frame), ok
  after
    1000 ->
      if
        Counter == 0 ->
          wxPanel:destroy(Panel),
          game:collect_choices(Turns),
          {Frame2,Panel2,Turns2,Time2} = serverFrames:rebusAnswer(Frame,Turns),
          rebusAnswerLoop(Frame2,Panel2,Turns,30,Time2);
        true ->
          NewCounter = Counter - 1,
          Seconds = integer_to_list(NewCounter),
          wxStaticText:setLabel(Time,Seconds),
          rebusDisplayLoop(Frame,Panel,Turns,NewCounter,Time)
        end
  end.

rebusAnswerLoop(Frame,Panel,Turns,Counter,Time) ->
  receive
    #wx{event = #wxClose{}} -> wxWindow:destroy(Frame), ok
  after
    1000 ->
      if
        Counter == 0 ->
          NextTurn = Turns - 1,
          wxPanel:destroy(Panel),
          if
            NextTurn == 0 ->
              serverFrames:leaderBoard(Frame);
            true ->
              if
                Turns /= 1 ->
                  {Frame3,Panel3} = serverFrames:correctAnswer(Frame,Turns),
                  timer:sleep(5000),
                  wxPanel:destroy(Panel3);
                true -> ok
              end,
              game:collect_answers(NextTurn),
              {Frame2,Panel2,Turns2,Time2} = serverFrames:rebusDisplay(Frame,NextTurn),
              rebusDisplayLoop(Frame,Panel2,NextTurn,40,Time2)
          end;
        true ->
              NewCounter = Counter - 1,
              Seconds = integer_to_list(NewCounter),
              wxStaticText:setLabel(Time,Seconds),
              rebusAnswerLoop(Frame,Panel,Turns,NewCounter,Time)
      end
  end.
