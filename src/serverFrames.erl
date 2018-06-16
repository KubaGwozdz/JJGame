%%%-------------------------------------------------------------------
%%% @author Julianek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. cze 2018 21:27
%%%-------------------------------------------------------------------
-module(serverFrames).
-author("Julianek").
-include_lib("wx/include/wx.hrl").

%% API
-export([initFrame/0,registeredPlayers/2,rebusAnswer/2,leaderBoard/1,rebusDisplay/2]).

initFrame()->
  Parent = wx:new(),
  Frame = wxFrame:new(Parent, -1, "Rebus Game", [{size, {500, 500}}]),
  Panel = wxPanel:new(Frame),
  wxFrame:setMinSize(Frame,{500,500}),
  Sizer = wxBoxSizer:new(?wxVERTICAL),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),

  Button1 = wxButton:new(Panel,1,[{label,"PLAY 1 TURN"},{size,{450,30}}]),
  Button2 = wxButton:new(Panel,2,[{label,"PLAY 5 TURNS"},{size,{450,30}}]),
  Button3 = wxButton:new(Panel,3,[{label,"PLAY 10 TURNS"},{size,{450,30}}]),

  Texts = [wxStaticText:new(Panel,0,"",[]),wxStaticText:new(Panel,11,"Welcome to Rebus Game",[{style,?wxALIGN_CENTER},{size,{50,50}}]),
    wxStaticText:new(Panel,12,"Choose numer of turns to play",[{style,?wxALIGN_CENTER},{size,{50,50}}])],
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
  wxSizer:add(Sizer,Button1,[{flag,?wxALIGN_CENTER},{proportion,1},{border,20}]),
  wxSizer:add(Sizer,Button2,[{flag,?wxALIGN_CENTER},{proportion,1},{border,20}]),
  wxSizer:add(Sizer,Button3,[{flag,?wxALIGN_CENTER},{proportion,1},{border,20}]),

  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxFrame:connect(Panel, close_window),
  wxPanel:connect(Panel,command_button_clicked),
  wxFrame:center(Frame),
  wxFrame:fit(Frame),
  wxFrame:show(Frame),
  {Frame,Panel}.

