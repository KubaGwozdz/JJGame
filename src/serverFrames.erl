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
-export([initFrame/1,registeredPlayers/2]).

initFrame(Parent)->
  Frame = wxFrame:new(Parent, -1, "Rebus Game", [{size, {500, 500}}]),
  Panel = wxPanel:new(Frame),
  wxFrame:setMinSize(Frame,{500,500}),
  Sizer = wxBoxSizer:new(?wxVERTICAL),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),

  Button1 = wxButton:new(Panel,1,[{label,"PLAY 1 TURN"},{size,{450,30}}]),
  wxButton:connect(Button1,command_button_clicked,[{callback,
    fun(Evt, Obj) ->
      wxPanel:destroy(Panel),
      registeredPlayers(Frame,1)
    end
  }]),
  Button2 = wxButton:new(Panel,2,[{label,"PLAY 5 TURNS"},{size,{450,30}}]),
  wxButton:connect(Button2,command_button_clicked,[{callback,
    fun(Evt, Obj) ->
      wxPanel:destroy(Panel),
      registeredPlayers(Frame,5)
    end
  }]),
  Button3 = wxButton:new(Panel,3,[{label,"PLAY 10 TURNS"},{size,{450,30}}]),
  wxButton:connect(Button3,command_button_clicked,[{callback,
    fun(Evt, Obj) ->
      wxPanel:destroy(Panel),
      registeredPlayers(Frame,10)
    end
  }]),
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
  wxFrame:center(Frame),
  wxFrame:fit(Frame),
  wxFrame:show(Frame).



registeredPlayers(Frame,Turns) ->
  wxFrame:layout(Frame),
  Size = wxFrame:getClientSize(Frame),
  Panel = wxPanel:new(Frame,[{size,Size}]),
  Sizer = wxBoxSizer:new(?wxVERTICAL),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),

  Button1 = wxButton:new(Panel,1,[{label,"PLAY"},{size,{200,30}}]),
  wxButton:connect(Button1,command_button_clicked,[{callback,
    fun(Evt, Obj) ->
      wxPanel:destroy(Panel),
      serverApp:gameLoop(Frame,Turns)
    end
  }]),
  Texts = [wxStaticText:new(Panel,0,"",[]),
    wxStaticText:new(Panel,1,"Registered clients",[{style,?wxALIGN_CENTER},{size,{-1,-1}}])],
  Font1 = wxFont:new(10,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_LIGHT),
  wxStaticText:setFont(lists:nth(1,Texts),Font1),
  Font2 = wxFont:new(25,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  wxStaticText:setFont(lists:nth(2,Texts),Font2),
  Logo = wxImage:new("logo.jpg"),
  Bitmap = wxBitmap:new(wxImage:scale(Logo,round(wxImage:getWidth(Logo)), round(wxImage:getHeight(Logo)),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),
  StaticBitmap = wxStaticBitmap:new(Panel,4,Bitmap),

  [wxSizer:add(Sizer,Text,[{flag,?wxEXPAND bor ?wxALIGN_CENTER},{proportion,1},{border,10}]) || Text <- Texts],
  wxSizer:add(Sizer,StaticBitmap,[{flag,?wxALIGN_CENTER},{proportion,1}]),
  wxSizer:add(Sizer,Button1,[{flag,?wxALIGN_CENTER},{proportion,1},{border,20}]),

  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxFrame:connect(Panel, close_window),
  wxFrame:fit(Frame),
  wxFrame:show(Frame).