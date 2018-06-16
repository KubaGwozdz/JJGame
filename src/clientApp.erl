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
-export([start/0, register_loop/1, game_loop/3]).

start() ->
  Parent = wx:new(),
  Frame = wxFrame:new(Parent, -1, "Rebus Game", [{size, {500, 500}}]),
  Panel = clientFrames:show_start_frame(Frame),
  boardServer:add_client(self()),   %ważne dziobo
  receive
    register -> State = clientFrames:show_register_frame({Frame, Panel}),
      register_loop(State)
  end.


register_loop(State) ->
  {Frame, TextCtrl} = State,
  receive
  % a connection get the close_window signal
  % and sends this message to the server
    #wx{event=#wxClose{}} ->
      io:format("~p Closing window ~n",[self()]), %optional, goes to shell
      %now we use the reference to Frame
      wxWindow:destroy(Frame),  %closes the window
      ok;  % we exit the loop

    #wx{id = 12, event=#wxCommand{type = command_button_clicked}} ->
      %this message is sent when the Countdown button (ID 101) is clicked
      Name = wxTextCtrl:getValue(TextCtrl),
      boardServer:add_client(self()),
      client:register(self(), Name),
      clientFrames:show_waiting_frame(Frame, Name)
  end.

game_loop({Frame,Panel}, Name, Others) ->
  receive
  % a connection get the close_window signal
  % and sends this message to the server
    #wx{event=#wxClose{}} ->
      io:format("~p Closing window ~n",[self()]),
      wxWindow:destroy(Frame),
      ok;
    {give_answer, Rebus} ->
      clientFrames:show_give_answer_frame({Frame, Panel}, Rebus, Name);

    % give answer frame ok button
    #wx{id = 100, event=#wxCommand{type = command_button_clicked}} ->
      {TextCtrl, R} = Others,
      Answer = wxTextCtrl:getValue(TextCtrl),
      client:send_answer(R, Answer, self()),
      clientFrames:show_waiting_frame({Frame, Panel}, Name);

    {choose, Reb} ->
      clientFrames:show_choose_answer_frame({Frame, Panel},Reb, Name);

    % choose answer frame ok button
    #wx{id = 101, event=#wxCommand{type = command_button_clicked}} ->
      {R, AnswersBox, Answers} = Others,
      Result = wxListBox:getSelection(AnswersBox),
      Answr = lists:nth(Result+1, Answers),
      client:send_choice(R,Answr),
      clientFrames:show_your_points_frame({Frame, Panel},R, Name)

      %Answer = wxTextCtrl:getValue(TextCtrl),
      %client:send_answer(R, Answer, self()),
      %clientFrames:show_waiting_frame({Frame, Panel}, Name)
  end.





