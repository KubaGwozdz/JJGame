%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. cze 2018 22:23
%%%-------------------------------------------------------------------
-module(leaderBoardApp).
-author("kuba").
-include_lib("wx/include/wx.hrl").

%% API
-export([start/0]).

start ()->
  Wx = wx:new(),
  Frame = wxFrame:new(Wx, -1, "Rebus Game", [{size, {500, 500}}]),
  Panel = wxPanel:new(Frame),
  wxFrame:setMinSize(Frame,{500,500}),

  Sizer = wxBoxSizer:new(?wxVERTICAL),

  wxPanel:setBackgroundColour(Panel,?wxWHITE),

  Button1 = wxButton:new(Panel,1,[{label,"PLAY 1 TURN"},{size,{100,20}}]),
  Button2 = wxButton:new(Panel,2,[{label,"PLAY 5 TURNS"},{size,{100,20}}]),
  Button3 = wxButton:new(Panel,3,[{label,"PLAY 10 TURNS"},{size,{100,20}}]),
  Texts = [wxStaticText:new(Panel,0,"",[]),wxStaticText:new(Panel,11,"Welcome to Rebus Game",[{style,?wxALIGN_CENTER},{size,{50,50}}]),
    wxStaticText:new(Panel,12,"Choose numer of turns to play",[{style,?wxALIGN_CENTER},{size,{50,50}}])],
  Font = wxFont:new(30,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  wxStaticText:setFont(lists:nth(2,Texts),Font),
  Font2 = wxFont:new(20,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_LIGHT),
  wxStaticText:setFont(lists:nth(3,Texts),Font2),
  Logo = wxImage:new("logo.jpg"),
  Bitmap = wxBitmap:new(wxImage:scale(Logo,round(wxImage:getWidth(Logo)*1.5), round(wxImage:getHeight(Logo)*1.5),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),
  StaticBitmap = wxStaticBitmap:new(Panel,1,Bitmap),

  [wxSizer:add(Sizer,Text,[{flag,?wxEXPAND bor ?wxALIGN_CENTER},{proportion,1},{border,10}]) || Text <- Texts],
  wxSizer:add(Sizer,StaticBitmap,[{flag,?wxEXPAND bor ?wxALL},{proportion,1}]),
  wxSizer:add(Sizer,Button1,[{flag,?wxEXPAND bor ?wxALL},{proportion,1},{flag,?wxALIGN_CENTER},{border,30}]),
  wxSizer:add(Sizer,Button2,[{flag,?wxEXPAND bor ?wxALL},{proportion,1},{flag,?wxALIGN_CENTER},{border,30}]),
  wxSizer:add(Sizer,Button3,[{flag,?wxEXPAND bor ?wxALL},{proportion,1},{flag,?wxALIGN_CENTER},{border,30}]),

  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),

  wxFrame:connect(Panel, close_window),
  wxFrame:center(Frame),
  wxFrame:fit(Frame),
  wxFrame:show(Frame).