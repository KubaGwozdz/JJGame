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

%% API
-export([]).

start ()->
  Wx = wx:new(),
  Frame = wxFrame:new(Wx, -1, "Main Game Frame", [{size, {500, 500}}]),
  Panel = wxPanel:new(Frame),
  wxFrame:connect(Panel, paint),
  wxPanel:connect(Panel, paint, [callback]),
  wxPanel:connect(Panel, left_up, []),
  wxPanel:connect(Panel, right_down, []),
  wxPanel:connect(Panel, middle_down, []),
  Image = wxImage:new("/Users/Julianek/AGH/4semestr/ERL/projekt/JJGame/reb1.jpg"),
  wxFrame:show(Frame),
  draw_image(0,0,Panel, Image).

draw_image(X, Y, Panel, Image) ->
  Pos = {round(X), round(Y)},
  ClientDC = wxClientDC:new(Panel),
  Bitmap = wxBitmap:new(Image),
  wxDC:drawBitmap(ClientDC, Bitmap, Pos),
  wxBitmap:destroy(Bitmap),
  wxClientDC:destroy(ClientDC).