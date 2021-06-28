-module(readfile_handler).

-export([init/2]).

-define(DEFAULT_TIMEOUT, 5000).

init(Req0, State) ->
  #{timeout := Timeout0} = cowboy_req:match_qs([{timeout, [], ?DEFAULT_TIMEOUT}], Req0),
  Timeout = format_timeout(Timeout0),

  {Code, Msg}
    = case file_reader:read(Timeout) of
        {ok, readed} -> {200, <<"Successfully read">>};
        {error, timeout} -> {503, <<"Overloaded">>};
        {error, _Error} -> {500, <<"Internal server error">>}
      end,

  Req = cowboy_req:reply(Code,
                         #{<<"content-type">> => <<"text/plain">>},
                         Msg,
                         Req0),
  {ok, Req, State}.

format_timeout(Timeout0) ->
  try
    binary_to_integer(Timeout0)
  catch
    _ -> ?DEFAULT_TIMEOUT
  end.

% term_to_string(Term) ->
%   R = io_lib:format("~p",[Term]),
%   lists:flatten(R).