registeredPlayers(Frame,Turns) ->
  Panel = wxPanel:new(Frame),
  Sizer = wxBoxSizer:new(?wxVERTICAL),
  ButtonSizer = wxBoxSizer:new(?wxHORIZONTAL),
  ImageSizer = wxBoxSizer:new(?wxVERTICAL),
  NameSizer = wxBoxSizer:new(?wxVERTICAL),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),

  Button1 = wxButton:new(Panel,4,[{label,"PLAY"},{size,{100,30}}]),
  Button2 = wxButton:new(Panel,5,[{label,"EXIT"},{size,{100,30}}]),

  ListOfPlayers = boardServer:get_clients_names(),
  Players = [wxStaticText:new(Panel,0,P,[{style,?wxALIGN_CENTER},{size,{-1,-1}}]) || P <- ListOfPlayers],
  Text = wxStaticText:new(Panel,1,"Registered clients",[{style,?wxALIGN_CENTER},{size,{150,50}}]),
  Font1 = wxFont:new(20,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_LIGHT),
  [wxStaticText:setFont(Name,Font1) || Name <- Players],
  Font2 = wxFont:new(29,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  wxStaticText:setFont(Text,Font2),
  Logo = wxImage:new("logo.jpg"),
  Bitmap = wxBitmap:new(wxImage:scale(Logo,round(wxImage:getWidth(Logo)), round(wxImage:getHeight(Logo)),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),
  StaticBitmap = wxStaticBitmap:new(Panel,4,Bitmap),

  wxSizer:addSpacer(Sizer,80),
  wxSizer:add(Sizer,Text,[{flag,?wxEXPAND bor ?wxALIGN_CENTER},{proportion,0}]),
  wxSizer:add(ImageSizer,StaticBitmap,[{flag,?wxALIGN_CENTER},{proportion,0}]),
  wxSizer:addSpacer(ImageSizer,60),
  wxSizer:add(ButtonSizer,Button1,[{flag,?wxALIGN_CENTER bor ?wxALL},{proportion,0},{border,20}]),
  wxSizer:add(ButtonSizer,Button2,[{flag,?wxALIGN_CENTER bor ?wxALL},{proportion,0},{border,20}]),
  wxSizer:addSpacer(ButtonSizer,30),
  [wxSizer:add(NameSizer,Player,[{flag,?wxEXPAND bor ?wxALIGN_CENTER},{proportion,1},{border,4}]) || Player <- Players],

  wxSizer:add(Sizer,ImageSizer,[{flag,?wxEXPAND}]),
  wxSizer:add(Sizer,ButtonSizer,[{flag,?wxALIGN_CENTER}]),
  wxSizer:add(Sizer,NameSizer,[{flag,?wxEXPAND}]),
  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxPanel:fit(Panel),
  wxFrame:connect(Frame, close_window),
  wxPanel:connect(Panel, command_button_clicked),
  wxFrame:fit(Frame),
  wxFrame:showFullScreen(Frame,true),
  wxFrame:show(Frame),
  {Frame,Panel,Turns}.

rebusDisplay(Frame,Turns) ->
  Panel = wxPanel:new(Frame),
  Sizer = wxBoxSizer:new(?wxVERTICAL),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),

  RebusNumber = integer_to_list(Turns),
  RebusName = RebusNumber ++ ".jpg",
  Rebus = wxImage:new(RebusName),
  Text = wxStaticText:new(Panel,0,"Write your answer",[{style,?wxALIGN_CENTER},{size,{-1,-1}}]),
  Font = wxFont:new(20,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_LIGHT),
  wxStaticText:setFont(Text,Font),
  Bitmap = wxBitmap:new(wxImage:scale(Rebus,round(wxImage:getWidth(Rebus))*1, round(wxImage:getHeight(Rebus)*1),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),
  StaticBitmap = wxStaticBitmap:new(Panel,4,Bitmap),
  Time = wxStaticText:new(Panel,0,"40",[{style,?wxALIGN_CENTER},{size,{-1,-1}}]),
  Font2 = wxFont:new(35,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  wxStaticText:setFont(Time,Font2),

  wxSizer:addSpacer(Sizer,100),
  wxSizer:add(Sizer,StaticBitmap,[{flag,?wxALIGN_CENTER},{proportion,0}]),
  wxSizer:addSpacer(Sizer,60),
  wxSizer:add(Sizer,Text,[{flag,?wxALIGN_CENTER},{proportion,1}]),
  wxSizer:addSpacer(Sizer,20),
  wxSizer:add(Sizer,Time,[{flag,?wxALIGN_CENTER},{proportion,1}]),

  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxPanel:fit(Panel),
  wxFrame:connect(Frame, close_window),
  wxFrame:fit(Frame),
  wxFrame:showFullScreen(Frame,true),
  wxFrame:show(Frame),
  {Frame,Panel,Turns,Time}.


rebusAnswer(Frame,Turns) ->
  Panel = wxPanel:new(Frame),
  Sizer = wxBoxSizer:new(?wxVERTICAL),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),

  RebusNumber = integer_to_list(Turns),
  RebusName = RebusNumber ++ ".jpg",
  Rebus = wxImage:new(RebusName),
  Text = wxStaticText:new(Panel,0,"Choose best answer",[{style,?wxALIGN_CENTER},{size,{-1,-1}}]),
  Font = wxFont:new(20,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_LIGHT),
  wxStaticText:setFont(Text,Font),
  Bitmap = wxBitmap:new(wxImage:scale(Rebus,round(wxImage:getWidth(Rebus))*1, round(wxImage:getHeight(Rebus)*1),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),
  StaticBitmap = wxStaticBitmap:new(Panel,4,Bitmap),
  Time = wxStaticText:new(Panel,0,"30",[{style,?wxALIGN_CENTER},{size,{-1,-1}}]),
  Font2 = wxFont:new(35,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  wxStaticText:setFont(Time,Font2),

  wxSizer:addSpacer(Sizer,100),
  wxSizer:add(Sizer,StaticBitmap,[{flag,?wxALIGN_CENTER},{proportion,0}]),
  wxSizer:addSpacer(Sizer,60),
  wxSizer:add(Sizer,Text,[{flag,?wxALIGN_CENTER},{proportion,1}]),
  wxSizer:addSpacer(Sizer,20),
  wxSizer:add(Sizer,Time,[{flag,?wxALIGN_CENTER},{proportion,1}]),

  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxPanel:fit(Panel),
  wxFrame:connect(Frame, close_window),
  wxFrame:fit(Frame),
  wxFrame:showFullScreen(Frame,true),
  wxFrame:show(Frame),
  {Frame,Panel,Turns,Time}.

leaderBoard(Frame) ->
  ok.
