-module(file_reader).

-include_lib("kernel/include/logger.hrl").

-export([read/1]).

-define(BLOCK_LENGTH, 1048576).
-define(FILE_NAME, "big_file").

read(Timeout) ->
  PrivDir = code:priv_dir(sync_file_reading),
  FilePath = filename:join(PrivDir, ?FILE_NAME),
  {ok, IoDevice} = file:open(FilePath, [read, binary, raw]),
  TimeLimit = os:system_time(millisecond) + Timeout,
  read_block(IoDevice, TimeLimit).

read_block(IoDevice, TimeLimit) ->
  read_block(IoDevice, TimeLimit, 0, ?BLOCK_LENGTH).
read_block(IoDevice, TimeLimit, Start, Number) ->
  CurrentTime = os:system_time(millisecond),
  if CurrentTime > TimeLimit ->
    ok = file:close(IoDevice),
    {error, timeout};
  true ->
    case file:pread(IoDevice, Start, Number) of
      {ok, _Data} ->
        read_block(IoDevice, TimeLimit, Start + Number, Number);
      eof ->
        ok = file:close(IoDevice),
        {ok, readed};
      {error, Error} ->
        ?LOG_ERROR("Error while block reading: ~p", [Error]),
        ok = file:close(IoDevice),
        {error, Error}
    end
  end.

% term_to_string(Term) ->
%   R = io_lib:format("~p",[Term]),
%   lists:flatten(R).
