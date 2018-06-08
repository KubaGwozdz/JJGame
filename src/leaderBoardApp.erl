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
  wxFrame:connect(Panel, paint),
  wxPanel:connect(Panel, paint, [callback]),
  wxPanel:connect(Panel, left_up, []),
  wxPanel:connect(Panel, right_down, []),
  wxPanel:connect(Panel, middle_down, []),
  wxPanel:setBackgroundColour(Panel,?wxWHITE),
  Button1 = wxButton:new(Panel,1,[{pos,{100,250}},{label,"PLAY 1 TURN"}]),

  OnPaint = fun(_Evt, _Obj) ->
    Paint = wxPaintDC:new(Panel),
    Font = wxFont:new(30, ?wxFONTFAMILY_MODERN, ?wxFONTSTYLE_NORMAL, ?wxFONTWEIGHT_BOLD),
    wxDC:setFont(Paint,Font),
    wxDC:drawText(Paint, "Welcome to Rebus game!", {60, 100}),
    wxFont:destroy(Font),
    Font2 = wxFont:new(14,?wxFONTFAMILY_MODERN, ?wxFONTSTYLE_NORMAL, ?wxFONTWEIGHT_LIGHT),
    wxDC:setFont(Paint,Font2),
    wxDC:drawText(Paint, "Please enter your username and then click START", {60,150}),
    wxFont:destroy(Font2),
    Pen = wxPen:new(),
    wxPen:setWidth(Pen,5),
    wxPen:setColour(Pen,102,192,255),
    wxDC:setPen(Paint,Pen),
    wxDC:drawLine(Paint,{0, 190}, {200,190}),
    wxDC:drawCircle(Paint,{200,190},5),
    wxPen:destroy(Pen),
    Pen2 = wxPen:new(),
    wxPen:setWidth(Pen2,5),
    wxPen:setColour(Pen2,25,223,19),
    wxDC:setPen(Paint,Pen2),
    wxDC:drawCircle(Paint,{230,190},5),
    wxPen:destroy(Pen2),
    Pen3 = wxPen:new(),
    wxPen:setWidth(Pen3,5),
    wxPen:setColour(Pen3,221,16,78),
    wxDC:setPen(Paint,Pen3),
    wxDC:drawCircle(Paint,{260,190},5),
    wxPaintDC:destroy(Paint),
    wxPen:destroy(Pen3)
    end,

  wxFrame:connect(Panel, paint, [{callback, OnPaint}]),
  wxFrame:connect(Panel, close_window),
  wxFrame:center(Frame),
  wxFrame:show(Frame).