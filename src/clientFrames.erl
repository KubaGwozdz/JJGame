%%%-------------------------------------------------------------------
%%% @author Julianek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. cze 2018 21:30
%%%-------------------------------------------------------------------
-module(clientFrames).
-author("Julianek").
-include_lib("wx/include/wx.hrl").

%% API
-export([show_register_frame/1, show_start_frame/1, show_waiting_frame/2]).

show_start_frame(Frame) ->
  Panel = wxPanel:new(Frame),
  wxFrame:setMinSize(Frame,{500,500}),
  Sizer = wxBoxSizer:new(?wxVERTICAL),

  wxPanel:setBackgroundColour(Panel,?wxWHITE),
  Texts = [wxStaticText:new(Panel,0,"",[]),wxStaticText:new(Panel,11,"Welcome to Rebus Game",[{style,?wxALIGN_CENTER},{size,{50,50}}]),
    wxStaticText:new(Panel,12,"Client controller",[{style,?wxALIGN_CENTER},{size,{50,50}}])],
  Font = wxFont:new(30,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  wxStaticText:setFont(lists:nth(2,Texts),Font),
  Font2 = wxFont:new(20,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_LIGHT),
  wxStaticText:setFont(lists:nth(3,Texts),Font2),
  Logo = wxImage:new("logo.jpg"),
  Bitmap = wxBitmap:new(wxImage:scale(Logo,round(wxImage:getWidth(Logo)*1.5), round(wxImage:getHeight(Logo)*1.5),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),
  StaticBitmap = wxStaticBitmap:new(Panel,4,Bitmap),

  [wxSizer:add(Sizer,Text,[{flag,?wxEXPAND bor ?wxALIGN_CENTER},{proportion,1},{border,10}]) || Text <- Texts],
  wxSizer:add(Sizer,StaticBitmap,[{flag,?wxALIGN_CENTER},{proportion,1}]),

  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxFrame:connect(Panel, close_window),
  wxFrame:center(Frame),
  wxFrame:fit(Frame),
  wxFrame:show(Frame).

show_register_frame(Frame) -> % when got Name do sth from clientApp
  Panel = wxPanel:new(Frame),
  wxFrame:setMinSize(Frame,{500,500}),
  Sizer = wxBoxSizer:new(?wxVERTICAL),

  wxPanel:setBackgroundColour(Panel,?wxWHITE),

  Texts = [wxStaticText:new(Panel,0,"",[]),wxStaticText:new(Panel,11,"Registration:",[{style,?wxALIGN_CENTER},{size,{50,50}}])],
  Font = wxFont:new(30,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  wxStaticText:setFont(lists:nth(2,Texts),Font),

  Logo = wxImage:new("logo.jpg"),

  Bitmap = wxBitmap:new(wxImage:scale(Logo,round(wxImage:getWidth(Logo)*1.5), round(wxImage:getHeight(Logo)*1.5),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),

  StaticBitmap = wxStaticBitmap:new(Panel,4,Bitmap),

  TextCtrl  = wxTextCtrl:new(Panel, 1001, [ {value, "Enter your name"},{style, ?wxTE_CENTRE}, {style, ?wxTE_PROCESS_ENTER}, {size, {200,25}}]),

  Button = wxButton:new(Panel,12,[{label,"Register"},{size,{200,25}}]),


  [wxSizer:add(Sizer,Text,[{flag,?wxALIGN_CENTER bor ?wxEXPAND},{proportion,1},{border,20}]) || Text <- Texts],
  wxSizer:add(Sizer,StaticBitmap,[{flag,?wxALIGN_CENTER},{proportion,1}]),
  wxSizer:add(Sizer,TextCtrl,[{flag,?wxALIGN_CENTER},{border,20}]),
  wxSizer:addSpacer(Sizer, 20),
  wxSizer:add(Sizer,Button,[{flag,?wxALIGN_CENTER},{border,20}]),

  wxSizer:addSpacer(Sizer, 120),

  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxFrame:center(Frame),
  wxFrame:fit(Frame),
  wxFrame:show(Frame),

  wxFrame:connect( Frame, close_window),
  wxPanel:connect(Panel, command_button_clicked),

  register_loop({Frame, TextCtrl}).

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
      show_waiting_frame(Frame, Name)

  end.



show_waiting_frame(Frame, Name) ->
  Panel = wxPanel:new(Frame),
  wxFrame:setMinSize(Frame,{500,500}),
  Sizer = wxBoxSizer:new(?wxVERTICAL),

  wxPanel:setBackgroundColour(Panel,?wxWHITE),

  Texts = [wxStaticText:new(Panel,0,"",[]),wxStaticText:new(Panel,11,"Waiting for others...",[{style,?wxALIGN_CENTER},{size,{50,50}}])],
  NameL = [wxStaticText:new(Panel,0,"",[]),wxStaticText:new(Panel,11,Name,[{style,?wxALIGN_CENTER},{size,{50,50}}])],
  Font = wxFont:new(30,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  Font2 = wxFont:new(20,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_LIGHT),
  wxStaticText:setFont(lists:nth(2,NameL),Font),
  wxStaticText:setFont(lists:nth(2,Texts),Font2),

  Logo = wxImage:new("logo.jpg"),

  Bitmap = wxBitmap:new(wxImage:scale(Logo,round(wxImage:getWidth(Logo)*1.5), round(wxImage:getHeight(Logo)*1.5),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),

  StaticBitmap = wxStaticBitmap:new(Panel,4,Bitmap),


  [wxSizer:add(Sizer,Text,[{flag,?wxALIGN_CENTER bor ?wxEXPAND},{proportion,1},{border,20}]) || Text <- Texts],
  [wxSizer:add(Sizer,N,[{flag,?wxALIGN_CENTER bor ?wxEXPAND},{proportion,1},{border,20}]) || N <- NameL],
  wxSizer:addSpacer(Sizer, 20),

  wxSizer:add(Sizer,StaticBitmap,[{flag,?wxALIGN_CENTER},{proportion,1}]),

  wxSizer:addSpacer(Sizer, 120),

  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxFrame:center(Frame),
  wxFrame:fit(Frame),
  wxFrame:show(Frame),

  wxFrame:connect( Frame, close_window),

  receive
  % a connection get the close_window signal
  % and sends this message to the server
    #wx{event=#wxClose{}} ->
      io:format("~p Closing window ~n",[self()]), %optional, goes to shell
      %now we use the reference to Frame
      wxWindow:destroy(Frame),  %closes the window
      ok;  % we exit the loop
    {give_answer, Rebus} -> Rebus
  end.


