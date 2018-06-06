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

%% API
-export([start/0]).


start ()->
  Wx = wx:new(),
  Frame = wxFrame:new(Wx, -1, "Main Game Frame", [{size, {500, 500}}]),
  Panel = wxPanel:new(Frame),
  wxFrame:connect(Panel, paint),
  wxPanel:connect(Panel, paint, [callback]),
  wxPanel:connect(Panel, left_up, []),
  wxPanel:connect(Panel, right_down, []),
  wxPanel:connect(Panel, middle_down, []),
  Image = wxImage:new("/Users/kuba/Desktop/DSC_9490.PNG"),
  wxFrame:show(Frame),
  draw_image(0,0,Panel, Image).


draw_image(X, Y, Panel, Image) ->
  Pos = {round(X), round(Y)},
  ClientDC = wxClientDC:new(Panel),
  Bitmap = wxBitmap:new(Image),
  wxDC:drawBitmap(ClientDC, Bitmap, Pos),
  wxBitmap:destroy(Bitmap),
  wxClientDC:destroy(ClientDC).

