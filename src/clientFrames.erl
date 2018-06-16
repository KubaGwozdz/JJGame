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
-export([show_register_frame/1, show_start_frame/1, show_waiting_frame/2, show_give_answer_frame/3,show_choose_answer_frame/3]).

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

show_register_frame({Frame, P}) -> % when got Name do sth from clientApp
  wxPanel:destroy(P),
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

  {{Frame,Panel}, TextCtrl}.





show_waiting_frame({Frame, P}, Name) ->
  wxPanel:destroy(P),
  Panel = wxPanel:new(Frame),
  wxFrame:setMinSize(Frame,{500,500}),
  Sizer = wxBoxSizer:new(?wxVERTICAL),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),


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

  clientApp:game_loop({Frame,Panel}, Name,{}).



show_give_answer_frame({Frame,P}, Rebus, Name) ->
  wxPanel:destroy(P),
  Panel = wxPanel:new(Frame),
  wxFrame:setMinSize(Frame,{500,500}),
  Sizer = wxBoxSizer:new(?wxVERTICAL),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),


  Texts = [wxStaticText:new(Panel,0,"",[]),wxStaticText:new(Panel,11,"Your answer:",[{style,?wxALIGN_CENTER},{size,{50,50}}])],
  TextCtrl  = wxTextCtrl:new(Panel, 1001, [{style, ?wxTE_CENTRE}, {style, ?wxTE_PROCESS_ENTER}, {size, {200,25}}]),
  Button = wxButton:new(Panel,100,[{label,"ok"},{size,{200,25}}]),

  Logo = wxImage:new("logo.jpg"),
  Bitmap = wxBitmap:new(wxImage:scale(Logo,round(wxImage:getWidth(Logo)*1.5), round(wxImage:getHeight(Logo)*1.5),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),
  StaticBitmap = wxStaticBitmap:new(Panel,4,Bitmap),

  Font = wxFont:new(30,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  wxStaticText:setFont(lists:nth(2,Texts),Font),

  [wxSizer:add(Sizer,Text,[{flag,?wxALIGN_CENTER bor ?wxEXPAND},{proportion,1},{border,20}]) || Text <- Texts],
  wxSizer:add(Sizer,StaticBitmap,[{flag,?wxALIGN_CENTER},{proportion,1}]),
  wxSizer:addSpacer(Sizer, 80),
  wxSizer:add(Sizer,TextCtrl,[{flag,?wxALIGN_CENTER},{border,20}]),
  wxSizer:add(Sizer,Button,[{flag,?wxALIGN_CENTER},{border,20}]),
  wxSizer:addSpacer(Sizer, 120),


  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxFrame:center(Frame),
  wxFrame:fit(Frame),
  wxFrame:show(Frame),

  wxFrame:connect( Frame, close_window),
  wxPanel:connect(Panel, command_button_clicked),
  clientApp:game_loop({Frame,Panel}, Name, {TextCtrl, Rebus}).


show_choose_answer_frame({Frame,P}, Rebus, Name) ->
  wxPanel:destroy(P),
  Panel = wxPanel:new(Frame),
  wxFrame:setMinSize(Frame,{500,500}),
  Sizer = wxBoxSizer:new(?wxVERTICAL),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),


  Texts = [wxStaticText:new(Panel,0,"",[]),wxStaticText:new(Panel,11,"Choose answer:",[{style,?wxALIGN_CENTER},{size,{50,50}}])],
  Answers = answersServer:get_reb_answers_list(Rebus),


  Font = wxFont:new(30,?wxFONTFAMILY_MODERN,?wxFONTSTYLE_NORMAL,?wxFONTWEIGHT_BOLD),
  wxStaticText:setFont(lists:nth(2,Texts),Font),

  Button = wxButton:new(Panel,101,[{label,"ok"},{size,{200,25}}]),

  Logo = wxImage:new("logo.jpg"),
  Bitmap = wxBitmap:new(wxImage:scale(Logo,round(wxImage:getWidth(Logo)*1.5), round(wxImage:getHeight(Logo)*1.5),
    [{quality, ?wxIMAGE_QUALITY_HIGH}])),
  StaticBitmap = wxStaticBitmap:new(Panel,4,Bitmap),

  AnswersBox = wxListBox:new(Panel, 1010, [{size, {360,120}},
    {choices, Answers},
    {style, ?wxLB_SINGLE}]),


  [wxSizer:add(Sizer,Text,[{flag,?wxALIGN_CENTER bor ?wxEXPAND},{proportion,1},{border,20}]) || Text <- Texts],
  wxSizer:add(Sizer,StaticBitmap,[{flag,?wxALIGN_CENTER},{proportion,1}]),
  wxSizer:add(Sizer,Button,[{flag,?wxALIGN_CENTER},{border,20}]),
  wxSizer:addSpacer(Sizer, 20),
  wxSizer:add(Sizer, AnswersBox, [{flag,?wxALIGN_CENTER},{proportion,1}]),
  wxSizer:addSpacer(Sizer, 120),


  wxPanel:setSizer(Panel,Sizer),
  wxSizer:fit(Sizer,Panel),
  wxFrame:center(Frame),
  wxFrame:fit(Frame),
  wxFrame:show(Frame),

  wxFrame:connect( Frame, close_window),
  wxPanel:connect(Panel, command_button_clicked),

  clientApp:game_loop({Frame,Panel}, Name,{Rebus}).







