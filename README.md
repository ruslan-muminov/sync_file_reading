# sync_file_reading

### compile and run

`make run`

### entrypoints (stand)

 - `http://92.63.102.202:8080/ping`

 To check that the server is alive.

 - `http://92.63.102.202:8080/readfile`

 File reading. There is only one input parametr `timeout` (in milliseconds). By default `timeout = 5 sec`.
 For the most correct work please use HTTP/2 (for concurrent requests). For example: `nghttp -v http://92.63.102.202:8080/readfile?timeout=100`