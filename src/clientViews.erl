%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. cze 2018 14:23
%%%-------------------------------------------------------------------
-module(clientViews).
-author("kuba").

%% API
-export([choose_answer_view/0, give_answer_view/0,waiting_view/0, your_points_view/0]).


choose_answer_view() ->
  boardServer:start_link(),
  boardServer:add_client(1),
  boardServer:register_client(1,"k"),
  answersServer:start_link(),
  answersServer:add_rebus(1),
  answersServer:add_answer(1,"Julianek", 12),
  answersServer:add_answer(1,"Bubus", 13),
  Parent = wx:new(),
  Frame = wxFrame:new(Parent, -1, "Rebus Game", [{size, {500, 500}}]),
  clientFrames:show_choose_answer_frame({Frame,wxPanel:new(Frame)}, 1, "Kuba").

give_answer_view() ->
  answersServer:start_link(),
  answersServer:add_rebus(1),
  Parent = wx:new(),
  Frame = wxFrame:new(Parent, -1, "Rebus Game", [{size, {500, 500}}]),
  clientFrames:show_give_answer_frame({Frame,wxPanel:new(Frame)}, 1, "Kuba").

waiting_view() ->
  Parent = wx:new(),
  Frame = wxFrame:new(Parent, -1, "Rebus Game", [{size, {500, 500}}]),
  clientFrames:show_waiting_frame({Frame,wxPanel:new(Frame)}, "Kuba").


your_points_view() ->
  Parent = wx:new(),
  Frame = wxFrame:new(Parent, -1, "Rebus Game", [{size, {500, 500}}]),
  boardServer:start_link(),
  boardServer:add_client(self()),
  boardServer:register_client(self(),"Kuba"),
  boardServer:add_client_point(self()),
  clientFrames:show_your_points_frame({Frame,wxPanel:new(Frame)}, 1, "Kuba").