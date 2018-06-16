%%%-------------------------------------------------------------------
%%% @author kuba
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. cze 2018 15:36
%%%-------------------------------------------------------------------
-module(answersServer).
-author("kuba").
-behavior(gen_server).

-record(answer, {answer, pid, points}).

%% API
-export([start_link/0, init/1]).
-export([handle_call/3]).
-export([get_answers/0,add_rebus/1, add_answer/3, get_rebus_answers/1, add_point/2, get_reb_answers_list/1]).


start_link() ->
  gen_server:start_link({global, ?MODULE}, ?MODULE, [],[]).

init(A) -> {ok,maps:new()}.  % key: Rebus val: [#answer]


get_answers() -> gen_server:call({global, ?MODULE}, {get_answers}).

add_rebus(Rebus) -> gen_server:call({global, ?MODULE}, {add_rebus, Rebus}).

add_answer(Rebus, Answer, PID) -> gen_server:call({global, ?MODULE}, {add_answer,Rebus, Answer, PID}).

add_point(Rebus, Answer) ->gen_server:call({global, ?MODULE}, {add_point,Rebus, Answer}).

get_rebus_answers(Rebus) -> gen_server:call({global, ?MODULE}, {get_rebus_answers, Rebus}).

get_reb_answers_list(Rebus) -> gen_server:call({global, ?MODULE}, {get_reb_answers_list, Rebus}).


%% CALLBACKS

handle_call({get_answers}, _From, Answers) -> {reply, Answers, Answers};

handle_call({add_rebus, Rebus}, _From, Answers) ->
  R = maps:keys(Answers),
  Exists = lists:any(fun(X) -> X == Rebus end, R),
  if Exists /= true ->
    A1 = maps:put(Rebus, [], Answers),
    {reply, ok, A1};
    true -> {reply, rebusDoesNotExist, Answers}
  end;

handle_call({add_answer,Rebus, Answer, PID}, _From, Answers) ->
  R = maps:keys(Answers),
  Exists = lists:any(fun(X) -> X==Rebus end, R),
  if Exists == true ->
    RebusAnswers = maps:get(Rebus, Answers),
    Updated = lists:append([#answer{answer = Answer, pid = PID, points = 0}],RebusAnswers),
    NewAnswers = maps:update(Rebus, Updated, Answers),
    {reply, ok, NewAnswers};
    true -> {reply, rebusDoesNotExist, Answers}
  end;

handle_call({get_rebus_answers, Rebus}, _From, Answers) ->
  RebusAnwers = maps:get(Rebus, Answers),
  {reply, RebusAnwers, Answers};

handle_call({add_point,Rebus, Answer}, _From, Answers) ->
  R = maps:keys(Answers),
  Exists = lists:any(fun(X) -> X==Rebus end, R),
  if Exists == true ->
    RebusAnswers = maps:get(Rebus, Answers),
    %An = lists:map(fun(#answer{answer = X}) -> X end, RebusAnswers),
    An1 = lists:filter(fun(#answer{answer = A}) -> A == Answer end, RebusAnswers),
    if length(An1) /= 0 ->
      #answer{answer = Answer, pid=PID, points = Points} = lists:nth(1,An1),
      NewAnswer = #answer{answer = Answer, pid = PID, points = Points+1},
      boardServer:add_client_point(PID),                                        %%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      UpdatedRebusAnswers = lists:append([NewAnswer], lists:delete(#answer{answer = Answer, points = Points, pid = PID},RebusAnswers)),
      UpdatedAnswers = maps:update(Rebus,UpdatedRebusAnswers, Answers),
      {reply, ok, UpdatedAnswers};
      true -> {reply, {wrongAnswer,An1, RebusAnswers}, Answers}
    end;
    true -> {reply, rebusDoesNotExist, Answers}
  end;


handle_call({get_reb_answers_list, Rebus}, _From, Answers) ->
  RebusAnwers = maps:get(Rebus, Answers),
  AnsList = lists:map(fun(#answer{answer = A}) -> A end, RebusAnwers),
  {reply, AnsList, Answers}.






